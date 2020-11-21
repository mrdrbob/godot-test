extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const WALK_ACC = 50
const JUMP_ACC = 70 
const JUMP_DEC = 0.5
const WALK_MAX = 600
const GROUND_FRICTION = 0.3
const DUCK_FRICTION = 0.98
const AIR_FRICTION = 0.9
const JUMP_IMPULSE = -700

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	$Sprite.offset.y = 0
	$StandingCollision.disabled = false
	$CrouchingCollision.disabled = true
	
	if (is_on_floor()):
		if (Input.is_action_pressed("ui_down")):
			$Sprite.play("duck")
			motion *= DUCK_FRICTION
			$Sprite.offset.y = 10
			$StandingCollision.disabled = true
			$CrouchingCollision.disabled = false
		else:
			if (Input.is_action_just_pressed("ui_up")):
				$Sprite.play("jump")
				motion.y = JUMP_IMPULSE
			elif (Input.is_action_pressed("ui_left")):
				$Sprite.flip_h = true
				$Sprite.play("walk")
				motion.x = max(-WALK_MAX, motion.x - WALK_ACC)
			elif (Input.is_action_pressed("ui_right")):
				$Sprite.flip_h = false
				$Sprite.play("walk")
				motion.x = min(WALK_MAX, motion.x + WALK_ACC)
			else:
				$Sprite.play("idle")
				motion.x *= GROUND_FRICTION
	else:
		$Sprite.play("jump")
		if Input.is_action_pressed("ui_left"):
			if motion.x > 50:
				motion.x *= AIR_FRICTION
			else:
				$Sprite.flip_h = true
				motion.x = max(-WALK_MAX, motion.x - JUMP_ACC)
		elif Input.is_action_pressed("ui_right"):
			if motion.x < -50:
				motion.x *= AIR_FRICTION
			else:
				$Sprite.flip_h = false
				motion.x = min(WALK_MAX, motion.x + JUMP_ACC)
		else:
			motion.x *= AIR_FRICTION

	
	motion = move_and_slide(motion, UP)
