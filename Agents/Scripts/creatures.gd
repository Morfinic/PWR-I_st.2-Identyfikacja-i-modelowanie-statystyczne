extends Node

var enviroment: TileMapLayer

#wywolac raz tylko na poczatku, dependency injection do wszystkich dzieci przy starcie
func inject_tileset():
	for i in get_children(false):
		i.tileset = enviroment

#przekazywanie srodowiska do agentow
func _on_child_entered_tree(node: Node) -> void:
	if enviroment != null:
		node.tileset = enviroment
