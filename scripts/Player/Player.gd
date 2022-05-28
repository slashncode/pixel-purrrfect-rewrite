# Character that moves and jumps.
class_name Player
extends KinematicBody2D

# Horizontal speed acceleration in pixels per second
export var ACCEL := 10
# Max horizontal speed in pixels per second.
export var MAX_SPEED := 170.0
var INITIAL_MAX_SPEED := MAX_SPEED
export var RUN_SPEED := 60
# Vertical acceleration in pixel per second squared.
export var GRAVITY := 600.0
# Maximum gravity
export var MAX_GRAVITY := 350.0
# Vertical speed applied when jumping.
export var JUMP_IMPULSE := 400.0
# How long player can grab walls
export var WALLGRAB_TIMER := 120
onready var INITIAl_WALLGRAB_TIMER := WALLGRAB_TIMER
# Time for player to be able to grab walls again after letting go
var TIME_TO_WALLGRAB := 25
var INITIAL_TIME_TO_WALLGRAB = TIME_TO_WALLGRAB
# Time for player to do a normal jump after letting go of wall
var JUMPED_FROM_WALL := false
var WALLGRAB_TO_JUMP := 16
var INITIAL_WALLGRAP_TO_JUMP := WALLGRAB_TO_JUMP
# Set player lifes
var hearts = 7

# Horizontal speed acceleration mid-air in pixels per second
export var AIR_ACCEL := 5
# Max horizontal speed mid-air in pixels per second
export var MAX_SPEED_MIDAIR := 170
var INITIAL_MAX_SPEED_MIDAIR := MAX_SPEED_MIDAIR
# Time for player to press jump before landing to immediately jump again in seconds
var JUMP_AGAIN_AFTER_LANDING := 0.2
# Time for player to jump after running of an edge
var FALL_AFTER_RUNNING := false
var JUMP_AFTER_FALLING := 16
var INITIAL_JUMP_AFTER_FALLING := JUMP_AFTER_FALLING

var can_double_jump := true

var velocity = Vector2.ZERO

onready var anim_fx = $AnimationPlayer
var anim_cur = ""
var anim_nxt = "Idle"

var dir_cur = 1
var dir_nxt = 1

var is_invulnerable := false
var invulnerable_timer := 0.0

onready var fsm := $StateMachine

var lastTimeToWallgrab = TIME_TO_WALLGRAB

func _physics_process(_delta: float) -> void:
	if hearts <= 0:
		get_tree().quit()
	
	if anim_cur == "Idle" and anim_nxt == "Idle":
		$AnimationPlayer.play("Idle")
	
	if anim_cur == "IdleSit" and anim_nxt == "IdleSit":
		$AnimationPlayer.play("IdleSit")
		
	if anim_cur != "IdleLiedown" && $Camera2D.zoom.x != 1:
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 1, 0.05)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 1, 0.05)
	elif anim_cur == "IdleLiedown":
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 0.4, 0.01)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 0.4, 0.01)
		
	
	if anim_cur != anim_nxt:
		anim_cur = anim_nxt
		$AnimationPlayer.play( anim_cur )
		
	if dir_cur != dir_nxt:
		dir_cur = dir_nxt
		scale.x *= -1
		
	if velocity.x < 0:
		dir_nxt = -1
	elif velocity.x > 0:
		dir_nxt = 1
		
	if Input.is_action_pressed("Run"):
		MAX_SPEED = INITIAL_MAX_SPEED + RUN_SPEED
		MAX_SPEED_MIDAIR = INITIAL_MAX_SPEED_MIDAIR + RUN_SPEED
	elif MAX_SPEED != INITIAL_MAX_SPEED:
		MAX_SPEED = INITIAL_MAX_SPEED
		MAX_SPEED_MIDAIR = INITIAL_MAX_SPEED_MIDAIR
	
	# Set max horizontal speed depending on action strength (if controller stick isn't pushed all the way to the left/right)
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	if !is_equal_approx(input_direction_x, 0.0):
		# warning-ignore:narrowing_conversion
		MAX_SPEED *= abs(input_direction_x)
		MAX_SPEED_MIDAIR *= abs(input_direction_x)
	
	# Set max horizontal speed
	velocity.x = clamp(velocity.x,-MAX_SPEED, MAX_SPEED)

		
	if is_on_floor():
		if WALLGRAB_TIMER < INITIAl_WALLGRAB_TIMER:
			WALLGRAB_TIMER += 1
			Events.emit_signal("stamina_changed", WALLGRAB_TIMER)
			
		JUMPED_FROM_WALL = false
		
		JUMP_AFTER_FALLING = INITIAL_JUMP_AFTER_FALLING
		FALL_AFTER_RUNNING = false

		
	if fsm.state.name != "Wallgrab" && fsm.state.name != "Wallclimb" && TIME_TO_WALLGRAB < INITIAL_TIME_TO_WALLGRAB:
		TIME_TO_WALLGRAB += 1
		
		
	#label.text = fsm.state.name
	pass

func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("deathzone_entered", self, "_on_deathzone_entered")

func _exit_tree() -> void:
	Events.disconnect("deathzone_entered", self, "_on_deathzone_entered")

func _on_deathzone_entered():
	position.x = 539
	position.y = 421
	hearts -= 1
	Events.emit_signal("hearts_changed", hearts)
