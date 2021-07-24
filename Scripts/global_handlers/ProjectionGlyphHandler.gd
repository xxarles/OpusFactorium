extends Node

var glob
func _ready():
	glob = get_node("/root/GlobalVariables")
	pass

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
	var tile_pos_orig
	
	tile_pos_orig = glob.get_real_mouse_position()
	tile_pos = tile_pos_orig
	all_tiles = get_reach(tile_pos, glyph.direction)

	for tile in all_tiles:
		if glob.check_vec_in_list(tile, glob.get_all_non_atom_tiles()):
			if not glyph.tile_pos:
				return false
			else:
				tile_pos = glyph.tile_pos
	
	if tile_pos !=tile_pos_orig:
		all_tiles = get_reach(tile_pos, glyph.direction)
	update_var_glyph(glyph, all_tiles)

	glyph.set_position_with_offset(glob.get_screen_position(tile_pos))
	for tile in glyph.all_tiles:
		glob.glyphs[tile] = glyph
	return true

func remove_tile(all_tiles):
	for tile_pos in all_tiles:
		glob.glyphs.erase(tile_pos)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
