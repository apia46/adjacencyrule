extends "res://game.gd".Level
static var levelName = "happy"
static var levelIcon = ":)"
static var prereq
static var theme = Level.theme1
static var scrollable = false
static var voidmark = false
static var map = "map"

const optimisation = [[-2,-1,-2,-1,-2],[-2,-2,-2,-2,-2],[-1,-2,-2,-2,-1],[-2,-1,-1,-1,-2]]

func add_tiles():
	nextlevel = "map"
	for x in range(5): for y in range(4):
		match optimisation[y][x]:
			-2: pass
			-1: add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
