extends PlayerState

var liedown_timer

func enter(_msg := {}) -> void:
	liedown_timer = 0
	player.anim_nxt = "IdleSit"
	pass

func physics_update(_delta: float) -> void:
	
	if liedown_timer == 15:
		player.anim_nxt = "IdleLiedown"
	
	if player.is_on_floor():
		if Input.is_action_pressed( "move_left" ) or \
			Input.is_action_pressed( "move_right" ):
				state_machine.transition_to("Run")

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		
	return


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "IdleSit":
		liedown_timer += 1
	pass
