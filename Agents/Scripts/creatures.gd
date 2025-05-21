extends Node

var environment: TileMapLayer

#wywolac raz tylko na poczatku, dependency injection do wszystkich dzieci przy starcie
func inject_tileset():
	for i in get_children(false):
		i.tileset = environment

#przekazywanie srodowiska do agentow
func _on_child_entered_tree(node: Node) -> void:
	if environment != null:
		node.tileset = environment
