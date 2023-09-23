extends "res://game.gd".Level
static var levelName = "THREE"
static var levelIcon = "3β"
static var prereq = "level2b"
static var theme = Level.theme2
static var scrollable = false
static var voidmark = false

func add_tiles():
	nextlevel = "level2d"
	for x in range(3): for y in range(3):
		if c(x,y,0,0): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {forced=game.ForcedModifier.new(true)}))
		elif c(x,y,0,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(3)}))
		elif c(x,y,2,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
