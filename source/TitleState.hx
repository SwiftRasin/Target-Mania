package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TitleState extends FlxState
{
	var diffText:FlxText;

	public static var diff:Int = 3;

	var uiCam:FlxCamera;

	var normCam:FlxCamera;

	var infoCam:FlxCamera; // funny enough, the 'info' and 'info2' variables aren't actually in this camera

	var targets:FlxTypedGroup<Target>;

	var info:FlxSprite;
	var info2:FlxSprite;
	var infoControls:FlxText;

	var icon:FlxSprite;

	override public function create()
	{
		normCam = new FlxCamera();
		uiCam = new FlxCamera();
		infoCam = new FlxCamera();
		uiCam.bgColor.alpha = 0;
		infoCam.bgColor.alpha = 0;
		FlxG.cameras.add(normCam);
		FlxG.cameras.add(uiCam);
		FlxG.cameras.add(infoCam);
		FlxCamera.defaultCameras = [normCam];
		FlxG.mouse.unload();
		targets = new FlxTypedGroup<Target>();
		add(targets);
		targets.cameras = [normCam];
		var splashLogo:FlxSprite = new FlxSprite().loadGraphic('assets/images/Title.png');
		add(splashLogo);
		splashLogo.screenCenter(X);
		splashLogo.x -= 300;
		splashLogo.y += 75;
		diffText = new FlxText(70, 100, 'Normal', 60);
		diffText.screenCenter();
		diffText.x += 300;
		diffText.alignment = 'center';
		add(diffText);

		splashLogo.cameras = [uiCam];
		diffText.cameras = [uiCam];

		FlxTween.tween(splashLogo, {y: splashLogo.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			for (i in 0...30)
			{
				new FlxTimer().start(FlxG.random.float(1, 10 + (i * 2)), function(tmr:FlxTimer)
				{
					var newX:Float = new FlxRandom().bool() ? -100 : 1380;
					var target:Target = new Target(newX, 630);
					target.visible = false;
					targets.add(target);
					target.alpha = 0.6;
					target.cameras = [normCam];
					moveDaTarget(target);
				});
			}
			tmr.reset(10);
		});
		info = new FlxSprite(0, -720).loadGraphic('assets/images/Info.png');
		info.cameras = [uiCam];
		add(info);
		info2 = new FlxSprite(1280, -720).loadGraphic('assets/images/Info-2.png');
		info2.cameras = [uiCam];
		add(info2);
		infoControls = new FlxText(0, 620, 'Press I for Info', 60);
		infoControls.color = FlxColor.CYAN;
		infoControls.screenCenter(X);
		infoControls.cameras = [infoCam];
		add(infoControls);
		flashText(1, infoControls);
		icon = new FlxSprite(1230, 670).loadGraphic('assets/images/HaxeJamIcon.png');
		add(icon);
		super.create();
	}

	private function flashText(interval:Float, text:FlxText)
	{
		new FlxTimer().start(interval, function(tmr:FlxTimer)
		{
			text.visible = !text.visible;
			tmr.reset(interval);
		});
	}

	private function moveDaTarget(target:Target)
	{
		var countofActives:Int = 0;
		for (target in targets)
		{
			if (target.isActive)
				countofActives++;
		}
		new FlxTimer().start(FlxG.random.float(1, 5 + (countofActives * 5)), function(tmr:FlxTimer)
		{
			target.hasShot = false;
			target.visible = true;
			target.y = 820;
			target.x = FlxG.random.float(100, 1180);
			//			FlxTween.linearMotion(target, target.x, target.y, target.x, FlxG.random.float(330, 440), 1.5, true, {
			//				onComplete: function(twn:FlxTween)
			//				{
			target.hasShot = false;
			target.acceleration.y = 600;
			target.velocity.y -= 850;
			target.hasShot = true;
			target.isActive = true;

			//					target.velocity.x += FlxG.random.int(1, 10);
			//				}
			//			});
		});
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.overlaps(icon))
		{
			icon.scale.x = 1.1;
			icon.scale.y = 1.1;
			if (FlxG.mouse.justPressed)
			{
				FlxG.openURL('https://itch.io/jam/haxejam-2022-summer-jam');
			}
		}
		else
		{
			icon.scale.x = 1;
			icon.scale.y = 1;
		}
		if (FlxG.keys.justPressed.L)
			FlxG.switchState(new Leaderboard());
		if (FlxG.keys.justPressed.I)
		{
			if (info.y != 0)
			{
				FlxTween.tween(info, {y: 0}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				FlxTween.tween(info2, {y: 0}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				infoControls.text = '< Switch Page >';
			}
			else
			{
				FlxTween.tween(info, {y: -720}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				FlxTween.tween(info2, {y: -720}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				infoControls.text = 'Press I for Info';
			}
		}
		if ((FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) && info.y == 0)
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				FlxTween.tween(info, {x: 0}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				FlxTween.tween(info2, {x: 1280}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				FlxTween.tween(info, {x: -1280}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
				FlxTween.tween(info2, {x: 0}, 0.8, {ease: FlxEase.quadInOut, type: ONESHOT});
			}
		}
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new PlayState());
		if ((FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
			&& info.y != 0)
		{
			if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.RIGHT)
				diff++;
			if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.LEFT)
				diff--;
			if (diff < 1)
				diff = 4;
			if (diff > 4)
				diff = 1;
			trace(diff);
		}

		switch (diff)
		{
			case 1:
				diffText.text = '< Easy >';
				diffText.color = FlxColor.LIME;
			case 2:
				diffText.text = '< Normal >';
				diffText.color = FlxColor.YELLOW;
			case 3:
				diffText.text = '< Hard >';
				diffText.color = FlxColor.RED;
			case 4:
				diffText.text = '< Insane >';
				diffText.color = FlxColor.PURPLE;
		}

		super.update(elapsed);
	}
}
