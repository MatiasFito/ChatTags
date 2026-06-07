--!strict

--[[
	ChatTags — Reusable chat tag module.

	USAGE (server):
		local ChatTags = require(ReplicatedStorage.Shared.ChatTags)
		local tag = ChatTags.getTagForPlayer(player, myStrategies)
		if tag then
			player:SetAttribute("ChatTagText", tag.text)
			player:SetAttribute("ChatTagColor", ChatTags.colorToHex(tag.color))
		end

	USAGE (client, inside TextChatService.OnIncomingMessage):
		local text  = player:GetAttribute("ChatTagText")
		local color = player:GetAttribute("ChatTagColor")
		if text and color then
			props.PrefixText = ('<font color="%s">[%s]</font> '):format(color, text) .. props.PrefixText
		end
--]]

local Types = require(script.Types)

-- Re-export strategy constructors so callers only need to require this module.
local ChatTags = {
	UserId = require(script.Strategies.UserId),
	GamePass = require(script.Strategies.GamePass),
	DataStore = require(script.Strategies.DataStore),
}

export type Tag = Types.Tag
export type Strategy = Types.Strategy
export type Config = Types.Config

--- Evaluates all strategies for `player` and returns the tag with the highest
--- priority whose `check` passes, or `nil` if none match.
--- Strategies may yield (network requests) — call this inside `task.spawn` on the server.
function ChatTags.getTagForPlayer(player: Player, strategies: { Types.Strategy }): Types.Tag?
	-- Sort a copy by descending priority so we can short-circuit on first match.
	local sorted = table.clone(strategies)
	table.sort(sorted, function(a, b)
		return a.priority > b.priority
	end)

	for _, strategy in sorted do
		local ok, result = pcall(strategy.check, player)
		if ok and result then
			return strategy.tag
		elseif not ok then
			warn("[ChatTags] Strategy check error for player", player.Name, ":", result)
		end
	end

	return nil
end

--- Converts a Color3 to a hex string in the form "#RRGGBB" for use as a Player Attribute
--- (Color3 is not a valid attribute type) and inside RichText <font color="..."> tags.
function ChatTags.colorToHex(color: Color3): string
	return string.format(
		"#%02X%02X%02X",
		math.round(color.R * 255),
		math.round(color.G * 255),
		math.round(color.B * 255)
	)
end

return ChatTags
