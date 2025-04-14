extends Node

@onready var enviroment: TileMapLayer = $Enviroment
@onready var creatures: Node = $Creatures

func _ready() -> void:
	#wstrzykiwanie srodowiska do agentow
	creatures.enviroment = enviroment
	creatures.inject_tileset()
