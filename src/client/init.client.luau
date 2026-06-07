--!strict
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

-- OnIncomingMessage fires on the client for every message that arrives in the chat.
-- We read the sender's tag attributes (set by the server) and prepend a colored tag
-- to the message prefix so it appears as, e.g., "[VIP] Username: Hello".
TextChatService.OnIncomingMessage = function(message: TextChatMessage)
	local props = Instance.new("TextChatMessageProperties")

	local source = message.TextSource
	if not source then
		return props
	end

	local player = Players:GetPlayerByUserId(source.UserId)
	if not player then
		return props
	end

	local tagText = player:GetAttribute("ChatTagText")
	local tagColor = player:GetAttribute("ChatTagColor")

	if type(tagText) == "string" and tagText ~= "" and type(tagColor) == "string" and tagColor ~= "" then
		-- Build a RichText-colored tag and prepend it to whatever prefix already exists
		-- (e.g. the default "Username: " prefix provided by Roblox).
		local badge = ('<font color="%s"><b>[%s]</b></font> '):format(tagColor, tagText)
		props.PrefixText = badge .. message.PrefixText
	end

	return props
end
