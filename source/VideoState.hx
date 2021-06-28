//VideoState.hx KE 1.5> Fix by Raltyro
//Requires KadeDev extension-webm (NOT GWEBDEV EXTENSION-WEBM)

package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.io.Path;
import openfl.Lib;
#if cpp
import webm.*;
import webm.WebmPlayer;
#end

using StringTools;

class VideoState extends MusicBeatState {
	public static var webmHandler:WebmHandler;
	public var videoSprite:FlxSprite;
	
	public var filePath:String;
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var fixr:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;

	public function new(fileName:String,toTrans:FlxState,frameSkipLimit:Int = 10,autopause:Bool = false) {
		super();

		autoPause = autopause;

		filePath = fileName;
		transClass = toTrans;
		if (frameSkipLimit != -1 && GlobalVideo.isWebm) {
			WebmPlayer.SKIP_STEP_LIMIT = frameSkipLimit;
		}
	}

	override function create() {
		super.create();
		FlxG.autoPause = false;
		doShit = false;
		
		if (GlobalVideo.isWebm)
		{
			var data:Array<String> = (Assets.getText(filePath.replace(".webm",".txt"))).split(':');
			videoFrames = Std.parseInt(data[0]);
			fixr = Std.parseInt(data[1]);
		}

		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;

		if (GlobalVideo.isWebm) {
			if (Assets.exists(filePath.replace(".webm", ".ogg"), MUSIC) || Assets.exists(filePath.replace(".webm", ".ogg"), SOUND)) {
				useSound = true;
				vidSound = FlxG.sound.play(filePath.replace(".webm", ".ogg"));
			}
		}

		var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
		var str1:String = "WEBM SHIT"; 
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		GlobalVideo.setWebm(webmHandler);

		GlobalVideo.get().source(filePath);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();

		if (GlobalVideo.isWebm) {
			GlobalVideo.get().restart();
		} 
		else {
			GlobalVideo.get().play();
		}

		var data = webmHandler.webm.bitmapData;

		videoSprite = new FlxSprite().loadGraphic(data);
		
		// DOESNT WORK??
		if (fixr == 1)
			videoSprite.setGraphicSize(Std.int(1280/(((16 / 9) / videoSprite.width) * videoSprite.height)),Std.int(1280));
		else
			videoSprite.setGraphicSize(Std.int(1280));
		videoSprite.screenCenter();

		/*if (useSound)
			{ */
		// vidSound = FlxG.sound.play(filePath.replace(".webm", ".ogg"));

		/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{ */
		vidSound.time = vidSound.length * soundMultiplier;
		/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				if (useSound)
				{
					vidSound.time = vidSound.length * soundMultiplier;
				}
		}, 0);*/
		doShit = true;
		// }, 1);
		// }

		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing) {
			musicPaused = true;
			FlxG.sound.music.pause();
		}
		add(videoSprite);
		webmHandler.resume();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if (useSound) {
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			if (soundMultiplier > 1) {
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0) {
				soundMultiplier = 0;
			}
			if (doShit) {
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit
					|| vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit) {
				if (soundMultiplier == 0) {
					if (prevSoundMultiplier != 0) {
						vidSound.pause();
						vidSound.time = 0;
					}
				} else {
					if (prevSoundMultiplier == 0) {
						vidSound.resume();
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}
				prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone) {
			FlxG.sound.music.volume = 0;
		}
		
		webmHandler.update(elapsed);

		if (controls.ACCEPT || GlobalVideo.get().ended || GlobalVideo.get().stopped) {
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}

		if (controls.ACCEPT || GlobalVideo.get().ended) {
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			FlxG.autoPause = true;
			GlobalVideo.get().stop();
			if (musicPaused) {
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			remove(videoSprite);
			FlxG.switchState(transClass);
		}

		if (GlobalVideo.get().played || GlobalVideo.get().restarted) {
			GlobalVideo.get().show();
		}

		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}