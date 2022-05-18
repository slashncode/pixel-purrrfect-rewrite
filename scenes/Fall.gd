extends PlayerState

var jump_timer : float
var jump_again : bool

func enter(_msg := {}) -> void:
	player.anim_nxt = "Fall"
	jump_again = false


func physics_update(delta: float) -> void:
	# decrease jump timer for jumping right after landing
	jump_timer -= delta
	
	# gravity
	player.velocity.y = min( player.TERM_VEL, player.velocity.y + player.GRAVITY * delta )
	
	# movement in air
	var dir = Input.get_action_strength( "move_right" ) - \
		Input.get_action_strength( "move_left" )
	
	var is_moving = ( abs( dir ) > 0.1 )
	if is_moving:
		dir = sign( dir )
		player.velocity.x = lerp( player.velocity.x, \
			player.MAX_VEL * dir, \
			player.AIR_ACCEL * delta )
		player.dir_nxt = dir
	else:
		player.velocity.x = lerp( player.velocity.x, 0, \
			player.AIR_ACCEL * delta )
	
	player.velocity = player.move_and_slide( player.velocity, \
			Vector2.UP )
	
	# double jump or set jump-after-landing-timer and boolean
	if Input.is_action_just_pressed( "move_up" ):
		if player.can_double_jump:
			state_machine.transition_to("DoubleJump")
		else:
			# jump immediately after landing
			jump_timer = player.JUMP_AGAIN_MARGIN
			jump_again = true

	# landing
	if player.is_on_floor():
		player.can_double_jump = true
#		# jump after landing
		if jump_again and jump_timer >= 0:
			state_machine.transition_to("Jump")
		else:
			# landing -> running
			if abs( player.velocity.x ) > 1:
				state_machine.transition_to("Landing")
			# landing -> idle
			else:
				state_machine.transition_to("Landing")
