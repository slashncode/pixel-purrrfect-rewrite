extends MarginContainer

const first_level = "res://scenes/Levels/Level01.tscn"
const credits = "res://scenes/Menu/Credits.tscn"

onready var _transition_rect := get_tree().get_root().get_node("SceneManager/FadeTransitionScreen")

onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector
onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)
	
func _process(_delta):
	if Input.is_action_just_pressed("move_down") && current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("move_up") && current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("jump"):
		handle_selection(current_selection)
		
func handle_selection(_current_selection):
	if _current_selection == 0:
		_transition_rect.transition_to(first_level)
	elif _current_selection == 1:
		_transition_rect.transition_to(credits)
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"


#func _on_FadeTransitionScreen_transitioned(scene_name):
#	if scene_name == "first_level":
#		get_parent().get_child(0).queue_free()
#		get_parent().add_child(first_level.instance())
#	elif scene_name == "credits":
#		get_parent().get_child(0).queue_free()
#		get_parent().add_child(credits.instance())
