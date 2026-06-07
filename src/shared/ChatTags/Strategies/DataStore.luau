--!strict
local DataStoreService = game:GetService("DataStoreService")

local Types = require(script.Parent.Parent.Types)

type Tag = Types.Tag
type Strategy = Types.Strategy

export type Operator = ">" | ">=" | "<" | "<=" | "==" | "~="

local OPERATORS: { [Operator]: (a: number, b: number) -> boolean } = {
	[">"] = function(a, b)
		return a > b
	end,
	[">="] = function(a, b)
		return a >= b
	end,
	["<"] = function(a, b)
		return a < b
	end,
	["<="] = function(a, b)
		return a <= b
	end,
	["=="] = function(a, b)
		return a == b
	end,
	["~="] = function(a, b)
		return a ~= b
	end,
}

local DataStore = {}

--- Creates a Strategy that reads a value from a DataStore and compares it to a threshold.
---
--- The `key` parameter supports the `{userId}` placeholder, which is replaced at check
--- time with the player's UserId. For example: `"PlayerData/{userId}"`.
---
--- The check yields (makes a network request) — the server must call it inside task.spawn.
---
--- @param storeName  The name of the DataStore to read from.
--- @param key        The DataStore key. Use `{userId}` to insert the player's UserId.
--- @param operator   Comparison operator: ">", ">=", "<", "<=", "==", or "~=".
--- @param threshold  The number to compare the stored value against.
--- @param tag        The tag to display.
--- @param priority   Higher number = shown first when multiple tags match.
function DataStore.new(
	storeName: string,
	key: string,
	operator: Operator,
	threshold: number,
	tag: Tag,
	priority: number
): Strategy
	local compareFn = OPERATORS[operator]
	assert(compareFn, "[ChatTags] DataStore strategy: unknown operator '" .. operator .. "'")

	local store = DataStoreService:GetDataStore(storeName)

	return {
		check = function(player: Player): boolean
			local resolvedKey = key:gsub("{userId}", tostring(player.UserId))

			local ok, value = pcall(function()
				return store:GetAsync(resolvedKey)
			end)

			if not ok then
				warn("[ChatTags] DataStore check failed for player", player.Name, ":", value)
				return false
			end

			if type(value) ~= "number" then
				return false
			end

			return compareFn(value, threshold)
		end,
		tag = tag,
		priority = priority,
	}
end

return DataStore
