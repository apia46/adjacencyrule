extends "res://game.gd".Level
static var levelName = "EIGHT"
static var levelIcon = "1Γ"
static var prereq
static var theme = Level.theme1
static var scrollable = false
static var voidmark = false
static var map = "map"

func add_tiles():
	nextlevel = "level1b"
	for x in range(3): for y in range(3):
		if c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(8)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
