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
	
	
	
func add_atom(atom):
	var tile_pos = self.world_to_map(get_global_mouse_position())
	
	if tile_pos in atoms or tile_pos in arms or tile_pos in tiles:
		if not atom.tile_pos:
			return false
		else:
			tile_pos = atom.tile_pos
			
	atom.tile_pos = tile_pos
	atom.set_position_with_offset(self.map_to_world(tile_pos))
	atoms[tile_pos] = atom
	
	return true

func remove_atom(tile_pos):
	atoms.erase(tile_pos)

func add_arm(arm):
	var tile_pos = self.world_to_map(get_global_mouse_position())
	
	if tile_pos in atoms or tile_pos in arms or tile_pos in tiles:
		if not arm.tile_pos:
			return false
		else:
			tile_pos = arm.tile_pos
			
	arm.tile_pos = tile_pos
	arm.set_position_with_offset(self.map_to_world(tile_pos))
	arms[tile_pos] = arm
	return true
	
func remove_arm(tile_pos):
	arms.erase(tile_pos)
