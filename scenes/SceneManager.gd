extends Node2D

onready var _transition_rect := $FadeTransitionScreen
onready var _anim_player := $FadeTransitionScreen/AnimationPlayer
onready var audiostreamplayer := $AudioStreamPlayer2D

export(String, FILE, "*.tscn") var next_scene_path

func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("scene_changed", self, "_on_scene_changed")

func _exit_tree() -> void:
	Events.disconnect("scene_changed", self, "_on_scene_changed")
	
func _on_scene_changed(scenePath := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("fade_to_black")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	var level = get_node("CurrentScene").get_child(0)
	get_node("CurrentScene").remove_child(level)
	
	var next_level_resource = load(scenePath)
	var next_level = next_level_resource.instance()
	get_node("CurrentScene").add_child(next_level)
	
	_anim_player.play("fade_to_normal")
