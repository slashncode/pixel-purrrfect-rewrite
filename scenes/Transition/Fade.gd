extends CanvasLayer

#signal transitioned(scene_name)
#
#var transition_to
#
#func transition(scene_name):
#	$AnimationPlayer.play("fade_to_black")
#	transition_to = scene_name
#
#
#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "fade_to_black":
#		emit_signal("transitioned", transition_to)
#		$AnimationPlayer.play("fade_to_normal")

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	_anim_player.play("fade_to_normal")
	
func transition_to(_next_scene := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("fade_to_black")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	print(_next_scene)
	get_tree().change_scene(_next_scene)
	_anim_player.play("fade_to_normal")
