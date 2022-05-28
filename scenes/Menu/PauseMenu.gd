extends Node

onready var selector_one = $CanvasLayer/Control/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector1
onready var selector_two = $CanvasLayer/Control/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector2

var current_selection = 0
var isGamePaused = false

func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("pause_menu", self, "_on_pause_menu")

func _exit_tree() -> void:
	Events.disconnect("pause_menu", self, "_on_pause_menu")

func _ready():
	set_current_selection(0)
	
func _process(_delta):
	if isGamePaused:
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
		Events.emit_signal("pause_menu", false)
	elif _current_selection == 1:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"

func _on_pause_menu(boolean):
	if boolean:
		$CanvasLayer/Sprite.visible = true
		$CanvasLayer/Control.visible = true
		get_tree().paused = true
		isGamePaused = true
	if !boolean:
		$CanvasLayer/Sprite.visible = false
		$CanvasLayer/Control.visible = false
		get_tree().paused = false
		isGamePaused = false
