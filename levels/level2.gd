extends "res://game.gd".Level
static var levelName = "SEVEN"
static var levelIcon = "1β"
static var prereq# = "level1e"
static var theme = Level.theme2

func add_tiles():
	nextlevel = "level2b"
	for x in range(3): for y in range(3):
		if c(x,y,1,0): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {forced=game.ForcedModifier.new(false)}))
		elif c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(7)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
