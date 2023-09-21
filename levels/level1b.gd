extends "res://game.gd".Level
static var levelName = "More numbers"
static var levelIcon = "2Γ"
static var prereq = "level1"
static var theme = Level.theme1

func add_tiles():
	nextlevel = "level1c"
	for x in range(3):
		for y in range(3):
			if x == 1 and y == 1:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(7)}))
			elif x == 1 and y == 0:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
			else:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
