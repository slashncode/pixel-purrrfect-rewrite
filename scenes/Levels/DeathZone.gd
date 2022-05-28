extends Area2D

func _on_DeathZone_body_entered(body):
	Events.emit_signal("deathzone_entered")
