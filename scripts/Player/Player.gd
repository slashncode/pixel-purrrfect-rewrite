# Character that moves and jumps.
class_name Player
extends KinematicBody2D

# Horizontal speed in pixels per second.
export var SPEED := 100.0
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

const MAX_VEL = 100
const AIR_ACCEL = 10
const JUMP_AGAIN_MARGIN = 0.2

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
		
	if is_on_floor():
		WALLGRAB_TIMER = INITIAl_WALLGRAB_TIMER
		JUMPED_FROM_WALL = false
		
	if !is_on_wall() && TIME_TO_WALLGRAB < 20:
		TIME_TO_WALLGRAB += 1
		
		
	#label.text = fsm.state.name
	pass
