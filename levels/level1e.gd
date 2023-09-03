extends "res://game.gd".Level
static var levelName = "Begin"
static var levelIcon = "5Γ"

const optimisation = [[1,3,3,3],[4,7,6,4],[2,5,5,4],[2,5,3,3]]

func add_tiles():
	nextlevel = "level1"
	for x in range(4):
		for y in range(4):
			add(Tile.new(32+64*x, 32+64*y, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(optimisation[y][x])}))
