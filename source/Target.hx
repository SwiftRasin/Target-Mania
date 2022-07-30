package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

class Target extends FlxSprite
{
	var ogX:Float;
	var ogY:Float;
	var newX:Float;
	var newY:Float;

	public var type:String;

	public var hasShot:Bool = false;
	public var isActive:Bool = false;

	public function new(ogX:Float, ogY:Float)
	{
		this.ogX = ogX;
		this.ogY = ogY;
		x = ogX;
		y = ogY;
		super();

		var costume:Int = new FlxRandom().int(1, PlayState.difficulty);
		switch (costume)
		{
			case 1: // Normal Target. Points per hit: 1
				loadGraphic('assets/images/targets/default.png');
				type = 'default';
			case 2: // Blue Target. Points per hit: 5
				loadGraphic('assets/images/targets/blue.png');
				type = 'blue';
			case 3: // Golden Target. Points per hit: 20
				loadGraphic('assets/images/targets/gold.png');
				type = 'gold';
				scale.x += 0.1;
				scale.y += 0.1;
				updateHitbox();
			case 4: // Decoy Target. On Hit: You LOSE IT ALL!
				loadGraphic('assets/images/targets/decoy.png');
				type = 'decoy';
			default:
				loadGraphic('assets/images/targets/default.png');
				type = 'default';
		}
	}
}
