local saveFile = sys.get_save_file("TGGD_Yacht", "options")

local module = {}

function module.saveOptions()
	local data = {}
	data.masterGain = sound.get_group_gain("master")
	sys.save(saveFile, data)
end

function module.loadOptions()
	local data = sys.load(saveFile)
	if data.masterGain ~= nil then
		sound.set_group_gain("master", data.masterGain)
	end
end

return module