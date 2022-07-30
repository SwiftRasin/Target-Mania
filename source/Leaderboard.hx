package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class Leaderboard extends FlxState
{
	var leaderboard:Array<Dynamic> = [];

	var leaderboardSorted:Array<Dynamic> = [];

	var xForDiffs:Array<Float> = [];

	var stuff:FlxTypedGroup<FlxText>;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/leaderboardBG.png');
		bg.x = 0;
		bg.y = 0;
		add(bg);
		stuff = new FlxTypedGroup<FlxText>();
		add(stuff);
		leaderboard = FlxG.save.data.saves;
		// Sort by Best time to Worst time ( [1] )
		// Organize by each difficulty ( [0] )
		/*for (i in 0...leaderboard.length)
			{
				for (i2 in 0...leaderboard.length)
				{
					if (leaderboard[i][1] != leaderboard[i2][1])
					{
						if (leaderboard[i][1] > leaderboard[i2][1])
						{
							leaderboardSorted.push(leaderboard[i]);
						}
					}
				}
			}
		 */
		leaderboardSorted = leaderboard;
		leaderboardSorted.sort(sortByCrap); // stolen from FNF cuz I have not found other instances of array sorting with FlxSort
		makeTexts();
		makeDiffs();
		super.create();
	}

	function sortByCrap(Obj1:Dynamic, Obj2:Dynamic):Int
	{
		return FlxSort.byValues(FlxSort.DESCENDING, Obj1[1], Obj2[1]);
	}

	private function makeTexts()
	{
		for (i in 0...leaderboardSorted.length)
		{
			var run:FlxText = new FlxText(200, 50 * (i + 1), '' + leaderboardSorted[i][1], 54);
			run.updateHitbox();
			xForDiffs.push(run.x + run.width);
			stuff.add(run);
		}
	}

	private function makeDiffs()
	{
		for (i in 0...xForDiffs.length)
		{
			var diff:FlxText = new FlxText(xForDiffs[i] + 400, 50 * (i + 1), '', 54);
			switch (leaderboardSorted[i][0])
			{
				case 1:
					diff.text = 'Easy';
					diff.color = FlxColor.LIME;
				case 2:
					diff.text = 'Normal';
					diff.color = FlxColor.YELLOW;
				case 3:
					diff.text = 'Hard';
					diff.color = FlxColor.RED;
				case 4:
					diff.text = 'Insane';
					diff.color = FlxColor.PURPLE;
			}
			stuff.add(diff);
		}
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new TitleState());
		}
		if (FlxG.keys.pressed.UP || FlxG.mouse.wheel > 0)
		{
			for (i in stuff)
			{
				i.y += 40;
			}
		}
		if (FlxG.keys.pressed.DOWN || FlxG.mouse.wheel < 0)
		{
			for (i in stuff)
			{
				i.y -= 40;
			}
		}
		super.update(elapsed);
	}
}
