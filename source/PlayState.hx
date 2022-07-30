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

class PlayState extends FlxState
{
	var bg:FlxSprite;

	var targets:FlxTypedGroup<Target>;

	var scoreText:FlxText;

	var score:Int = 0;

	public static var difficulty:Int = TitleState.diff; // Defaults to normal mode.

	var hasStarted:Bool = false;

	var damageFrames:Bool = false;

	//	var totalClouds:Int = 0;
	var lives:Int = 3;

	var livesText:FlxText;

	var timeElapsed:Float = 0;

	var timeText:FlxText;

	var timerStarted:Bool = false;

	var hasLost:Bool = false;

	var targCam:FlxCamera;
	var decoyCam:FlxCamera;

	override public function create()
	{
		FlxG.mouse.load('assets/images/Cursor.png', 1);

		decoyCam = new FlxCamera();
		decoyCam.bgColor.alpha = 0;
		targCam = new FlxCamera();
		targCam.bgColor.alpha = 0;
		FlxG.cameras.add(decoyCam);
		FlxG.cameras.add(targCam);

		var banner:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/banner.png');
		banner.x = 0;
		banner.y = 0;
		add(banner);
		difficulty = TitleState.diff;
		trace(difficulty);
		switch (difficulty)
		{
			case 1:
				lives = 6;
			case 2:
				lives = 5;
			case 3:
				lives = 4;
			case 4:
				lives = 3;
		}
		targets = new FlxTypedGroup<Target>();
		add(targets);
		var countdown:Int = 0;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (countdown == 3 && timerStarted == false)
				timer();
			if (countdown > 2)
			{
				hasStarted = true;
				for (i in 0...30)
				{
					new FlxTimer().start(FlxG.random.float(1, 10 + (i * 2)), function(tmr:FlxTimer)
					{
						var newX:Float = new FlxRandom().bool() ? -100 : 1380;
						var target:Target = new Target(newX, 630);
						target.screenCenter(X);
						target.visible = false;
						targets.add(target);
						if (target.type != 'decoy')
						{
							target.cameras = [targCam];
						}
						else
						{
							target.cameras = [decoyCam];
						}
						moveDaTarget(target);
					});
				}
				tmr.reset(10);
			}
			else
			{
				countdown++;
				switch (countdown)
				{
					case 1:
						scoreText.text = '2';
					case 2:
						scoreText.text = '1';
					case 3:
						scoreText.text = 'Go!';
				}
				daCoolGain();
				tmr.reset(1);
			}
		});
		scoreText = new FlxText(70, 100, '3', 60);
		scoreText.screenCenter(X);
		scoreText.alignment = 'center';
		add(scoreText);
		livesText = new FlxText(70, 100, 'Lives: 3', 60);
		livesText.screenCenter(X);
		livesText.x += 400;
		livesText.alignment = 'center';
		add(livesText);
		timeText = new FlxText(70, 100, 'Time: 0', 60);
		timeText.screenCenter(X);
		timeText.x -= 400;
		timeText.alignment = 'center';
		add(timeText);
		super.create();
	}

	private function timer()
	{
		timerStarted = true;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			timeElapsed++;
			timeText.text = 'Time: ' + timeElapsed;
			tmr.reset(1);
		});
	}

	private function fade()
	{
		if (hasLost == false)
		{
			hasLost = true;
			var fade:FlxSprite = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.BLACK);
			fade.alpha = 0;
			add(fade);

			trace('saving data');
			Data.saveData(timeElapsed, difficulty, score);

			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				if (fade.alpha < 1)
				{
					fade.alpha += 0.1;
					tmr.reset();
				}
				else
				{
					FlxG.switchState(new Fail()); // you lost all of your lives L
					// SAVE RUN TO DATA YAYAYYAYYAYAYAYA
				}
			});
		}
	}

	private function moveDaTarget(target:Target)
	{
		var countofActives:Int = 0;
		for (target in targets)
		{
			if (target.isActive)
				countofActives++;
		}
		new FlxTimer().start(FlxG.random.float(1, 10 + (countofActives * 5)), function(tmr:FlxTimer)
		{
			target.hasShot = false;
			target.visible = true;
			target.y = 820;
			target.screenCenter(X);
			//			target.x = FlxG.random.float(100, 1180);
			//			FlxTween.linearMotion(target, target.x, target.y, target.x, FlxG.random.float(330, 440), 1.5, true, {
			//				onComplete: function(twn:FlxTween)
			//				{
			target.hasShot = false;
			target.acceleration.y = 600;
			target.velocity.y -= 850;
			target.velocity.x += FlxG.random.int(-150, 150);
			target.hasShot = true;
			target.isActive = true;

			//					target.velocity.x += FlxG.random.int(1, 10);
			//				}
			//			});
		});
	}

	private function daCoolGain(?both:Bool = false)
	{
		scoreText.scale.x = 1.5;
		scoreText.scale.y = 1.5;
		FlxTween.tween(scoreText, {"scale.x": 1, "scale.y": 1}, 0.3);
		if (both)
		{
			livesText.scale.x = 1.5;
			livesText.scale.y = 1.5;
			FlxTween.tween(livesText, {"scale.x": 1, "scale.y": 1}, 0.3);
		}
	}

	private function daLose()
	{
		trace('LOST L');
		lives--;
		//		FlxG.switchState(new TitleState());
		daCoolGain(true);
		damageFrames = true;
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			scoreText.visible = !scoreText.visible;
			if (tmr.elapsedLoops == 10)
			{
				scoreText.visible = true;
				damageFrames = false;
			}
		}, 10);
		if (lives <= 0)
			fade();
	}

	override public function update(elapsed:Float)
	{
		for (target in targets)
		{
			if ((target.x < -100 || target.x > 1380 || target.y > 820) && target.hasShot == true)
			{
				if (target.isActive == true && target.visible == true /* && target.type != 'decoy'*/) // Checks if you missed it or not
				{
					if (target.type != 'decoy')
					{
						var touchingDecoy:Bool = false;
						for (targ2 in targets)
						{
							if (targ2.ID != target.ID && targ2.type == 'decoy')
							{
								if (targ2.overlaps(target))
								{
									touchingDecoy = true;
								}
							}
						}
						if (touchingDecoy == false)
						{
							trace('YOU MISSED L'); // Loss of all points L
							if (damageFrames == false && hasLost == false)
							{
								score = 0;
								daLose();
							}
							target.velocity.x = 0;
							target.acceleration.x = 0;
							target.velocity.y = 0;
							target.acceleration.y = 0;
							target.y = -200;
							target.screenCenter(X);
						}
					}
					else
					{
						// nothing here moment
					}

					//					moveDaTarget(target);
				}
				else
				{
					// nothing here moment
				}
			}
			if (FlxG.mouse.overlaps(target))
			{
				if (FlxG.mouse.justPressed)
				{
					trace('Target shot down'); // You gain points now!
					if (target.type != 'decoy')
					{
						target.visible = false;
						target.isActive = false;
					}
					switch (target.type)
					{
						case 'default':
							score++;
							daCoolGain();
							FlxG.sound.play('assets/sounds/hit.ogg');
						case 'blue':
							score += 5;
							daCoolGain();
							FlxG.sound.play('assets/sounds/hit.ogg');
						case 'gold':
							score += 20;
							daCoolGain();
							FlxG.sound.play('assets/sounds/hit.ogg');
						case 'decoy':
							target.visible = false;
							target.isActive = false;
							if (damageFrames == false && hasLost == false)
							{
								FlxG.sound.play('assets/sounds/miss.ogg');
								score = 0;
								daLose();
							}
					}
					var mark:FlxSprite = new FlxSprite(target.x, target.y).loadGraphic('assets/images/Mark.png');
					mark.centerOrigin();
					mark.x = target.x;
					mark.y = target.y;
					add(mark);
					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
						remove(mark);
					});
				}
			}
		}
		if (hasStarted == true)
		{
			scoreText.text = 'Score: ' + score;
			scoreText.screenCenter(X);
		}
		livesText.text = 'Lives: ' + lives;
		/*for (target in targets)
			{
				if (target.type == 'decoy')
				{
					for (targ2 in targets)
					{
						if (targ2.ID != target.ID)
						{
							if (targ2.overlaps(target))
							{
								FlxG.collide(targ2, target);
							}
						}
					}
				}
			}
		 */ /*for (target in targets)
			{
				for (target2 in targets)
				{
					if (target2.ID != target.ID)
					{
						if (target.overlaps(target2))
						{
							target.velocity.x += FlxG.random.int(40, 80);
							target2.velocity.x += FlxG.random.int(-80, -40);
						}
					}
				}
			}
		 */
		super.update(elapsed);
	}
}
