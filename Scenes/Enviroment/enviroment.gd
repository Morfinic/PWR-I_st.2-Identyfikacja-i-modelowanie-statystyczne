extends TileMapLayer


var ecosystem_Map: Array
var biomes: Array[Array] = []

func _ready() -> void:
	ecosystem_Map = self.get_used_cells()
	overflow_biome()


func overflow_biome():
	var map_copy: Array = ecosystem_Map.duplicate()
	var biome: Array
	
	while !map_copy.is_empty():
		var biome_block = map_copy.pop_front()
		var biome_id = self.get_cell_atlas_coords(biome_block)
		biome = []
		
		var neighbours: Array = self.get_surrounding_cells(biome_block)
		while !neighbours.is_empty():
			var neighbour = neighbours.pop_front()
			
			if self.get_cell_source_id(neighbour) != -1:
				if self.get_cell_atlas_coords(neighbour) == biome_id:
					biome.append(neighbour)
					neighbours.erase(neighbour)
					var tmp = self.get_surrounding_cells(neighbour)
					for t in tmp:
						if !(biome.has(t) or neighbours.has(t)):
							neighbours.append(t)
					
					map_copy.erase(neighbour)
			else:
				neighbours.erase(neighbour)
		
		biomes.append(biome)
