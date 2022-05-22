extends Area2D

const score_value = 1
var collected = false

func _on_Coin_body_entered(_body: Node) -> void:
	$AnimatedSprite.play("collected")
	if !collected:
		$AudioStreamPlayer2D.play()
		Events.emit_signal("score_changed", score_value)
		collected = true



func _on_AudioStreamPlayer2D_finished() -> void:
	print("played sound")
	queue_free()
