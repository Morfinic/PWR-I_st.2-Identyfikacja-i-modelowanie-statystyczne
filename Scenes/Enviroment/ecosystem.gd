extends Node

@onready var enviroment: TileMapLayer = $Enviroment
@onready var rabbits: Node = $Rabbits
@onready var foxes: Node = $Foxes
@onready var wolfes: Node = $Wolfes
@onready var plots: CanvasLayer = $Plots

var t: int = 0
var tSeries: Array = []
var rabbitPop: int
var foxPop: int
var wolfPop: int
var showingPlot: bool = false

func _ready() -> void:
	#wstrzykiwanie srodowiska do agentow
	rabbits.enviroment = enviroment
	rabbits.inject_tileset()
	foxes.enviroment = enviroment
	foxes.inject_tileset()
	wolfes.enviroment = enviroment
	wolfes.inject_tileset()
	get_population()
	


func _on_timer_timeout() -> void:
	t += 2
	get_population()
	plots.update_series(t, rabbitPop, foxPop, wolfPop)

func get_population():
	tSeries.append(t)
	rabbitPop = rabbits.get_child_count()
	foxPop = foxes.get_child_count()
	wolfPop = wolfes.get_child_count()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		plots.visible = !plots.visible
