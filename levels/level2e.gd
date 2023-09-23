extends "res://game.gd".Level
static var levelName = "Connected"
static var levelIcon = "5β"
static var prereq = "level2d"
static var theme = Level.theme2
static var scrollable = false
static var voidmark = false

func add_tiles():
	nextlevel = "level2f"
	for x in range(3): for y in range(3):
		if c(x,y,1,1): add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(7)}))
		# i dont know either
		elif c(x,y,0,2): add(Tile.new(64*x+32, 64*y+32, PackedVector2Array([Vector2(0,0),Vector2(64,0),Vector2(128,0),Vector2(128,64),Vector2(64.1,64),Vector2(64,12),Vector2(63.9,64),Vector2(0,64)])))
		elif c(x,y,1,2): pass
		else: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
