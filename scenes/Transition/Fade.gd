extends CanvasLayer

onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	_anim_player.play("fade_to_normal")

