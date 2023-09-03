extends "res://game.gd".Level
static var levelName = "Map"
static var levelIcon = "M"

func add_tiles():
	add(game.MapTile.new(32, 32, Rectangle.new(64,64).shape, "level1"))
	add(game.MapTile.new(32, 96, Rectangle.new(64,64).shape, "level1b"))
	add(game.MapTile.new(32, 160, Rectangle.new(64,64).shape, "level1c"))
	add(game.MapTile.new(32, 224, Rectangle.new(64,64).shape, "level1d"))
	add(game.MapTile.new(32, 288, Rectangle.new(64,64).shape, "level1e"))
