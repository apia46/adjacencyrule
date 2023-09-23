extends "res://game.gd".Level
static var levelName = "Overwhelmed"
static var levelIcon = "4Γ"
static var prereq = "level1c"
static var theme = Level.theme1
static var scrollable = false
static var voidmark = false

func add_tiles():
	nextlevel = "level1e"
	for x in range(3): for y in range(3):
		if c(x,y,0,0): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(1)}))
		elif c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
		elif c(x,y,2,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
		elif c(x,y,2,2): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(2)}))
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
