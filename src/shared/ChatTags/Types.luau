--!strict

export type Tag = {
	text: string,
	color: Color3,
}

export type Strategy = {
	check: (player: Player) -> boolean,
	tag: Tag,
	priority: number,
}

export type Config = {
	strategies: { Strategy },
}

return {}
