extends Node

var check
var level
var theme
var map
var levelsbeat = []

func _ready():
	randomize()
	load_level("map")

func load_level(toload):
	level = load("res://levels/" + toload + ".gd").new(toload)
	%levelinfo.text = level.levelIcon + " - " + level.levelName
	theme = level.theme
	add_child(level)
	if !check:
		check = MenuTile.new(MenuTile.menuTiles.CHECK)
		add_child(check)
		check.modifiers.text._load()
	if !map:
		map = MenuTile.new(MenuTile.menuTiles.MAP)
		add_child(map)
		map.modifiers.text._load()
	if toload == "map": check.fadeout(); map.fadeout()
	else: check.fadein(); map.fadein()
	check.pressed.connect(level.check)
	map.pressed.connect(level.check.bind("map"))

func get_level(): return level

class Level:
	extends Node
	
	var nextlevel = ""
	var tiles = []
	var vertices = {}
	@onready var game = get_node("/root/game")
	var changed_since_unhappy = true
	var loading = true
	var levelID
	
	const theme1 = {
	unmarked = Color8(140,140,140),
	marked = Color8(70,70,70),
	border = Color8(170,170,170),
	forcedunmarked = Color8(216,216,216),
	forcedmarked = Color8(40,40,40),
	text = Color.BLACK,}
	
	const theme2 = {
	unmarked = Color8(64,64,64),
	marked = Color8(180,180,180),
	border = Color8(30,30,30),
	forcedunmarked = Color8(40,40,40),
	forcedmarked = Color8(222,222,222),
	text = Color.WHITE,}
	
	func _init(levelid,theme:=theme1):
		levelID = levelid
		theme = theme
	
	func _ready():
		add_tiles()
		for tile in tiles:
			tile.add_connections()
		for tile in tiles:
			tile.check_connections()
		for tile in tiles:
			tile.load_modifiers()
		await get_tree().create_timer(1.5).timeout
		loading = false
	
	func get_level(): return self
	
	func add_tiles():
		pass
	
	func add(tile:Tile) -> void:
		tiles.append(tile)
		add_child(tile)
	
	func check(forcelevel:=""):
		if loading: return
		loading = true
		var okay = true
		if forcelevel == "":
			for tile in tiles:
				for modifier in tile.modifiers:
					if !tile.modifiers[modifier].check(): okay = false
			if okay: game.levelsbeat.append(levelID)
		else: nextlevel = forcelevel
		if okay:
			#hmm
			if game.check.is_connected("pressed", self.check):
				game.check.pressed.disconnect(self.check)
				for t in tiles:
					t.next_level()
				await get_tree().create_timer(1.2).timeout
				await game.load_level(nextlevel)
			queue_free()
		else:
			changed_since_unhappy = false
		loading = false
	
	class Rectangle:
		var shape
		
		func _init(X:int,Y:int): shape = PackedVector2Array([Vector2(0,0),Vector2(X,0),Vector2(X,Y),Vector2(0,Y)])
	
	class Tile:
		extends Area2D
		
		var collision = CollisionPolygon2D.new()
		var display = Polygon2D.new()
		var border = Line2D.new()
		var hovered = false
		var marked = false
		var modifiers = {}
		var polygon:PackedVector2Array
		var theme
		var tween
		var pos
		var addedpos = Vector2(0,0)
		var shape
		@onready var level = get_parent().get_level()
		var id
		var shared_vertices = []
		signal hover
		var showing = false
		var appears
		
		signal pressed
		#https://www.reddit.com/r/godot/comments/b0r9l4/is_it_possible_to_get_the_bounding_box_of_a/
		const MAX_COORD = pow(2,31)-1
		const MIN_COORD = -MAX_COORD
		var box # your polygon bounding box (Rect2)
		
		func minv(curvec,newvec):
			return Vector2(min(curvec.x,newvec.x),min(curvec.y,newvec.y))
		func maxv(curvec,newvec):
			return Vector2(max(curvec.x,newvec.x),max(curvec.y,newvec.y))
	
		func on_change_my_poly():
			var min_vec = Vector2(MAX_COORD,MAX_COORD)
			var max_vec = Vector2(MIN_COORD,MIN_COORD)
			for v in shape:
				min_vec = minv(min_vec,v)
				max_vec = maxv(max_vec,v)
			box = Rect2(min_vec,max_vec-min_vec)
		
		
		func _init(X:int,Y:int,Shape:PackedVector2Array,Modifiers:={},Appears:=true):
			self.add_child(collision)
			self.add_child(display)
			self.add_child(border)
			pos = Vector2(X,Y)
			shape = Shape
			collision.polygon = Shape
			display.polygon = Shape
			border.points = Shape
			border.add_point(Shape[0])
			border.joint_mode = Line2D.LINE_JOINT_ROUND
			border.end_cap_mode = Line2D.LINE_CAP_ROUND
			modifiers = Modifiers
			for modifier in modifiers:
				add_child(modifiers[modifier])
			for vertex in range(len(shape)):
				shape[vertex] += pos
			appears = Appears
		
		func _ready():
			# may not be consistent? idk
			load_theme()
			id = len(level.tiles)-1
			self.mouse_entered.connect(set_hovered.bind(true))
			self.mouse_exited.connect(set_hovered.bind(false))
			if modifiers.has("forced"): marked = modifiers.forced.state == ForcedModifier.forced_state.MARKED
			update_display()
			on_change_my_poly()
			pos.y += 500
			modulate.a = 0
			if appears:
				await get_tree().create_timer(randf_range(0.3,0.6)).timeout
				fadein()
		
		func fadein(to:=1.0):
			if showing: return
			var tweenstart = get_tree().create_tween().set_parallel()
			tweenstart.tween_property(self, "pos:y", pos.y-500, 1).set_trans(Tween.TRANS_EXPO)
			tweenstart.tween_property(self, "modulate:a", to, 0.5).set_delay(0.5)
			showing = true
			return tweenstart
		
		func fadeout(to:=0.0):
			if !showing: return
			var tweenend = get_tree().create_tween().set_parallel()
			tweenend.tween_property(self, "pos:y", pos.y+500, 1).set_trans(Tween.TRANS_EXPO)
			tweenend.tween_property(self, "modulate:a", to, 0.5)
			showing = false
			return tweenend
		
		func load_theme():
			get_theme()
			border.default_color = theme.border
			for modifier in modifiers: modifiers[modifier].load_theme()
		
		func get_theme(): theme = get_parent().theme
		
		func _process(_delta):
			# sin
			position = pos + addedpos
		
		func set_hovered(toSet:bool) -> void:
			hovered = toSet
			hover.emit()
			if hovered:
				tween = get_tree().create_tween().set_parallel()
				tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.2).set_trans(Tween.TRANS_SINE)
				tween.tween_property(self, "addedpos", box.size*Vector2(-0.1,-0.1), 0.2).set_trans(Tween.TRANS_SINE)
				z_index = 1
			else:
				tween = get_tree().create_tween()
				tween.parallel().tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property(self, "addedpos", Vector2(0,0), 0.2).set_trans(Tween.TRANS_SINE)
				z_index = 0
		
		func _input(Event):
			if Event.is_action_pressed("LClick"):
				if !hovered: return
				if modifiers.has("forced"): return
				pressed.emit()
				marked = !marked
				update_display()
				level.changed_since_unhappy = true
		
		func update_display():
			if marked: 
				if modifiers.has("forced"): display.color = theme.forcedmarked
				else: display.color = theme.marked
			else:
				if modifiers.has("forced"): display.color = theme.forcedunmarked
				else: display.color = theme.unmarked
		
		func add_connections():
			for vertex in shape:
				if vertex in level.vertices:
					level.vertices[vertex].append(id)
				else:
					level.vertices[vertex] = [id]
		
		func check_connections():
			for vertex in shape:
				shared_vertices.append(level.vertices[vertex].duplicate())
				shared_vertices[-1].erase(id)
		
		func load_modifiers():
			for modifier in modifiers:
				modifiers[modifier]._load()
		
		func next_level():
			await get_tree().create_timer(randf_range(0,0.3)).timeout
			await fadeout().finished
			queue_free()

class MenuTile:
	# god what the fuck this is a mess it sticks around after the level stops ajkdhjfjsdfk
	extends Level.Tile
	
	var cleared = false
	var type
	var game
	
	enum menuTiles {
		CHECK,
		MAP,
	}
	
	func get_theme(): theme = game.level.theme
	
	func _init(tile):
		type = tile
		match tile:
			menuTiles.CHECK:
				super(64,400,PackedVector2Array([Vector2(64,0),Vector2(128,64),Vector2(64,128),Vector2(0,64)]),{text = TextModifier.new("C")},false)
			menuTiles.MAP:
				super(128,464,PackedVector2Array([Vector2(64,0),Vector2(128,64),Vector2(64,128),Vector2(0,64)]),{text = TextModifier.new("M")},false)
	
	func _ready():
		game = get_parent()
		super()
	
	func fadein(to:=1.0):
		level = game.level
		load_theme()
		cleared = level.levelID in game.levelsbeat
		if type == menuTiles.CHECK:
			marked = cleared
		update_display()
		super(to)
	
	func _input(Event):
		if Event.is_action_pressed("LClick"):
			if !hovered: return
			if modifiers.has("forced"): return
			pressed.emit()

class MapTile:
	extends Level.Tile
	
	var levelID
	var levelName
	var levelIcon
	var select = false
	var cleared = false
	var unlocked = false
	var prereq
	var reftheme
	
	func get_theme():
		theme = reftheme
	
	func _init(X:int,Y:int,Shape:PackedVector2Array,Level:String,Modifiers:={}):
		levelID = Level
		var reference = load("res://levels/" + levelID + ".gd")
		levelName = reference.levelName
		levelIcon = reference.levelIcon
		prereq = reference.prereq
		Modifiers.levelicon = TextModifier.new(levelIcon,TextModifier.hover_set.HOVERED)
		Modifiers.levelname = TextModifier.new(levelName,TextModifier.hover_set.CLICKED,TextModifier.text_types.SMALL,Vector2(70,-5))
		Modifiers.forced = ForcedModifier.new(ForcedModifier.forced_state.UNMARKED)
		reftheme = reference.theme
		super(X,Y,Shape,Modifiers)
		pressed.connect(modifiers.levelname.clicked)
		hover.connect(self.hovercheck)
	
	func fadein(to:=1.0):
		if unlocked: super(to)
		else: super(to*0.3)
	
	func _ready():
		super()
		if !prereq or prereq in level.game.levelsbeat: unlocked = true
		# create it no matter what, then delete (i hate this so bad)
		if unlocked:
			modifiers.erase("forced")
			update_display()
		if levelID in level.game.levelsbeat:
			marked = true
			update_display()
			cleared = true
	
	func hovercheck(): if !hovered: select = false
	
	func _input(Event):
			if Event.is_action_pressed("LClick"):
				if !hovered: return
				if modifiers.has("forced"): return
				if select:
					level.check(levelID)
				else:
					pressed.emit()
					if cleared:
						marked = !marked
						update_display()
						level.changed_since_unhappy = true
					select = true


class Modifier:
	extends Node
	
	@onready var tile = get_parent()
	@onready var level = get_parent().get_parent()
	
	var display
	var pos = Vector2(0,0)
	var shaking = false
	
	#no overrideable constants :sob:
	static func condition(): return false
	
	func _init(Pos:=Vector2(0,0)):
		pos = Pos
	
	func load_theme(): pass
	
	func _process(_delta):
		if !condition(): return
		if !display: return
		if level.changed_since_unhappy:
			shaking = false
			display.position = pos
		if shaking:
			display.position = pos + Vector2(randi() % 4-2,randi() % 4-2)
	
	func _load():
		pass
	
	func check():
		return true

class ForcedModifier:
	extends Modifier
	
	enum forced_state {
		MARKED,
		UNMARKED,
	}
	var state:forced_state
	
	func _init(State:forced_state, Pos:=Vector2(0,0)):
		state = State
		super(Pos)

class TextModifier:
	extends Modifier
	
	var text : String
	var hover_state
	var visible
	enum hover_set {
		ALWAYS,
		HOVERED,
		NOT_HOVERED,
		CLICKED,
	}
	var text_type
	enum text_types {
		TILE,
		SMALL,
	}
	
	func load_theme():
		display.add_theme_color_override("font_color", tile.theme.text)
	
	func _ready():
		tile.add_child.call_deferred(display)
		tile.hover.connect(self.hover)
	
	func hover():
		if (tile.hovered and hover_state == hover_set.HOVERED) or (!tile.hovered and hover_state == hover_set.NOT_HOVERED):
			var tween = get_tree().create_tween()
			tween.tween_property(display, "modulate:a", 1, 0.2)
			visible = true
		elif (tile.hovered and hover_state == hover_set.NOT_HOVERED) or (!tile.hovered and hover_state == hover_set.HOVERED) or (visible == true and hover_state == hover_set.CLICKED and !tile.hovered):
			var tween = get_tree().create_tween()
			tween.tween_property(display, "modulate:a", 0, 0.2)
			visible = false
	#what
	func _load():
		on_load()
	
	func on_load():
		display.size = tile.box.size
		display.z_index = 1
	
	func clicked():
		if hover_state == hover_set.CLICKED and !visible:
			display.modulate.a = 1
			visible = true
	
	func _init(Text:String,HoverState:=hover_set.ALWAYS,Type:=text_types.TILE,Pos:=Vector2(0,0)):
		text_type = Type
		text = Text
		hover_state = HoverState
		text_type = Type
		super(Pos)
		load_display()
	
	func load_display():
		display = Label.new()
		display.text = text
		match text_type:
			text_types.TILE:
				display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				display.add_theme_font_size_override("font_size", int(500/display.get_minimum_size().x))
				pos.y -= 4
			text_types.SMALL:
				display.add_theme_font_size_override("font_size", 10)
		display.position = pos
		if hover_state == hover_set.HOVERED or hover_state == hover_set.CLICKED:
			display.modulate.a = 0
			visible = false
		else: visible = true

class NumberModifier:
	extends TextModifier
	
	var tiles_touching = []
	var num : int
	
	static func condition(): return true
	
	func _init(Num:int,HoverState:=hover_set.ALWAYS,Type:=text_types.TILE,Pos:=Vector2(0,0)):
		num = Num
		super(str(Num),HoverState,Type,Pos)
	
	func _load():
		on_load()
		get_tiles_touching()
	
	func get_tiles_touching():
		tiles_touching = []
		for vertex in tile.shared_vertices:
			for t in vertex:
				if not t in tiles_touching:
					tiles_touching.append(t)
	
	func check():
		var count = 0
		for t in tiles_touching:
			if level.tiles[t].marked: count += 1
		if count != num: shaking = true
		return count == num
