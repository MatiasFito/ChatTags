--!strict
local Types = require(script.Parent.Parent.Types)

type Tag = Types.Tag
type Strategy = Types.Strategy

local UserId = {}

--- Creates a Strategy that matches players whose UserId is in the given list.
--- @param ids       List of UserIds that should receive this tag.
--- @param tag       The tag to display.
--- @param priority  Higher number = shown first when multiple tags match.
function UserId.new(ids: { number }, tag: Tag, priority: number): Strategy
	local idSet: { [number]: boolean } = {}
	for _, id in ids do
		idSet[id] = true
	end

	return {
		check = function(player: Player): boolean
			return idSet[player.UserId] == true
		end,
		tag = tag,
		priority = priority,
	}
end

return UserId
