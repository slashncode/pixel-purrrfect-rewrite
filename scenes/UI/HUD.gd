extends Control

onready var label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var hearts = $MarginContainer/VBoxContainer/HBoxContainer2/Hearts

var score = 0
var newhearts = 0

func _ready() -> void:
	label.text = str(score)

func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("score_changed", self, "_on_score_changed")
	Events.connect("hearts_changed", self, "_on_hearts_changed")

func _exit_tree() -> void:
	Events.disconnect("score_changed", self, "_on_score_changed")
	Events.disconnect("hearts_changed", self, "_on_hearts_changed")

func _on_score_changed(value):
	score += value
	label.text = str(score)
	
func _on_hearts_changed(value):
	newhearts = value * 14
	hearts.value = newhearts
