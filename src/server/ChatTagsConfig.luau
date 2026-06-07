--!strict
--[[
	ChatTagsConfig — Edit this file to define which players receive which tags.

	Each entry is a Strategy created by one of the ChatTags strategy constructors:
	  • ChatTags.UserId    — match a list of specific UserIds
	  • ChatTags.GamePass  — player owns a specific GamePass
	  • ChatTags.DataStore — a DataStore value passes a numeric comparison

	PRIORITY: When a player matches more than one strategy, the tag with the
	highest `priority` number is shown. Use any integers you like; higher = wins.

	COLOR: Pass a Color3 value. It will be converted to a hex string automatically.

	EXAMPLES BELOW — replace or extend them to fit your game.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatTags = require(ReplicatedStorage.Shared.ChatTags)

local config: ChatTags.Config = {
	strategies = {

		-- ── UserId ────────────────────────────────────────────────────────────
		-- Gives the [DEV] tag to specific UserIds (e.g. the game developers).
		ChatTags.UserId.new(
			-- { 4336025969 }, -- Your UserId
			{ 1234 }, -- Dummy UserId for testing — replace with your own
			{ text = "DEV", color = Color3.fromRGB(255, 100, 100) },
			100 -- highest priority — always wins
		),

		-- ── GamePass ──────────────────────────────────────────────────────────
		-- Gives the [VIP] tag to anyone who owns the VIP GamePass.
		ChatTags.GamePass.new(
			123456789, -- Replace with your real GamePass ID
			{ text = "VIP", color = Color3.fromRGB(255, 215, 0) },
			50
		),

		-- ── DataStore ─────────────────────────────────────────────────────────
		-- Gives the [ELITE] tag to players whose kill count exceeds 100.
		-- The key uses {userId} which is replaced with the player's UserId at runtime.
		ChatTags.DataStore.new(
			"PlayerStats", -- DataStore name
			"Kills/{userId}", -- Key — {userId} is substituted automatically
			">=", -- Operator: ">", ">=", "<", "<=", "==", "~="
			100, -- Threshold
			{ text = "ELITE", color = Color3.fromRGB(160, 32, 240) },
			25
		),
	},
}

return config
