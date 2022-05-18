extends PlayerState


func enter(_msg := {}) -> void:
	player.anim_nxt = "Landing"
	pass

func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = player.SPEED * input_direction_x
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "Landing" && is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("Idle")
		
	elif anim_name == "Landing":
		state_machine.transition_to("Idle")
		print("Landing Run")
	pass # Replace with function body.
