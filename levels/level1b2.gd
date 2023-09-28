extends "res://game.gd".Level
static var levelName = "Probably important"
static var levelIcon = "2.5Γ"
static var prereq = "level1b"
static var theme = Level.theme1
static var scrollable = false
static var voidmark = false
static var map = "map"

func add_tiles():
	nextlevel = "level1c"
	for x in range(3): for y in range(3):
		if c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(8)}))
		elif c(x,y,0,0): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(3)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
