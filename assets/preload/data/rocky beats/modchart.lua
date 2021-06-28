local section
function stepHit(beat)
	section = beat/16
	if ((section >= 24 and section < 40)or(section >= 64 and section < 80)) and math.fmod(section*4,1) <= 0 then
		setCamZoom(1.04)
		setHudZoom(1.035)
	end
end