extends Node
class_name Stats

signal death

@export var type: Types.types
@onready var mating_timer: Timer = $MatingTimer

#aktualny stan agenta
var hunger: float = 50
var thirst: float = 50
var mating: bool = false

#niezmienne statystyki agenta
var speed: float = randf_range(100, 200)/2
var hungerLoss: float = randf_range(5, 15)
var thirstLoss: float = randf_range(1, 8)
#var rizz: float = randf_range(1, 10)
var matingSeason: int = randi_range(1, 4)
var sex: int = randi_range(0, 1)

func _ready() -> void:
	$MatingTimer.wait_time = matingSeason
	$MatingTimer.start()

func _process(delta: float) -> void:
	hunger -= hungerLoss * delta
	#thirst -= thirstLoss * delta
	
	hunger = clampf(hunger, 0, 100)
	thirst = clampf(thirst, 0, 100)
	
	if (hunger == 0 or thirst == 0):
		emit_signal("death")


func _on_mating_timer_timeout() -> void:
	mating = true
