package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class CreditsState extends MusicBeatState
{

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue', 'preload'));
		bg.screenCenter();
		add(bg);
	
        super.create();
		var credits:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits', 'preload'));
		credits.setGraphicSize(Std.int(credits.width * .65));
		credits.screenCenter();
		add(credits);
	}


	override function update(elapsed:Float)
	{
		if (controls.ACCEPT || controls.BACK)
		{
			if (FlxG.random.bool(2)) {
				LoadingState.loadAndSwitchState(new VideoState("assets/videos/cheeky_cutscene_1.webm",new MainMenuState()));
			}
			else {
				FlxG.switchState(new MainMenuState());
			}
		}
		super.update(elapsed);
	}
}