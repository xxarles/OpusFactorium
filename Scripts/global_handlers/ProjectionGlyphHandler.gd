extends Node

var glob
func _ready():
	glob = get_node("/root/GlobalVariables")
	pass

func check_availability(tile_pos):
	if tile_pos in glob.atoms or tile_pos in glob.arms or tile_pos in glob.tiles:
			return false
	return true

func get_reach(tile_pos, direction):
	var tiles = []
	var reach = []
	
	tiles.append(tile_pos)
	reach = glob.create_reach(tile_pos, 1)
	tiles.append(reach[direction])

	return tiles
	
func update_var_glyph(glyph, all_tiles):
	glyph.tile_pos = all_tiles[0]
	glyph.all_tiles = all_tiles


func add_projection_glyph(glyph):
	var tile_pos
	var all_tiles

	
	tile_pos = glob.get_real_mouse_position()
	all_tiles = get_reach(tile_pos, glyph.direction)

	for tile in all_tiles:
		if not check_availability(tile_pos):
			if not glyph.tile_pos:
				return false
			else:
				tile_pos = glyph.tile_pos
	
	update_var_glyph(glyph, all_tiles)

	

	glyph.set_position_with_offset(glob.get_screen_position(tile_pos))
	for tile in glyph.all_tiles:
		glob.tiles[tile] = glyph
	return true

func remove_tile(all_tiles):
	for tile_pos in all_tiles:
		glob.tiles.erase(tile_pos)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
