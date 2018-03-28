extends TileMap

func tile_is_open(tile_names, cell_x, cell_y):
	var tile_id = get_cell(cell_x, cell_y)
	if tile_names.has(tile_id):
		return tile_names[tile_id] == "Background"

func auto_tile():
	var tile_names = {}
	var tiles_by_name = {}
	for id in tile_set.get_tiles_ids():
		tile_names[id] = tile_set.tile_get_name(id)
		tiles_by_name[tile_set.tile_get_name(id)] = id
	
	for cell_position in get_used_cells():
		var tile_id =  get_cellv(cell_position)
		if tile_names[tile_id] == "Auto": 
			var above_open = tile_is_open(tile_names, cell_position.x, cell_position.y - 1)
			var below_open = tile_is_open(tile_names, cell_position.x, cell_position.y + 1)
			var left_open  = tile_is_open(tile_names, cell_position.x - 1, cell_position.y)
			var right_open = tile_is_open(tile_names, cell_position.x + 1, cell_position.y)

			var flip_x = false
			var flip_y = false
			var transpose = false
			var set_type = "Wall"

			if above_open and not left_open:
				flip_x = true
				flip_y = true
				if right_open:
					set_type = "Corner"
			elif below_open and not right_open:
				if left_open:
					set_type = "Corner"
			elif left_open:
				flip_x = true
				transpose = true
				if above_open:
					set_type = "Corner"
			elif right_open:
				flip_y = true
				transpose = true
				if below_open:
					set_type = "Corner"
			else:
				set_cellv(cell_position, -1)
				continue

			set_cellv(cell_position, tiles_by_name[set_type], flip_x, flip_y, transpose)

func _ready():
	auto_tile()
