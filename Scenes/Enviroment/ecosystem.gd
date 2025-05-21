extends Node

@onready var environment: TileMapLayer = $Environment
@onready var rabbits: Node = $Rabbits
@onready var foxes: Node = $Foxes
@onready var wolves: Node = $Wolves

func _ready() -> void:
	#wstrzykiwanie srodowiska do agentow
	rabbits.environment = environment
	rabbits.inject_tileset()
	foxes.environment = environment
	foxes.inject_tileset()
	wolves.environment = environment
	wolves.inject_tileset()
