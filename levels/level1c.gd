extends "res://game.gd".Level

func add_tiles():
	nextlevel = "level1d"
	for x in range(3):
		for y in range(3):
			if x == 1 and y == 1:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(7)}))
			elif x == 2 and y == 1:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(4)}))
			elif x == 2 and y == 0:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(2)}))
			else:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
