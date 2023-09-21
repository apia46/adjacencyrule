extends "res://game.gd".Level
static var levelName = "SEVEN"
static var levelIcon = "1β"
static var prereq
static var theme = Level.theme2

func add_tiles():
	nextlevel = "map"
	for x in range(3):
		for y in range(3):
			if x == 1 and y == 1:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(8)}))
			else:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
