extends Control

@onready var chart: Chart = $Chart
@onready var rabbits: Node = $"../../Rabbits"
@onready var foxes: Node = $"../../Foxes"
@onready var wolves: Node = $"../../Wolves"

# This Chart will plot 3 different functions
var f1: Function
var f2: Function
var f3: Function

func _ready():
	# Let's create our @x values
	var x: Array = range(-100, 0, 1)
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y1: Array; y1.resize(100); y1.fill(0)
	var y2: Array; y2.resize(100); y2.fill(0)
	var y3: Array; y3.resize(100); y3.fill(0)
	
	
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = "Wykres populacji"
	cp.x_label = "Ticks"
	cp.y_label = "Liczba osobników"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.show_legend = true
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y1, "Króliki",
		{ 
			color = Color("#36a2eb"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.STAIR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	f2 = Function.new(
		x, y2, "Lisy",
		{ 
			color = Color("#EB36A2"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.STAIR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	f3 = Function.new(
		x, y3, "Wilki",
		{ 
			color = Color("#A2EB36"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.STAIR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	
	# Now let's plot our data
	chart.plot([f1, f2, f3], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)

var next_x = 0

func _on_timer_timeout() -> void:
	next_x += 1
	var rabbitsPop = rabbits.get_child_count()
	var foxesPop = foxes.get_child_count()
	var wovlesPop = wolves.get_child_count()
	
	f1.add_point(next_x, rabbitsPop)
	f1.remove_point(0)
	
	f2.add_point(next_x, foxesPop)
	f2.remove_point(0)
	
	f3.add_point(next_x, wovlesPop)
	f3.remove_point(0)
	
	chart.queue_redraw()
