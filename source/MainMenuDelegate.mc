using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// main menu handler
//
class MainMenuDelegate extends Ui.MenuInputDelegate 
{
    hidden var _cruiseView;
    hidden var _gpsWrapper;
    hidden var _raceTimerView;
    hidden var _lapView;
    
    function initialize(cruiseView, raceTimerView, lapView, gpsWrapper) 
    {
        MenuInputDelegate.initialize();
        _cruiseView = cruiseView;
        _raceTimerView = raceTimerView;
        _lapView = lapView;
        _gpsWrapper = gpsWrapper;
    }

    function onMenuItem(item) 
    {
    	if (item == :raceTimer)
    	{
    		Ui.pushView(_raceTimerView, new RaceTimerViewDelegate(_raceTimerView), Ui.SLIDE_RIGHT);
    	}
        else if (item == :cruiseView)
        {
            Ui.pushView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_RIGHT);
        }
        else if (item == :lapView)
        {
            Ui.pushView(_lapView, new LapViewDelegate(_lapView), Ui.SLIDE_RIGHT);
        }         
        else if (item == :setting)
        {
            Ui.pushView(new Rez.Menus.SettingMenu(), new SettingMenuDelegate(), Ui.SLIDE_LEFT);
        }
        else if (item == :exitSave) 
        {
            _gpsWrapper.SaveRecord();
            Sys.exit();
        } 
        else if (item == :exitDiscard) 
        {
            _gpsWrapper.DiscardRecord();
            Sys.exit();
        }   
    }
}
