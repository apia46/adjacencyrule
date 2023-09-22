extends "res://game.gd".Level
static var levelName = "Extraneous"
static var levelIcon = "AΓ"
static var prereq = "level1e"
static var theme = Level.theme1

const optimisation = [[1,3,3,3],[4,7,6,4],[2,5,5,4],[2,5,3,3]]

func add_tiles():
	nextlevel = "map"
	for x in range(4): for y in range(4): add(Tile.new(32+64*x, 32+64*y, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(optimisation[y][x])}))
