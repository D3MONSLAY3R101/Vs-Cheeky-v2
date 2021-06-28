local defaultCamZoom,defaultHudZoom

local bg = "purple"--"assets/shared/images/mugenstuff/cheekyhouse/galaxy.png"
local white = "White"--"assets/data/bedrock/White.png"
local gradient = "gradient"--"assets/data/bedrock/gradient.png"
local effectnum = 0 -- idk what to call this

function start()
	defaultCamZoom,defaultHudZoom = cameraZoom,hudZoom
	bg = makeSprite(bg,"bg",true)
	white = makeSprite(white,"white",false)
	gradient = makeSprite(gradient,"gradient",false)
	setActorX(0,"bg")
	setActorY(660,"bg")
	setActorX(0,"white")
	setActorY(200,"white")
	setActorScale(3.25,"white")
	setActorScale(2.45,"bg")
	setActorAlpha(0,"white")
	setActorAlpha(0,"bg")
	setActorAlpha(0,"gradient")
	-- to kill freezes [ONLY WORKS WHEN LEX FINALLY PORTS THESE FUNCTIONS TO VS CHEEKY ENGINE LOL]
	changeDadCharacter("housecheeky")
	changeBoyfriendCharacter("bf-housecool")
	changeDadCharacter("crazycheeky")
	changeBoyfriendCharacter("bf-house")
end

local still = false
function unpop()
	effectnum = 3
	still = false
	setCamZoom(defaultCamZoom)
	setHudZoom(defaultHudZoom)
	setActorAlpha(1,"bg")
	setActorAlpha(1,"gradient")
	tweenFadeOut(gradient,.1,60)
	tweenFadeOut(white,0,7)
	changeDadCharacter("housecheeky")
	changeBoyfriendCharacter("bf-housecool")
end

function fixcamzoom()
	if effectnum > 3 then
		setCamZoom(defaultCamZoom)
		setHudZoom(defaultHudZoom)
	else
		still = true
	end
end

function update()
	setActorX(getCameraX(),"gradient")
	setActorY(getCameraY()+250,"gradient")
	setActorScale(3+cameraZoom*-.9,"gradient")
	if still then
		setCamZoom(1.25)
		setHudZoom(1.07)
	end
end

function stepHit(step)
	if still then
		setCamZoom(1.25)
		setHudZoom(1.07)
	end
	if step >= 928 and effectnum == 0 then
		effectnum = 1
		showOnlyStrums = true
		tweenCameraZoomOut(1.25,.55,"fixcamzoom")
		tweenHudZoomOut(1.07,.55,"fixcamzoom")
	elseif step >= 933 and effectnum == 1 then
		effectnum = 2
		for i = 0,7 do
			tweenFadeIn(i,0,0.03)
		end
		tweenFadeIn(white,1,.03,"unpop")
	elseif step >= 976 and effectnum == 3 then
		effectnum = 4
		for i = 0,7 do
			tweenFadeIn(i,1,1.5)
		end
	elseif step >= 992 and effectnum == 4 then
		effectnum = 5
		showOnlyStrums = false
	end
end