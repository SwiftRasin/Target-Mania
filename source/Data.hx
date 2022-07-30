package;

import flixel.FlxG;
import flixel.util.FlxSort;

class Data
{
	public static function initSaves()
	{
		FlxG.save.bind('Haxejam2022');
		if (FlxG.save.data.saves == null)
			FlxG.save.data.saves = [];
	}

	public static function saveData(time:Float, difficulty:Int, score:Int)
	{
		var saves:Array<Dynamic> = [];
		saves = FlxG.save.data.saves;
		saves.push([difficulty, time, score]);

		FlxG.save.data.saves = saves;
	}
}

typedef Save =
{
	var difficulty:Int;
	var time:Float;
}
