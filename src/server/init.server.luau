--!strict
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Seed test data so that UserId 4336025969 qualifies for the [ELITE] tag.
-- Remove this block once you have real data flowing into your DataStore.
local function seedTestData()
	local store = DataStoreService:GetDataStore("PlayerStats")
	local ok, err = pcall(function()
		store:SetAsync("Kills/4336025969", 150)
	end)
	if not ok then
		warn("[ChatTags] Failed to seed test DataStore data:", err)
	end
end
task.spawn(seedTestData)

local ChatTags = require(ReplicatedStorage.Shared.ChatTags)
local config = require(ServerScriptService.Server.ChatTagsConfig)

local function applyTagToPlayer(player: Player)
	local tag = ChatTags.getTagForPlayer(player, config.strategies)
	if tag then
		player:SetAttribute("ChatTagText", tag.text)
		player:SetAttribute("ChatTagColor", ChatTags.colorToHex(tag.color))
	end
end

-- Handle players who join after this script runs.
Players.PlayerAdded:Connect(function(player: Player)
	task.spawn(applyTagToPlayer, player)
end)

-- Handle players already in the server when this script starts (e.g. in Studio).
for _, player in Players:GetPlayers() do
	task.spawn(applyTagToPlayer, player)
end
