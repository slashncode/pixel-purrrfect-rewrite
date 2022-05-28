extends MarginContainer

const main_menu = "res://scenes/Menu/MainMenu.tscn"

func _ready():
	$VBoxContainer/AnimationPlayer.play("blinking_text")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		Events.emit_signal("scene_changed", main_menu)
