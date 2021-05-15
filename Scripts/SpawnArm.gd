extends Button

const ARM = preload("res://Scenes/Arm.tscn")

		
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
	var new_arm = ARM.instance()
	
	get_node("/root/").add_child(new_arm)
	new_arm.status = "dragging"
	
	new_arm.position = self.get_global_position()


func _on_SpawnButton_spawn_atom():
	pass # Replace with function body.


func _on_SpawnButton_button_down():
	spawn_new()
	
	pass # Replace with function body.
