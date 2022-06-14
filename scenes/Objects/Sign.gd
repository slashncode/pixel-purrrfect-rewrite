extends Node2D


export var sign_text = "Press A to jump"

onready var label = $Control/MarginContainer/CenterContainer/VBoxContainer/Label
onready var control = $Control

# Called when the node enters the scene tree for the first time.
func _ready():
	control.visible = false
	label.text = sign_text
	$AnimationPlayer.play("SignWobble")


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		control.visible = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		control.visible = false
