extends CanvasLayer

@onready var graph_2d: Graph2D = $Graph2D

var rabbitSeries = LineSeries.new(Color(0, 0, 1))
var foxSeries = LineSeries.new(Color(0, 1, 0))
var wolfSeries = LineSeries.new(Color(1, 0, 0))


func _ready() -> void:
	graph_2d.add_series(rabbitSeries)
	graph_2d.add_series(foxSeries)
	graph_2d.add_series(wolfSeries)


func update_series(t, rabbitValue, foxValue, wolfValue):
	rabbitSeries.add_point(t, rabbitValue)
	foxSeries.add_point(t, foxValue)
	wolfSeries.add_point(t, wolfValue)
