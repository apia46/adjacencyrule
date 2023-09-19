extends "res://game.gd".Level
static var levelName = "Missing"
static var levelIcon = "AΓ"
static var prereq = "level1e"
static var theme = {
	unmarked = Color.LIGHT_GRAY,
	marked = Color.WEB_GRAY,
	border = Color.DARK_GRAY,
	forcedunmarked = Color.WHITE_SMOKE,
	forcedmarked = Color.DIM_GRAY,
	text = Color.BLACK,
}

const optimisation = [[-2,-1,0,-2],[-2,-1,3,-1],[-1,1,-2,-1],[2,1,-1,-2]]

func add_tiles():
	nextlevel = "map"
	for x in range(4):
		for y in range(4):
			match optimisation[y][x]:
				-2: continue
				-1: add(Tile.new(32+64*x, 32+64*y, Rectangle.new(64,64).shape))
				_: add(Tile.new(32+64*x, 32+64*y, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(optimisation[y][x])}))
