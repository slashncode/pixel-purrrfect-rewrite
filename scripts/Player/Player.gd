# Character that moves and jumps.
class_name Player
extends KinematicBody2D

# Horizontal speed acceleration in pixels per second
export var ACCEL := 10
# Max horizontal speed in pixels per second.
export var MAX_SPEED := 110.0
# Vertical acceleration in pixel per second squared.
export var GRAVITY := 600.0
# Vertical speed applied when jumping.
export var JUMP_IMPULSE := 300.0
# Maximum gravity
export var TERM_VEL := 250.0
# How long player can grab walls
export var WALLGRAB_TIMER := 120
var INITIAl_WALLGRAB_TIMER := WALLGRAB_TIMER
# Time for player to be able to grab walls again after letting go
export var TIME_TO_WALLGRAB := 20
# Time for player to do a normal jump after letting go of wall
var JUMPED_FROM_WALL := false
var WALLGRAB_TO_JUMP := 16
var INITIAL_WALLGRAP_TO_JUMP := WALLGRAB_TO_JUMP

# Max horizontal speed mid-air in pixels per second
var MAX_SPEED_MIDAIR := 110
# Horizontal speed acceleration mid-air in pixels per second
var AIR_ACCEL := 5
# Time for player to press jump before landing to immediately jump again in seconds
var JUMP_AGAIN_AFTER_LANDING := 0.2
# Time for player to jump after running of an edge
var FALL_AFTER_RUNNING := false
var JUMP_AFTER_FALLING := 16
var INITIAL_JUMP_AFTER_FALLING := JUMP_AFTER_FALLING

export var can_double_jump := true

var velocity = Vector2.ZERO

onready var anim_fx = $AnimationPlayer
var anim_cur = ""
var anim_nxt = "Idle"

var dir_cur = 1
var dir_nxt = 1

var is_invulnerable := false
var invulnerable_timer := 0.0

onready var fsm := $StateMachine


func _physics_process(_delta: float) -> void:
	
	if anim_cur == "Idle" and anim_nxt == "Idle":
		$AnimationPlayer.play("Idle")
	
	if anim_cur == "IdleSit" and anim_nxt == "IdleSit":
		$AnimationPlayer.play("IdleSit")
		
	if anim_cur != "IdleLiedown" && $Camera2D.zoom.x != 0.5:
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 0.5, 0.05)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 0.5, 0.05)
	elif anim_cur == "IdleLiedown":
		$Camera2D.zoom.x = lerp($Camera2D.zoom.x, 0.2, 0.01)
		$Camera2D.zoom.y = lerp($Camera2D.zoom.y, 0.2, 0.01)
		
	
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
		
	velocity.x = clamp(velocity.x,-MAX_SPEED, MAX_SPEED)
		
	if is_on_floor():
		WALLGRAB_TIMER = INITIAl_WALLGRAB_TIMER
		JUMPED_FROM_WALL = false
		
		JUMP_AFTER_FALLING = INITIAL_JUMP_AFTER_FALLING
		FALL_AFTER_RUNNING = false
		
	if !is_on_wall() && TIME_TO_WALLGRAB < 20:
		TIME_TO_WALLGRAB += 1
		
		
	#label.text = fsm.state.name
	pass
