extends Area2D

func _on_DeathZone_body_entered(body):
	if body.name == "Player":
		Events.emit_signal("deathzone_entered")
