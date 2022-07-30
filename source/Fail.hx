package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;

class Fail extends FlxState
{
	var quit:FlxSprite;
	var retry:FlxSprite;

	override public function create()
	{
		FlxG.mouse.load('assets/images/Cursor.png', 1);
		var fail:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/Fail.png');
		fail.screenCenter();
		fail.alpha = 0;
		add(fail);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			if (fail.alpha < 1)
			{
				fail.alpha += 0.1;
				tmr.reset();
			}
		});
		quit = new FlxSprite(180, 580).loadGraphic('assets/images/Quit.png');
		add(quit);
		retry = new FlxSprite(900, 560).loadGraphic('assets/images/Retry.png');
		add(retry);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(retry))
			{
				FlxG.switchState(new PlayState());
			}
			if (FlxG.mouse.overlaps(quit))
			{
				FlxG.switchState(new TitleState());
			}
		}
		super.update(elapsed);
	}
}
