extends PlayerState


func enter(_msg := {}) -> void:
	player.WALLGRAB_TO_JUMP = player.INITIAL_WALLGRAP_TO_JUMP
	player.JUMPED_FROM_WALL = true
	player.velocity.y = 0
	player.anim_nxt = "Wallgrab"

func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	player.velocity.x = player.SPEED * input_direction_x
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_pressed("move_up"):
		state_machine.transition_to("Wallclimb")
	
	if !player.is_on_wall() || player.WALLGRAB_TIMER <= 0:
		player.TIME_TO_WALLGRAB = player.INITIAL_WALLGRAP_TO_JUMP
		state_machine.transition_to("Fall")
		
	player.WALLGRAB_TIMER -= 1
	
	return
