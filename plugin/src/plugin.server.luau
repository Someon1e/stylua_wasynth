local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local Selection = game:GetService("Selection")

local format = require(script.Parent.format)

local function isScript(instance)
	return instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript")
end

local function formatSelected()
	local recording = assert(ChangeHistoryService:TryBeginRecording("Format scripts"), "ChangeHistoryService failed")

	for _, selected in Selection:Get() do
		if not isScript(selected) then
			continue
		end

		ScriptEditorService:UpdateSourceAsync(selected, format)
	end

	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end

local toolbar = plugin:CreateToolbar("StyLua v" .. tostring(require(script.Parent.VERSION)))
local formatSelectedButton = toolbar:CreateButton("Format Selected", "Format the selected script", "")
formatSelectedButton.ClickableWhenViewportHidden = true
formatSelectedButton.Click:Connect(formatSelected)
