using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Attention as Attention;
using Toybox.ActivityRecording as Fit;

class IBSailingCruiseView extends Ui.View 
{

	hidden var _dcDraw = new DcDraw();
	hidden var _timer;
	hidden var _positionInfo;
	hidden var _maxSpeed;
	hidden var _activeSession;
	hidden var _isInversed = false;
	hidden var _gpsStatus = 0;
	
	hidden var _speedSum = 0.0;
	hidden var _speedCount = 0;

    function initialize() 
    {
        View.initialize();
        _activeSession = Fit.createSession({:name=>"Sailing", :sport=>Fit.SPORT_GENERIC});
        _maxSpeed = 0.0;
    }

    // SetUp timer on show to update every second
    //
    function onShow() 
    {
    	_timer = new Timer.Timer();
    	_timer.start(method(:onTimerUpdate), 1000, true);
    }

    // Update the view
    //
    function onUpdate(dc) 
    {   
    	_dcDraw.ClearDc(dc);
    
    	var clockTime = Sys.getClockTime();
    	
    	// Display current time
    	//
        var timeString = Lang.format("$1$:$2$:$3$", 
        	[clockTime.hour.format("%02d"), 
        	 clockTime.min.format("%02d"), 
        	 clockTime.sec.format("%02d")]);
        _dcDraw.PrintTime(dc, timeString);
        
        // Display speed and bearing if GPS available
        //
        if (_positionInfo != null && _positionInfo.accuracy > 0)
        {
        	_gpsStatus = _positionInfo.accuracy;
        
        	// Display knots
        	//
        	var speed = (_positionInfo.speed.toDouble() * 1.94384);
        	var speedString = speed.format("%2.1f");
        	_dcDraw.PrintSpeed(dc, speedString);
        	
        	// Display bearing
        	//
        	var headingDegree = Math.toDegrees(_positionInfo.heading);
        	var bearingString = ((headingDegree > 0) ? headingDegree : 360 + headingDegree).format("%003d");
        	_dcDraw.PrintBearing(dc, bearingString);
        	
        	// Display max speed 
        	//
        	_maxSpeed = (_maxSpeed < speed) ? speed : _maxSpeed;
        	_dcDraw.PrintMaxSpeed(dc, _maxSpeed.format("%2.1f"));	
        	
        	// Display average speed if recorded
        	//
        	if (_activeSession.isRecording())
        	{
        		_speedCount = _speedCount + 1;
        		_speedSum = _speedSum + speed;
        		var avgSpeed = _speedSum / _speedCount;
        		_dcDraw.PrintAvgSpeed(dc, avgSpeed.format("%2.1f"));  
        	}      	
        }
        
        _dcDraw.DisplayState(dc, _gpsStatus, _activeSession.isRecording());
        
        _dcDraw.DrawGrid(dc);
    }

    // Stop timer then hide
    //
    function onHide() 
    {
    	_timer.stop();
    }
    
    // Refresh view every second
    //
    function onTimerUpdate()
    {
    	Ui.requestUpdate();
    }
    
    // update position from GPS
    //
    function setPosition(info)
    {
    	_positionInfo = info;
    }
    
    // Start & Pause activity recording
    //
    function StartStopActivity()
    {
    	if (_gpsStatus < 2 && !_activeSession.isRecording())
    	{
    		return;
    	}
    	
    	var vibe = [new Attention.VibeProfile(30, 300)];
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(vibe);
    	
    	if (!_activeSession.isRecording())
    	{
    		_activeSession.start();
    	}
    	else
    	{
    		_speedSum = 0.0;
    		_speedCount = 0;
    		_activeSession.stop();
    	}
    }

    function SaveActivity()
    {
    	if (_activeSession != null)
    	{
    		_activeSession.save();
    	}
    }
    
    function DiscardActivity()
    {
        if (_activeSession != null)
    	{
    		_activeSession.discard();
    	}
    }
    
    function InverseLayout()
    {
    	_isInversed = !_isInversed;
    	if (_isInversed)
    	{
    		_dcDraw.SetupColors(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	}
    	else
    	{
    		_dcDraw.SetupColors(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	}
    }
}
