extends PlayerState

var blink_timer
var sit_timer

func enter(_msg := {}) -> void:
	blink_timer = 0
	sit_timer = 0
	player.can_double_jump = true
	player.anim_nxt = "Idle"
	pass

func physics_update(delta: float) -> void:
	
	# Last value determines how fast the player stops moving after letting go of movement
	player.velocity.x = lerp(player.velocity.x,0,0.2)
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if blink_timer == 5:
		player.anim_nxt = "IdleBlink"
		
	if sit_timer == 16:
		state_machine.transition_to("Sit")
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
		return
		
	if player.is_on_floor():
		if Input.is_action_pressed( "move_left" ) or \
			Input.is_action_pressed( "move_right" ):
				state_machine.transition_to("Run")

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "IdleBlink":
		blink_timer = 0
		player.anim_nxt = "Idle"
	elif anim_name == "Idle":
		blink_timer += 1
		sit_timer += 1
		
	pass
