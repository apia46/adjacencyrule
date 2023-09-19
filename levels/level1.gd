extends "res://game.gd".Level
static var levelName = "EIGHT"
static var levelIcon = "1Γ"
static var prereq
static var theme = {
	unmarked = Color.WEB_GRAY,
	marked = Color.LIGHT_GRAY,
	border = Color.DARK_GRAY,
	forcedunmarked = Color.DIM_GRAY,
	forcedmarked = Color.WHITE_SMOKE,
	text = Color.WHITE,}

func add_tiles():
	nextlevel = "level1b"
	for x in range(3):
		for y in range(3):
			if x == 1 and y == 1:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape, {number=game.NumberModifier.new(8)}))
			else:
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
