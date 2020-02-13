local MAXIMUM_ROLL = 6
local MINIMUM_ROLL = 1
local FRAMES = {"One","Two","Three","Four","Five","Six"}
local dieStates ={}
dieStates[1] = {}
dieStates[1].value = nil
dieStates[1].kept = false
dieStates[1].dieUrl = "/firstDie#die"
dieStates[1].keepUrl = "/firstDie#keep"
dieStates[2] = {}
dieStates[2].value = nil
dieStates[2].kept = false
dieStates[2].dieUrl = "/secondDie#die"
dieStates[2].keepUrl = "/secondDie#keep"
dieStates[3] = {}
dieStates[3].value = nil
dieStates[3].kept = false
dieStates[3].dieUrl = "/thirdDie#die"
dieStates[3].keepUrl = "/thirdDie#keep"
dieStates[4] = {}
dieStates[4].value = nil
dieStates[4].kept = false
dieStates[4].dieUrl = "/fourthDie#die"
dieStates[4].keepUrl = "/fourthDie#keep"
dieStates[5] = {}
dieStates[5].value = nil
dieStates[5].kept = false
dieStates[5].dieUrl = "/fifthDie#die"
dieStates[5].keepUrl = "/fifthDie#keep"

local module = {}

function module.getValue(dieIndex)
	return dieStates[dieIndex].value
end

function module.isKept(dieIndex)
	return dieStates[dieIndex].kept
end

function module.toggleKept(dieIndex)
	dieStates[dieIndex]=not dieStates[dieIndex]
end

function module.rollDie(dieIndex)
	if not dieStates[dieIndex].kept then
		dieStates[dieIndex].value=math.random(MINIMUM_ROLL, MAXIMUM_ROLL)
	end
end

function module.rollDice()
	for dieIndex=1,#dieStates do
		module.rollDie(dieIndex)
	end
end

function module.render()
	for dieIndex=1,#dieStates do
		if dieStates[dieIndex].kept then
			msg.post(dieStates[dieIndex].keepUrl, "enable")
		else
			msg.post(dieStates[dieIndex].keepUrl, "disable")
		end
		if dieStates[dieIndex].value == nil then
			msg.post(dieStates[dieIndex].dieUrl, "disable")
		else
			msg.post(dieStates[dieIndex].dieUrl, "enable")
			sprite.play_flipbook(dieStates[dieIndex].dieUrl, FRAMES[dieStates[dieIndex].value])
		end
	end
end

return module