extends CharacterBody2D
class_name Rabbit

@onready var stats: Stats = $Stats
@onready var label: Label = $Label

var hunger
var thirst

var isHungry: bool = false
var isThirsty: bool = false
var foodList: Array = []

func _ready() -> void:
	stats.connect("death", Callable(self, "die"))
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * stats.speed

func _process(delta: float) -> void:
	hunger = stats.hunger
	thirst = stats.thirst
	
	if hunger < 40:
		isHungry = true
	else:
		isHungry = false
	
	if thirst < 40:
		isThirsty = true
	else:
		isThirsty = false
	
	
	label.text = "Hunger " + str(floorf(hunger)) + " Thirst: " + str(floorf(thirst))
	
	
	if isHungry and foodList.size() > 0:
		velocity = global_position.direction_to(foodList[0].global_position) * stats.speed
	elif isThirsty:
		pass
	else:
		velocity = velocity.rotated(deg_to_rad(randf_range(-90, 90)))
	
	move_and_slide()
	
	

func die():
	queue_free()


func _on_los_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food") and foodList.find(body) == -1:
		foodList.append(body)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food"):
		stats.hunger += 50
		foodList.erase(body)
		body.queue_free()
