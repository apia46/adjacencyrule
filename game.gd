extends Node


func _ready():
	add_child(Level.new())

class Level:
	extends Node
	
	
	var style = {}
	var tiles = []
	var vertices = {}
	@onready var game = get_node("/root/game")
	
	func _init(Style:={unmarked = Color.DARK_GRAY,marked = Color.LIGHT_GRAY,border = Color.WEB_GRAY,forcedunmarked = Color.DIM_GRAY,forcedmarked = Color.WHITE_SMOKE,}):
		style = Style
	
	func _ready():
		#add_child(Tile.new(300,350, PackedVector2Array([Vector2(0,0),Vector2(25,100),Vector2(100,75),Vector2(150,0)]),{forced=ForcedCondition.new(ForcedCondition.forced_state.MARKED)}))
		#add_child(Tile.new(400,350, PackedVector2Array([Vector2(50,0),Vector2(0,75),Vector2(100,75),Vector2(150,0)]),{forced=ForcedCondition.new(ForcedCondition.forced_state.UNMARKED)}))
		#add_child(Tile.new(325,450, PackedVector2Array([Vector2(0,0),Vector2(0,75),Vector2(50,75),Vector2(75,-25)])))
		#add_child(Tile.new(400,450, PackedVector2Array([Vector2(0,-25),Vector2(-25,75),Vector2(50,100),Vector2(100,-25)])))
		for x in range(4):
			for y in range(4):
				add(Tile.new(64*x+32, 64*y+32, Rectangle.new(64,64).shape))
		for tile in tiles:
			tile.add_connections()
		for tile in tiles:
			tile.check_connections()
		print(vertices)
	
	func add(tile:Tile) -> void:
		tiles.append(tile)
		add_child(tile)


class Tile:
	extends Area2D
	
	var collision = CollisionPolygon2D.new()
	var display = Polygon2D.new()
	var border = Line2D.new()
	var hovered = false
	var marked = false
	var conditions = {}
	var polygon:PackedVector2Array
	@onready var style = get_parent().style
	var tween
	var pos
	var addedpos = Vector2(0,0)
	var shape
	@onready var level = get_parent()
	var id
	var shared_vertices = []
	
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
	
	
	func _init(X:int,Y:int,Shape:PackedVector2Array,Conditions:={}):
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
		conditions = Conditions
		for vertex in range(len(shape)):
			shape[vertex] += pos
	
	func _ready():
		# may not be consistent? idk
		id = len(level.tiles)-1
		border.default_color = style.border
		self.mouse_entered.connect(set_hovered.bind(true))
		self.mouse_exited.connect(set_hovered.bind(false))
		if conditions.has("forced"): marked = conditions.forced.state == ForcedCondition.forced_state.MARKED
		update_display()
		on_change_my_poly()
	
	func _process(_delta):
		position = pos + addedpos
	
	func set_hovered(toSet:bool) -> void:
		hovered = toSet
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
			if conditions.has("forced"): return
			marked = !marked
			update_display()
	
	func update_display():
		if marked: 
			if conditions.has("forced"): display.color = style.forcedmarked
			else: display.color = style.marked
		else:
			if conditions.has("forced"): display.color = style.forcedunmarked
			else: display.color = style.unmarked
	
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
	
	func get_tiles_touching():
		# uniquify shared_vertices
		pass


class Rectangle:
	var shape
	
	func _init(X:int,Y:int): shape = PackedVector2Array([Vector2(0,0),Vector2(X,0),Vector2(X,Y),Vector2(0,Y)])

class Condition:
	pass

class ForcedCondition:
		extends Condition
		
		enum forced_state {
			MARKED,
			UNMARKED,
		}
		var state:forced_state
		
		func _init(State:forced_state):
			state = State
