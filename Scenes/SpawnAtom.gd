extends Button

signal spawn_atom
const ATOM = preload("res://Scenes/Atom.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func spawn_new():
	var new_atom = ATOM.instance()
	new_atom.atom_type = "earth"
	
	#new_atom.set_position(Vector2d())
	get_node("/root/").add_child(new_atom)
	new_atom.status = "dragging"
	
	new_atom.position = self.get_global_position()
	#new_atom.offset_ = new_atom.global_position 


func _on_SpawnButton_spawn_atom():
	pass # Replace with function body.


func _on_SpawnButton_button_down():
	spawn_new()
	
	pass # Replace with function body.
