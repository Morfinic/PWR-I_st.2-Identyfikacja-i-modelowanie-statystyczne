extends Node

@export var vegan_food: PackedScene


@onready var enviroment: TileMapLayer = $"../Enviroment"


var biomes: Array[Array]

func _ready() -> void:
	biomes = enviroment.biomes
	_on_food_spawner_timeout()


func _on_food_spawner_timeout() -> void:
	for biome in biomes:
		# Wysana z palca funkcja określająca ilość jedzenia w zależności od rozmiaru biomu
		# Z wymuszeniem pojawienia się minimum jednego pożywienia
		var food_scarcity = enviroment.get_cell_tile_data(biome[0]).get_custom_data("vegan_food")
		var food_size = maxi(log(biome.size()), 1) * food_scarcity
		var food_tiles = biome.duplicate()
		food_tiles.shuffle()
		food_tiles = food_tiles.slice(0, food_size)
		
		for tile in food_tiles:
			var food = vegan_food.instantiate()
			food.global_position = Vector2i(
				tile.x * 16 + 8,
				tile.y * 16 + 8
			)
			add_child(food)
