extends CharacterBody2D

const FOX = preload("res://Scenes/Actors/Fox/fox.tscn")

@onready var stats: Stats = $Stats
@onready var label: Label = $Label
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var smp: Node = $StateMachinePlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var hunger
var thirst
var mating
var next_path_pos: Vector2
var isHungry: bool = false
var sortedFood: bool = false
var isThirsty: bool = false
var food
var tileset: TileMapLayer
var canDrink: bool
var waterList: Vector2 = Vector2(INF, INF)
var sex: int
var partner = null
var predator = null
var predatorNear: int = 0

#zmienne wykorzystywane do dziedziczenia genow przez dzieci
var speedGene: float
var thirstGene: float
var hungerGene: float

func _ready() -> void:
	next_path_pos = position

	stats.connect("death", Callable(self, "die"))
	sex = stats.sex
	speedGene = stats.speedRandom
	thirstGene = stats.thirstRandom
	hungerGene = stats.hungerRandom
	nav_agent.target_position = global_position
	#collision_shape_2d.disabled = true
	#collision_shape_2d.set_deferred("disabled", true)
	print(sex)

func _process(delta: float) -> void:
	canDrink = wykryj_wode()
	
	hunger = stats.hunger
	thirst = stats.thirst
	mating = stats.mating
	
	if hunger < 40:
		isHungry = true
	else:
		isHungry = false
		sortedFood = false
	
	if thirst < 40:
		isThirsty = true
	else:
		isThirsty = false
	
	
	label.text = "Hunger " + str(floorf(hunger)) + " Thirst: " + str(floorf(thirst))
	
	
	smp.set_param("isHungry", isHungry)
	smp.set_param("isThirsty", isThirsty)
	smp.set_param("mating", mating)
	smp.set_param("predatorNear", predatorNear)
	
	#if (next_path_pos and next_path_pos == Vector2.ZERO) or self.position.distance_to(next_path_pos) < 0.5:
		#next_path_pos = nav_agent.get_next_path_position()
	#else:
		#self.velocity = self.global_position.direction_to(next_path_pos) * stats.speed
		#
		#
	#move_and_slide()
	
	#wywalanie krolika z wody, nie dziala idealnie, juz chyba niepotrzebne
	#for i in get_slide_collision_count():
		#var _collision = get_slide_collision(i)
		#if _collision.get_collider() != null and _collision.get_collider().name == "Enviroment":
			#global_position = next_path_pos


func _physics_process(delta: float) -> void:
	if self.position.distance_to(next_path_pos) < 1:
		next_path_pos = nav_agent.get_next_path_position()
	else:
		self.velocity = self.global_position.direction_to(next_path_pos) * stats.speed
		
	move_and_slide()


func die():
	queue_free()


func _on_los_body_entered(body: Node2D) -> void:
	if body.is_in_group("Chain0") and food == null:
		food = body
		
	if body.is_in_group("Fox") and mating:
		if body.sex != sex and body.mating and body.partner == null:
			partner = body
			body.partner = self
	
	if body.is_in_group("Chain2"):
		if predator == null:
			predator = body
		predatorNear += 1


func _on_interact_body_entered(body: Node2D) -> void:
	#mozna dodac by nie jadly na zapas, po prostu wrzucenie isHungry sprawia ze navAgent nie dziala
	if body.is_in_group("Chain0") and isHungry:
		stats.hunger = 100
		food = null
		body.queue_free()
	
	if mating and body == partner:
		mate()



func _on_state_machine_player_updated(state: Variant, delta: Variant) -> void:
	label.text += " " + str(state)
	match state:
		"Idle":
			random_movement()
			#if nav_agent.target_position != targetPosition:
				#nav_agent.target_position = targetPosition
			#else:
				#if nav_agent.get_final_position().distance_to(global_position) < 32:
					#targetPosition = self.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		"Hungry":
			if food != null:
				nav_agent.target_position = food.position
			else:
				random_movement()
		"Thirsty":
			if waterList != Vector2(INF, INF):
				nav_agent.target_position = waterList
				if canDrink:
					stats.thirst = 100
			else:
				random_movement()
		"Mating":
			#collision_shape_2d.disabled = false
			check_partner()
			if partner == null:
				random_movement()
			else:
				nav_agent.target_position = partner.position
		"Flee":
			if predator != null:
				var escapePosition: Vector2 = (predator.position - position) * -1 #no clue czy ta matma dziala, chyba ta
				nav_agent.target_position = escapePosition
		_:
			pass
			#print("Nie powinno mnie tu byc")


#mozna poprawic funkcje, pozwala pic wode z duzego dystansu
#func wykryj_wode():
	#var pozycja = tileset.get_surrounding_cells(position)
	#
	#for i in pozycja:
		#var tileId = tileset.get_cell_tile_data(i)
		#
		#if tileId != null and tileId.get_custom_data("water") == true:
			#if waterList.find(Vector2i(floori(position.x), floori(position.y))) == -1:
				#waterList.append(Vector2i(floori(position.x), floori(position.y)))
			#return true
			#
	#return false

#dziala lepiej
func wykryj_wode():
	var pozycja = tileset.local_to_map(position)
	var tileId = tileset.get_cell_tile_data(pozycja)
	
	if tileId == null:
		return false
	elif tileId.get_custom_data("water") == false:
		return false
	else:
		if waterList != position:
			waterList = position
		return true

#Funkcja do wybierania losowego punktu docelowego, przeniesiona z idle do wszystkich stanow
func random_movement():
	#if nav_agent.target_position != targetPosition:
		#nav_agent.target_position = targetPosition
	#else:
	if nav_agent.get_final_position().distance_to(global_position) < 32:
		var targetPosition
		#goofy petla by nie wchodzil na pustynie losowo ale mogl wejsc tam po jedzenie
		while true:
			targetPosition = self.global_position + Vector2(randf_range(-300, 300), randf_range(-300, 300))
			var pozycja = tileset.local_to_map(targetPosition)
			var tileId = tileset.get_cell_tile_data(pozycja)
			if tileId != null and (tileId.get_custom_data("BiomeType") == "Any" or tileId.get_custom_data("BiomeType") == "Forest"):
				break
				
		nav_agent.target_position = targetPosition


func mate():
	#collision_shape_2d.set_deferred("disabled", true)
	#collision_shape_2d.disabled = true
	stats.mating = false
	stats.mating_timer.start()
	if sex == 0:
		birth()
	partner = null

func birth():
	var child = FOX.instantiate()
	child.position = position
	#get_parent().add_child(child)
	get_parent().call_deferred("add_child", child)
	#child.inherit((speedGene + partner.speedGene)/2, (thirstGene + partner.thirstGene)/2, (hungerGene + partner.hungerGene)/2)
	child.call_deferred("inherit", 
		(speedGene + partner.speedGene)/2, (thirstGene + partner.thirstGene)/2, (hungerGene + partner.hungerGene)/2
	)
	

func inherit(_speedGene, _thirstGene, _hungerGene):
	stats.reroll(_speedGene, _hungerGene, _thirstGene)


func check_partner():
	var bodyList = $LOS.get_overlapping_bodies()
	for i in bodyList:
		if i.is_in_group("Fox"):
			if i.mating and i.partner == null and i.sex != sex:
				partner = i
				i.partner = self
				return


func _on_los_body_exited(body: Node2D) -> void:
	if body == predator:
		predatorNear -= 1
