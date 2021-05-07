extends TileMap

export var ground_items = {}
export var arm_items = {}
export var atom_items = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Tiles_pos_changes(move_dist):
	print("CHANGED!!", move_dist)
	pass # Replace with function body.
