extends CharacterBody2D
class_name Rabbit

@onready var stats: Stats = $Stats
@onready var label: Label = $Label
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var hunger
var thirst
var next_path_pos = Vector2.ZERO

var isHungry: bool = false
var isThirsty: bool = false
var foodList: Array = []

func _ready() -> void:
	stats.connect("death", Callable(self, "die"))
	#velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * stats.speed

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
		#velocity = global_position.direction_to(foodList[0].global_position) * stats.speed
		nav_agent.target_position = foodList[0].global_position
	elif isThirsty:
		pass
	elif nav_agent.is_navigation_finished() or next_path_pos == Vector2.ZERO:
		nav_agent.target_position = Vector2.ZERO
		##velocity = velocity.rotated(deg_to_rad(randf_range(-90, 90)))
		##if nav_agent.navigation_finished:
		#nav_agent.target_position = self.position + Vector2(randf_range(-10, 10), randf_range(-10, 10))

	if next_path_pos == Vector2.ZERO or self.position.distance_to(next_path_pos) < 0.5:
		next_path_pos = nav_agent.get_next_path_position()
	else:
		self.velocity = self.global_position.direction_to(next_path_pos) * stats.speed
	
	move_and_slide()
	

func die():
	queue_free()


func _on_los_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food") and foodList.find(body) == -1:
		foodList.insert(0, body)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food"):
		stats.hunger += 50
		foodList.erase(body)
		body.queue_free()
