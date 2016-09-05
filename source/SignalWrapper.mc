using Toybox.Attention as Attention;

// methods for signals
//
class SignalWrapper
{
	hidden static var _vibeBeep = [new Attention.VibeProfile(40, 300)];
	
	hidden static var _vibeStart = [
        new Attention.VibeProfile(  100, 100 ),
        new Attention.VibeProfile(  30, 200 ),
        new Attention.VibeProfile(  100, 100 ),
        new Attention.VibeProfile(  30, 200 ),
        new Attention.VibeProfile(  100, 100 )];
	
	static function PressButton()
	{
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(_vibeBeep);
	}
	
	static function HalfMinute()
	{
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(_vibeBeep);
	}
	
	static function TenSeconds(secLeft)
	{
		Attention.backlight(true);
    	Attention.playTone(Attention.TONE_LOUD_BEEP);
    	Attention.vibrate(_vibeBeep);
	}
	
	static function Start()
	{
	    Attention.playTone(Attention.TONE_CANARY);
    	Attention.vibrate(_vibeStart);
    	Attention.playTone(Attention.TONE_ALERT_HI);
    	//Attention.backlight(false);
	}
}
