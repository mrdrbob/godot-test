extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_IMPULSE = -600
const WALK_SPEED = 200

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	if (is_on_floor()):
		if (Input.is_action_just_pressed("ui_up")):
			$Sprite.play("jump")
			motion.y = JUMP_IMPULSE
		elif (Input.is_action_pressed("ui_left")):
			$Sprite.flip_h = true
			$Sprite.play("walk")
			motion.x = -WALK_SPEED
		elif (Input.is_action_pressed("ui_right")):
			$Sprite.flip_h = false
			$Sprite.play("walk")
			motion.x = WALK_SPEED
		else:
			$Sprite.play("idle")
			motion.x = 0
	else:
		$Sprite.play("jump")
	
	motion = move_and_slide(motion, UP)
