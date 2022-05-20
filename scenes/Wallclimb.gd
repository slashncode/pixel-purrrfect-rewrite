extends PlayerState


func enter(_msg := {}) -> void:
	player.anim_nxt = "Wallclimb"
	pass

func physics_update(_delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = player.SPEED * input_direction_x
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	player.velocity.y = 0
	
	if !player.is_on_wall() || player.WALLGRAB_TIMER <= 0:
		player.TIME_TO_WALLGRAB = 0
		state_machine.transition_to("Fall")

	if Input.is_action_pressed("move_up"):
		player.velocity.y = -50
	else:
		state_machine.transition_to("Wallgrab")
	
	player.WALLGRAB_TIMER -= 1
		
	return
