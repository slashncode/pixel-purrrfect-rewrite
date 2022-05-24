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
	player.velocity.y = min( player.MAX_GRAVITY, player.velocity.y + player.GRAVITY * delta )
	
	# movement in air
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
			
	if player.is_on_wall() && player.WALLGRAB_TIMER >= 0 && player.TIME_TO_WALLGRAB == player.INITIAL_TIME_TO_WALLGRAB:
		state_machine.transition_to("Wallgrab")
		
	player.WALLGRAB_TO_JUMP -= 1
	player.JUMP_AFTER_FALLING -= 1
	
	# double jump or set jump-after-landing-timer and boolean
	if Input.is_action_just_pressed( "jump" ):
		if player.WALLGRAB_TO_JUMP >= 1 && player.JUMPED_FROM_WALL:
			player.WALLGRAB_TO_JUMP = 0
			player.JUMPED_FROM_WALL = false
			state_machine.transition_to("Jump")
		elif player.FALL_AFTER_RUNNING && player.JUMP_AFTER_FALLING > 0:
			player.JUMP_AFTER_FALLING = 0
			player.FALL_AFTER_RUNNING = false
			state_machine.transition_to("Jump")
		elif player.can_double_jump:
			state_machine.transition_to("DoubleJump")
		else:
			# jump immediately after landing
			jump_timer = player.JUMP_AGAIN_AFTER_LANDING
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
