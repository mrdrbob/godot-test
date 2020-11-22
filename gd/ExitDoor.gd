extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (String, FILE, "*.tscn") var next_level

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
