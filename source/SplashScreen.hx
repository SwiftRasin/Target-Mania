package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class SplashScreen extends FlxState
{
	override public function create()
	{
		Data.initSaves();
		var splashLogo:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/Splash/HaxeJamSplash1.png');
		splashLogo.visible = false;
		add(splashLogo);
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			switch (tmr.elapsedLoops)
			{
				case 2:
					splashLogo.visible = true;
				case 4:
					splashLogo.loadGraphic('assets/images/Splash/HaxeJamSplash2.png');
				case 5:
					splashLogo.loadGraphic('assets/images/Splash/HaxeJamSplash3.png');
				case 6:
					splashLogo.loadGraphic('assets/images/Splash/HaxeJamSplash4.png');
				case 7:
					splashLogo.loadGraphic('assets/images/Splash/HaxeJamSplash5.png');
			}
		}, 8);
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxTween.tween(splashLogo, {alpha: 0}, 1, {type: ONESHOT});
		});
		FlxG.sound.play('assets/sounds/flixel.ogg', 1, false, null, true, function()
		{
			FlxG.sound.playMusic('assets/music/track.ogg');
			FlxG.switchState(new TitleState());
		});
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
