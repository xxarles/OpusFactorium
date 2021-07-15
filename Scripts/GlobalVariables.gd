extends TileMap

var atoms = {}
var arms = {}
var tiles = {}

func _ready():
	self.cell_half_offset = 3
	self.cell_size = Vector2(82,71)
	var t = Transform2D()
	t[0].x = 82
	t[1].y = 71
	#self.set_custom_transform(t)
	print(self.get_custom_transform())
	pass

func move_background(delta):
	self.position += delta
	for key in atoms:
		atoms[key].global_position += delta
	for key in arms:
		arms[key].global_position += delta
	for key in tiles:
		tiles[key].global_position += delta
	
func get_real_mouse_position():
	return self.world_to_map(get_global_mouse_position()-self.position)

func get_screen_position(tile_pos):
	return self.map_to_world(tile_pos)+self.position

func add_atom(atom, type = "mouse"):
	var tile_pos
	print("GLOBAL POS")
	print(self.position)
	print("TILE0 POS")
	print(self.map_to_world(Vector2(0,0)))
	print("POS MOUSE")
	print(get_global_mouse_position())
	if type == "mouse":
		tile_pos = get_real_mouse_position()
	else:
		tile_pos = self.world_to_map(atom.global_position + Vector2(20,20))
	
	print(atom.global_position)
	print(tile_pos)
	
	if tile_pos in atoms or tile_pos in arms or tile_pos in tiles:
		if not atom.tile_pos:
			return false
		else:
			tile_pos = atom.tile_pos
			
	atom.tile_pos = tile_pos
	atom.set_position_with_offset(get_screen_position(tile_pos))
	atoms[tile_pos] = atom
	
	return true

func remove_atom(atom):
	atoms.erase(atom.tile_pos)

func add_arm(arm, type = "mouse"):
	var tile_pos	
	if type == "mouse":
		tile_pos = get_real_mouse_position()
	else:
		tile_pos = self.world_to_map(arm.global_position + Vector2(5,5))
	
	if tile_pos in atoms or tile_pos in arms or tile_pos in tiles:
		if not arm.tile_pos:
			return false
		else:
			tile_pos = arm.tile_pos
			
	arm.tile_pos = tile_pos
	arm.set_position_with_offset(get_screen_position(tile_pos))
	arms[tile_pos] = arm
	return true
	
func remove_arm(tile_pos):
	arms.erase(tile_pos)

func grab_atoms(tile):
	if tile in atoms:
		return atoms[tile]
	else:
		return false
