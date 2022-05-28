extends PlayerState

var keypress_timer : float

func enter(_msg := {}) -> void:
	player.velocity.y = -player.JUMP_IMPULSE
	keypress_timer = 0.2
	player.anim_nxt = "Jump"
	player.audiostreamplayer.play()
		
func physics_update(delta: float) -> void:
	if base_jump( delta ):
		return
	if Input.is_action_just_pressed( "jump" ) and \
		player.can_double_jump:
			state_machine.transition_to("DoubleJump")
			return

func base_jump( delta ) -> bool:
	player.velocity.y = min( player.MAX_GRAVITY, player.velocity.y + player.GRAVITY * delta )
	if keypress_timer >= 0:
		keypress_timer -= delta
		if keypress_timer < 0 or Input.is_action_just_released( "jump" ):
			keypress_timer = -1.0
			player.velocity.y *= 0.2
	
	var dir = Input.get_action_strength( "move_right" ) - \
		Input.get_action_strength( "move_left" )
	
	var is_moving = ( abs( dir ) > 0.1 )

	if is_moving:
		dir = sign( dir )
		player.velocity.x = lerp( player.velocity.x, \
			player.MAX_SPEED_MIDAIR * dir, \
			player.AIR_ACCEL * delta )
		player.dir_nxt = dir
	else:
		player.velocity.x = lerp( player.velocity.x, 0, \
			player.AIR_ACCEL * delta )
	
	player.velocity = player.move_and_slide( player.velocity, \
			Vector2.UP )
	
	if player.is_on_ceiling():
		player.velocity.y = 0.0
		state_machine.transition_to("Fall")
	elif player.velocity.y > 0:
		state_machine.transition_to("Fall")
		
	if player.is_on_wall() && player.WALLGRAB_TIMER >= 0 && player.TIME_TO_WALLGRAB == player.INITIAL_TIME_TO_WALLGRAB:
		state_machine.transition_to("Wallgrab")
	
	if player.is_on_floor():
		player.can_double_jump = true
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	return false
