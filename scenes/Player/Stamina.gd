extends Control

onready var StaminaBar = $TextureProgress
onready var player = get_parent()
onready var MAX_STAMINA = player.WALLGRAB_TIMER

var stamina = 100

func _ready() -> void:
	StaminaBar.value = stamina
	StaminaBar.modulate.a = 0

func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("stamina_changed", self, "_on_score_changed")

func _exit_tree() -> void:
	Events.disconnect("stamina_changed", self, "_on_score_changed")


func _on_score_changed(value):
	if player.WALLGRAB_TIMER != 0:
		stamina = floor(float(value) / MAX_STAMINA * 100)
		
	elif player.WALLGRAB_TIMER == 0:
		stamina = 0
		
	if stamina < 100:
		StaminaBar.modulate.a = lerp(StaminaBar.modulate.a, 1, 0.1)
		
func _physics_process(_delta):
	if stamina == 100 && StaminaBar.modulate.a != 0:
		StaminaBar.modulate.a = lerp(StaminaBar.modulate.a, 0, 0.2)
		
	StaminaBar.value = stamina
