extends PlayerState


func enter(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.FALL_AFTER_RUNNING = true
		state_machine.transition_to("Fall")
		return
		
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	player.anim_nxt = "Run"
	
	player.velocity.x += player.ACCEL * input_direction_x
	player.velocity.y += player.GRAVITY * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)


	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
