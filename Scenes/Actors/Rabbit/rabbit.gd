extends CharacterBody2D
class_name Rabbit

@onready var stats: Stats = $Stats
@onready var label: Label = $Label
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var smp: Node = $StateMachinePlayer
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var hunger
var thirst
var next_path_pos = Vector2.ZERO
var targetPosition: Vector2 = global_position
var isHungry: bool = false
var sortedFood: bool = false
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
		if !sortedFood:
			sort_food()
	else:
		isHungry = false
		sortedFood = false
	
	if thirst < 40:
		isThirsty = true
	else:
		isThirsty = false
	
	
	label.text = "Hunger " + str(floorf(hunger)) + " Thirst: " + str(floorf(thirst))
	
	
	if isHungry and foodList.size() > 0:
		#velocity = global_position.direction_to(foodList[0].global_position) * stats.speed
		
					
		pass
	elif isThirsty:
		pass
	#elif nav_agent.is_navigation_finished() or next_path_pos == Vector2.ZERO:
		#nav_agent.target_position = Vector2.ZERO
		###velocity = velocity.rotated(deg_to_rad(randf_range(-90, 90)))
		###if nav_agent.navigation_finished:
		#nav_agent.target_position = self.position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
#
	if next_path_pos == Vector2.ZERO or self.position.distance_to(next_path_pos) < 0.5:
		next_path_pos = nav_agent.get_next_path_position()
	else:
		self.velocity = self.global_position.direction_to(next_path_pos) * stats.speed
	
	smp.set_param("isHungry", isHungry)
	
	sprite_2d_2.global_position = nav_agent.target_position
	
	#wywalanie krolika z wody, nie dziala idealnie
	for i in get_slide_collision_count():
		var _collision = get_slide_collision(i)
		if _collision.get_collider() != null and _collision.get_collider().name == "Enviroment":
			global_position = next_path_pos
	
	move_and_slide()
	

func die():
	queue_free()


func _on_los_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food") and foodList.find(body.global_position) == -1:
		foodList.append(body.global_position)
		sort_food()
		print("Znalezione zarcie " + str(foodList))


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("Food"):
		stats.hunger += 50
		foodList.erase(body.global_position)
		print("Ojebano zarcie " + str(foodList))
		body.queue_free()

#Goofy-ahh funkcja, na razie chyba nie dziala, wywolac raz przy wejsciu
func sort_food():
	sortedFood = true
	var _najmniejszyDystans = INF
	for food in foodList:
		if global_position.distance_to(food) < _najmniejszyDystans:
			_najmniejszyDystans = global_position.distance_to(food)
			var _tmpIdx = foodList.find(food)
			var _tmpValue = foodList[0]
			foodList[0] = food
			foodList[_tmpIdx] = _tmpValue


func _on_state_machine_player_updated(state: Variant, delta: Variant) -> void:
	match state:
		"Idle":
			if nav_agent.target_position != targetPosition:
				nav_agent.target_position = targetPosition
			else:
				if nav_agent.get_final_position().distance_to(global_position) < 32:
					targetPosition = self.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		"Hungry":
			if foodList.size() > 0:
				nav_agent.target_position = foodList[0]
		_:
			pass
			#print("Nie powinno mnie tu byc")
