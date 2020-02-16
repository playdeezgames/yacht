local MAXIMUM_ROLL = 6
local MINIMUM_ROLL = 1
local DICE_COUNT = 5
local ROUND_COUNT = 13
local ROLL_COUNT = 3
local FRAMES = {"One","Two","Three","Four","Five","Six"}
local SCORE_ACES = "aces"
local SCORE_TWOS = "twos"
local SCORE_THREES = "threes"
local SCORE_FOURS = "fours"
local SCORE_FIVES = "fives"
local SCORE_SIXES = "sixes"
local SCORE_BONUS = "bonus"
local SCORE_THREEOFAKIND = "three_of_a_kind"
local SCORE_FOUROFAKIND = "four_of_a_kind"
local SCORE_FULLHOUSE = "full_house"
local SCORE_SMALLSTRAIGHT = "small_straight"
local SCORE_LARGESTRAIGHT = "large_straight"
local SCORE_YACHT = "yacht"
local SCORE_CHANCE = "chance"
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
local scores = {}
local currentRound = 0
local currentRoll = 0
local currentScoreType = nil
local shakeTimer = 0

function calculateBonus()
	local tally = (scores[SCORE_ACES] or 0) + (scores[SCORE_TWOS] or 0) + (scores[SCORE_THREES] or 0) + (scores[SCORE_FOURS] or 0) + (scores[SCORE_FIVES] or 0) + (scores[SCORE_SIXES] or 0)
	if tally>=63 then
		scores[SCORE_BONUS] = 35
	else	
		scores[SCORE_BONUS] = 0
	end
end

local module = {}

function module.getValue(dieIndex)
	return dieStates[dieIndex].value
end

function module.isKept(dieIndex)
	return dieStates[dieIndex].kept
end

function module.toggleKept(dieIndex)
	dieStates[dieIndex].kept=not dieStates[dieIndex].kept
end

function module.clearKepts()
	for i = 1, DICE_COUNT do
		dieStates[i].kept = false
	end
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

function startRound()
	module.rollDice()
	currentRoll = 1
	module.clearKepts()
	module.render()
	module.setShakeTimer(0.5)
end

function module.resetGame()
	scores = {}
	currentRound = 1
	startRound()
	calculateBonus()
end

function module.SCORE_ACES()
	return SCORE_ACES
end
function module.SCORE_TWOS()
	return SCORE_TWOS
end
function module.SCORE_THREES()
	return SCORE_THREES
end
function module.SCORE_FOURS()
	return SCORE_FOURS
end
function module.SCORE_FIVES()
	return SCORE_FIVES
end
function module.SCORE_SIXES()
	return SCORE_SIXES
end
function module.SCORE_BONUS()
	return SCORE_BONUS
end
function module.SCORE_THREEOFAKIND()
	return SCORE_THREEOFAKIND
end
function module.SCORE_FOUROFAKIND()
	return SCORE_FOUROFAKIND
end
function module.SCORE_FULLHOUSE()
	return SCORE_FULLHOUSE
end
function module.SCORE_SMALLSTRAIGHT()
	return SCORE_SMALLSTRAIGHT
end
function module.SCORE_LARGESTRAIGHT()
	return SCORE_LARGESTRAIGHT
end
function module.SCORE_YACHT()
	return SCORE_YACHT
end
function module.SCORE_CHANCE()
	return SCORE_CHANCE
end

local scoreEvaluators = {}
function scoreEvaluators.aces() 
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 1 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.twos()
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 2 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.threes()
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 3 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.fours() 
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 4 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.fives()
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 5 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.sixes() 
	local result = 0
	for i = 1, DICE_COUNT do
		if dieStates[i].value == 6 then
			result = result + dieStates[i].value
		end
	end
	return result
end
function scoreEvaluators.bonus() 
	return 0 
end
function scoreEvaluators.three_of_a_kind() 
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	local hasThreeOfAKind = false
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
		if counts[dieStates[i].value]>=3 then
			hasThreeOfAKind = true
		end
	end
	if hasThreeOfAKind then
		local tally = 0
		for i = 1, DICE_COUNT do
			tally = tally + dieStates[i].value
		end
		return tally
	else
		return 0
	end
end
function scoreEvaluators.four_of_a_kind() 
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	local hasFourOfAKind = false
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
		if counts[dieStates[i].value]>=4 then
			hasFourOfAKind = true
		end
	end
	if hasFourOfAKind then
		local tally = 0
		for i = 1, DICE_COUNT do
			tally = tally + dieStates[i].value
		end
		return tally
	else
		return 0
	end
end
function scoreEvaluators.full_house()
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
	end
	local hasThreeOfAKind = counts[1]==3 or counts[2]==3 or counts[3]==3 or counts[4]==3 or counts[5]==3 or counts[6]==3
	local hasPair = counts[1]==2 or counts[2]==2 or counts[3]==2 or counts[4]==2 or counts[5]==2 or counts[6]==2
	if hasThreeOfAKind and hasPair then
		return 25
	else
		return 0
	end
end
function scoreEvaluators.small_straight()
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	local moreThanTwo = false
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
		if counts[dieStates[i].value]>2 then
			moreThanTwo = true
		end
	end
	if moreThanTwo then
		return 0
	elseif counts[1]>0 and counts[2]>0 and counts[3]>0 and counts[4]>0 then
		return 30
	elseif counts[2]>0 and counts[3]>0 and counts[4]>0 and counts[5]>0 then
		return 30
	elseif counts[3]>0 and counts[4]>0 and counts[5]>0 and counts[6]>0 then
		return 30
	else
		return 0
	end
end
function scoreEvaluators.large_straight()
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	local moreThanOne = false
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
		if counts[dieStates[i].value]>1 then
			moreThanOne = true
		end
	end
	if moreThanOne then
		return 0
	else
		return 40
	end
end
function scoreEvaluators.yacht()
	local counts = {}
	for i = MINIMUM_ROLL, MAXIMUM_ROLL do
		counts[i]=0
	end
	local hasYacht = false
	for i=1, DICE_COUNT do
		counts[dieStates[i].value] = counts[dieStates[i].value] + 1
		if counts[dieStates[i].value]>=DICE_COUNT then
			hasYacht = true
		end
	end
	if hasYacht then
		return 50
	else
		return 0
	end
end
function scoreEvaluators.chance()
	local tally = 0
	for i = 1, DICE_COUNT do
		tally = tally + dieStates[i].value
	end
	return tally
end

function module.evaluateScore(scoreType)
	return scoreEvaluators[scoreType]()
end

function module.recordScore(scoreType,value)
	if scoreType ~= SCORE_BONUS then
		scores[scoreType]=value
		calculateBonus()
	end
end

function module.getScore(scoreType)
	return scores[scoreType]
end

function module.getCurrentRound()
	return currentRound
end

function module.getCurrentRoll()
	return currentRoll
end

function module.canRollAgain()
	return currentRoll<ROLL_COUNT
end

function module.reroll()
	if module.canRollAgain() then
		module.setShakeTimer(0.5)
		module.rollDice()
		module.render()
		currentRoll = currentRoll + 1
	end
end

function module.setCurrentScoreType(scoreType)
	currentScoreType = scoreType
end

function module.getCurrentScoreType()
	return currentScoreType
end

function module.setShakeTimer(value)
	shakeTimer = value
end

function module.getShakeTimer()
	return shakeTimer
end

function module.nextRound()
	if module.getCurrentRound() < ROUND_COUNT then
		currentRound = currentRound + 1
		startRound()
		return true
	else
		return false
	end
end

return module

--SCORE_ACES
--SCORE_TWOS
--SCORE_THREES
--SCORE_FOURS
--SCORE_FIVES
--SCORE_SIXES
--SCORE_BONUS
--SCORE_THREEOFAKIND
--SCORE_FOUROFAKIND
--SCORE_FULLHOUSE
--SCORE_SMALLSTRAIGHT
--SCORE_LARGESTRAIGHT
--SCORE_YACHT
--SCORE_CHANCE
