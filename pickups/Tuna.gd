extends Area2D

const score_value = 3
var collected = false

func _ready():
	$AnimationPlayer.play("OpenCan")

func _on_Tuna_body_entered(_body: Node) -> void:
	$AnimationPlayer.play("Collected")
	if !collected:
		$AudioStreamPlayer2D.play()
		Events.emit_signal("score_changed", score_value)
		collected = true



func _on_AudioStreamPlayer2D_finished() -> void:
	queue_free()
