
local background = nil



function resize()
    resizeWindow(resizeX,resizeY)
end

function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
	background = makeSprite('black','black',false)
    setActorAlpha(0,background)
    setActorX(600,background)
    setActorY(600,background)
    setActorScale(10,background)
    hudX = getHuxX()
    hudY = getHudY()
end

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	for i=0,7 do
		setActorX(_G['defaultStrum'..i..'X'] + 18 * math.sin((currentBeat + i*0.25) * math.pi), i)
		setActorY(_G['defaultStrum'..i..'Y'] + 18 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	for i = 0, 7 do
		tweenPosYAngle(i,getActorY(i) - 25,0,0.1)
	end
		tweenPosXAngle(6,getActorX(6) + 15,0,0.1)
	local faded = false
	if curStep >= 300 and curStep < 500 then
		tweenFadeOut(background,0,1)
		faded = true
	end
	if faded == true and curStep > 500 then
		tweenFadeOut(background,1,1)
	end
end
function beatHit (beat)

end

function stepHit (step)
	-- do nothing
end

function keyPressed (key)
	-- do nothing
end

print("HI")
print("Mod Chart script loaded :)")		