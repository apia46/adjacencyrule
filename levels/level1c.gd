extends "res://game.gd".Level
static var levelName = "TWO"
static var levelIcon = "3Γ"
static var prereq = "level1b2"
static var theme = Level.theme1
static var scrollable = false
static var voidmark = false

func add_tiles():
	nextlevel = "level1d"
	for x in range(3): for y in range(3):
		if c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(7)}))
		elif c(x,y,2,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
		elif c(x,y,2,0): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(2)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
