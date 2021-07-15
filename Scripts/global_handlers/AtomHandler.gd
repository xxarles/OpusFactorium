extends Node

var glob
func _ready():
	glob = get_node("/root/GlobalVariables")
	pass

func add_atom(atom, type = "mouse"):
	var tile_pos
	if type == "mouse":
		tile_pos = glob.get_real_mouse_position()
	else:
		tile_pos = glob.world_to_map(atom.global_position + Vector2(20,20))
	
	if tile_pos in glob.atoms or tile_pos in glob.arms or tile_pos in glob.tiles:
		if not atom.tile_pos:
			return false
		else:
			tile_pos = atom.tile_pos
			
	atom.tile_pos = tile_pos
	atom.set_position_with_offset(glob.get_screen_position(tile_pos))
	glob.atoms[tile_pos] = atom
	
	return true

func remove_atom(atom):
	glob.atoms.erase(atom.tile_pos)