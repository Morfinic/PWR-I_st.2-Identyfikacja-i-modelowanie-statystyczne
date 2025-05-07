extends Node
class_name Stats

signal death

@export var type: Types.types
@onready var mating_timer: Timer = $MatingTimer

#zmienne do losowanie statystyk, dziedziczone po rodzicach
var speedRandom = randf_range(70, 120)
var hungerRandom = randf_range(5, 7)
var thirstRandom = randf_range(5, 7)

#aktualny stan agenta
var hunger: float = 100
var thirst: float = 100
var mating: bool = false

#niezmienne statystyki agenta
var speed: float = randf_range(speedRandom, speedRandom * 2)/2
var hungerLoss: float = randf_range(hungerRandom, hungerRandom * 2)
var thirstLoss: float = randf_range(thirstRandom, thirstRandom * 2)
var matingSeason: int = randi_range(1, 4)
var sex: int = randi_range(0, 1)

func _ready() -> void:
	$MatingTimer.wait_time = matingSeason
	$MatingTimer.start()

func _process(delta: float) -> void:
	hunger -= hungerLoss * delta
	thirst -= thirstLoss * delta
	
	hunger = clampf(hunger, 0, 100)
	thirst = clampf(thirst, 0, 100)
	
	if (hunger == 0 or thirst == 0):
		emit_signal("death")


func _on_mating_timer_timeout() -> void:
	mating = true

func reroll(speedGene, hungerGene, thirstGene):
	speedRandom = speedGene
	hungerRandom = hungerGene
	thirstRandom = thirstGene
	
	speed = randf_range(speedRandom, speedRandom * 2)/2
	hungerLoss = randf_range(hungerRandom, hungerRandom * 2)
	thirstLoss = randf_range(thirstRandom, thirstRandom * 2)
	
