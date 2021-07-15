extends Node
var glob

# Called when the node enters the scene tree for the first time.
func _ready():
	glob = get_node("/root/GlobalVariables")
	pass # Replace with function body.


func add_arm(arm, type = "mouse"):
	var tile_pos	
	if type == "mouse":
		tile_pos = glob.get_real_mouse_position()
	else:
		tile_pos = glob.world_to_map(arm.global_position + Vector2(5,5))
	
	if tile_pos in glob.atoms or tile_pos in glob.arms or tile_pos in glob.tiles:
		if not arm.tile_pos:
			return false
		else:
			tile_pos = arm.tile_pos
			
	arm.tile_pos = tile_pos
	arm.set_position_with_offset(glob.get_screen_position(tile_pos))
	glob.arms[tile_pos] = arm
	return true
	
func remove_arm(tile_pos):
	glob.arms.erase(tile_pos)

func grab_atoms(tile):
	if tile in glob.atoms:
		return glob.atoms[tile]
	else:
		return false
	