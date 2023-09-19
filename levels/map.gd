extends "res://game.gd".Level
static var levelName = "Map"
static var levelIcon = "M"
static var prereq # hmm
static var theme = {
	unmarked = Color.WEB_GRAY,
	marked = Color.LIGHT_GRAY,
	border = Color.DARK_GRAY,
	forcedunmarked = Color.DIM_GRAY,
	forcedmarked = Color.WHITE_SMOKE,
	text = Color.WHITE,
}

func add_tiles():
	add(game.MapTile.new(32, 32, Rectangle.new(64,64).shape, "level1"))
	add(game.MapTile.new(32, 32+64, Rectangle.new(64,64).shape, "level1b"))
	add(game.MapTile.new(32, 32+64*2, Rectangle.new(64,64).shape, "level1c"))
	add(game.MapTile.new(32, 32+64*3, Rectangle.new(64,64).shape, "level1d"))
	add(game.MapTile.new(32, 32+64*4, Rectangle.new(64,64).shape, "level1e"))
	add(game.MapTile.new(32+64, 32+64*4, Rectangle.new(64,64).shape, "level1A"))
