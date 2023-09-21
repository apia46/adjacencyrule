extends "res://game.gd".Level
static var levelName = "Map"
static var levelIcon = "M"
static var prereq # hmm
static var theme = Level.theme1

func add_tiles():
	add(game.MapTile.new(32, 32, Rectangle.new(64,64).shape, "level1"))
	add(game.MapTile.new(32, 32+64, Rectangle.new(64,64).shape, "level1b"))
	add(game.MapTile.new(32, 32+64*2, Rectangle.new(64,64).shape, "level1c"))
	add(game.MapTile.new(32, 32+64*3, Rectangle.new(64,64).shape, "level1d"))
	add(game.MapTile.new(32, 32+64*4, Rectangle.new(64,64).shape, "level1e"))
	add(game.MapTile.new(32+64, 32+64*4, Rectangle.new(64,64).shape, "level1A"))
	add(game.MapTile.new(32, 32+64*5, Rectangle.new(64,64).shape, "level2"))
