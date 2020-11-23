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

enum PlayerState { Idle, Duck, Jump, Fall, Walk, Unknown }

var motion = Vector2()
var state = PlayerState.Unknown
var facing_left = false

func _physics_process(delta):
	motion.y += GRAVITY
	
	process_state()
	
	motion = move_and_slide(motion, UP)

func process_state():
	match (state):
		PlayerState.Idle: idle_process()
		PlayerState.Fall: falling_process()
		PlayerState.Duck: duck_process()
		PlayerState.Walk: walk_process()
		PlayerState.Jump: jump_process()
		_: unknown_enter()

# Unknown state (only switches to another state)
func unknown_enter():
	if (!is_on_floor()):
		falling_enter()
	else:
		idle_enter()
	process_state()

# Idle state
func idle_enter():
	state = PlayerState.Idle
	$Sprite.play("idle")

func idle_process():
	if (!is_on_floor()):
		idle_exit()
		return
	
	if (Input.is_action_pressed("ui_down")):
		duck_enter()
	elif (Input.is_action_pressed("ui_up")):
		jump_enter()
	elif (Input.is_action_pressed("ui_left")):
		walk_enter(true)
	elif (Input.is_action_pressed("ui_right")):
		walk_enter(false)
	else:
		motion.x *= GROUND_FRICTION

func idle_exit():
	unknown_enter()


# Falling state
func falling_enter():
	state = PlayerState.Fall
	$Sprite.play("fall")

func falling_process():
	if (is_on_floor()):
		falling_exit()
	
	process_air_motion()

func falling_exit():
	unknown_enter()


# Ducking state
func duck_enter():
	state = PlayerState.Duck
	$Sprite.play("duck")
	$Sprite.offset.y = 10
	$StandingCollision.disabled = true
	$CrouchingCollision.disabled = false

func duck_process():
	if !is_on_floor() or !Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		duck_exit()
		return
	motion *= DUCK_FRICTION

func duck_exit():
	$Sprite.offset.y = 0
	$StandingCollision.disabled = false
	$CrouchingCollision.disabled = true
	unknown_enter()



# Walking state
func walk_enter(direction):
	state = PlayerState.Walk
	facing_left = direction
	$Sprite.flip_h = facing_left
	$Sprite.play("walk")

func walk_process():
	var continue_ui = "ui_left" if facing_left else "ui_right"
	if Input.is_action_pressed("ui_down") or !Input.is_action_pressed(continue_ui) or Input.is_action_pressed("ui_up"):
		walk_exit()
		return
	if facing_left:
		motion.x = max(-WALK_MAX, motion.x - WALK_ACC)
	else:
		motion.x = min(WALK_MAX, motion.x + WALK_ACC)

func walk_exit():
	unknown_enter()


# Jump state
func process_air_motion():
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

func jump_enter():
	state = PlayerState.Jump
	$Sprite.play("jump")
	motion.y = JUMP_IMPULSE

func jump_process():
	if is_on_floor() or motion.y > 0:
		exit_jump()
		return
	
	process_air_motion()


func exit_jump():
	unknown_enter()

#func _physics_process(delta):
#	motion.y += GRAVITY
#	$Sprite.offset.y = 0
#	$StandingCollision.disabled = false
#	$CrouchingCollision.disabled = true
#
#	if (is_on_floor()):
#		if (Input.is_action_pressed("ui_down")):
#			$Sprite.play("duck")
#			motion *= DUCK_FRICTION
#			$Sprite.offset.y = 10
#			$StandingCollision.disabled = true
#			$CrouchingCollision.disabled = false
#		else:
#			if (Input.is_action_just_pressed("ui_up")):
#				$Sprite.play("jump")
#				motion.y = JUMP_IMPULSE
#			elif (Input.is_action_pressed("ui_left")):
#				$Sprite.flip_h = true
#				$Sprite.play("walk")
#				motion.x = max(-WALK_MAX, motion.x - WALK_ACC)
#			elif (Input.is_action_pressed("ui_right")):
#				$Sprite.flip_h = false
#				$Sprite.play("walk")
#				motion.x = min(WALK_MAX, motion.x + WALK_ACC)
#			else:
#				$Sprite.play("idle")
#				motion.x *= GROUND_FRICTION
#	else:
#		$Sprite.play("jump")
#		if Input.is_action_pressed("ui_left"):
#			if motion.x > 50:
#				motion.x *= AIR_FRICTION
#			else:
#				$Sprite.flip_h = true
#				motion.x = max(-WALK_MAX, motion.x - JUMP_ACC)
#		elif Input.is_action_pressed("ui_right"):
#			if motion.x < -50:
#				motion.x *= AIR_FRICTION
#			else:
#				$Sprite.flip_h = false
#				motion.x = min(WALK_MAX, motion.x + JUMP_ACC)
#		else:
#			motion.x *= AIR_FRICTION
#
#	
#	motion = move_and_slide(motion, UP)
