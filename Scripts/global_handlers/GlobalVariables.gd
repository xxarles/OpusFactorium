extends TileMap

var atoms = {}
var arms = {}
var glyphs = {}
var status

func _ready():
	self.cell_half_offset = 3
	self.cell_size = Vector2(82,71)
	var t = Transform2D()
	t[0].x = 82
	t[1].y = 71
	pass

func create_reach(orig_tile, dist):
	#Creates a mapping of the reach of the arm in tile_map coordinates
	"""
	I was going to try a basic illustration here, but I gave up, sorry. 
	You should be better than me... Just believe this kinda works
	"""
	var temp_odd = [Vector2(+1,0),Vector2(+0,-1),Vector2(-1,-1),
						Vector2(-1,0),Vector2(-1,+1),Vector2(+0,+1)]
	var temp_even = [Vector2(+1,0),Vector2(+1,-1),Vector2(+0,-1),
						Vector2(-1,0),Vector2(+0,+1),Vector2(+1,+1)]
	
	var reach = [orig_tile, orig_tile, orig_tile, orig_tile, orig_tile, orig_tile]

	for j in range(dist):
		var temp = int(orig_tile[1]+j)%2 
		for i in range(6):
			if temp:
				reach[i] = reach[i] + temp_odd[i]
			else:
				reach[i] = reach[i] + temp_even[i]

	return reach

func move_background(delta):
	var already_done = []
	self.position += delta
	for key in atoms:
		atoms[key].global_position += delta
	for key in arms:
		arms[key].global_position += delta
	for key in glyphs:
		if not glyphs[key] in already_done:
			glyphs[key].global_position += delta
			already_done.append(glyphs[key])
	
func get_real_tile(pos):
	return world_to_map(pos-self.position)

func get_real_mouse_position():
	return self.world_to_map(get_global_mouse_position()-self.position)
	
func get_screen_position(tile_pos):
	return self.map_to_world(tile_pos)+self.position

func get_all_occupied_tiles():
	return atoms.keys() + arms.keys() + glyphs.keys()

func get_all_non_glyph_tiles():
	return arms.keys() + atoms.keys()

func get_all_non_atom_tiles():
	# print("arms keys?", arms.keys())
	# print("glyph keys?", glyphs.keys())
	# print("all_keys?", arms.keys()+glyphs.keys())
	return arms.keys() + glyphs.keys()
	
func check_vec_in_list(vec, vec_list):
	for x in vec_list:
		if vec.is_equal_approx(x):
			return true
	return false

func get_all_collisions(pos):
	pass
	var space_state = self.get_world_2d().direct_space_state
	return space_state.intersect_point(pos)

func _input(ev):
	if ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT and ev.is_pressed() and status!="dragging":
		print(get_all_collisions(ev.position))
	
	if status=="clicked" and ev is InputEventMouseButton:
		status="dragging"

	if status=="dragging" and ev is InputEventMouseButton  and ev.button_index == BUTTON_LEFT:
		if not ev.is_pressed():
			status = "released"
	





