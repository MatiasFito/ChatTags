--!strict
local MarketplaceService = game:GetService("MarketplaceService")

local Types = require(script.Parent.Parent.Types)

type Tag = Types.Tag
type Strategy = Types.Strategy

local GamePass = {}

--- Creates a Strategy that matches players who own the given GamePass.
--- The check yields (makes a network request) — the server must call it inside task.spawn.
--- @param gamePassId  The numeric ID of the GamePass to check.
--- @param tag         The tag to display.
--- @param priority    Higher number = shown first when multiple tags match.
function GamePass.new(gamePassId: number, tag: Tag, priority: number): Strategy
	return {
		check = function(player: Player): boolean
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
			end)
			if not ok then
				warn("[ChatTags] GamePass check failed for player", player.Name, ":", owns)
				return false
			end
			return owns
		end,
		tag = tag,
		priority = priority,
	}
end

return GamePass
