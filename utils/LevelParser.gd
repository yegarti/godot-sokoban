var levels = []
var number_of_levels

const TAG = "LevelParser"

const PLAYER = '@'
const PLAYER_ON_GOAL = '+'
const CRATE = '$'
const CRATE_ON_GOAL = '*'
const GOAL = '.'
const WALL = '#'
const GROUND = ' '

func get_level(level_id: int):
	return levels[level_id]

func _init():
	var file = File.new()
	Logger.debug("Opening file: %s" % Globals.current_level_pack.path, TAG)
	file.open(Globals.current_level_pack.path, File.READ)
	var raw_levels = []
	while not file.eof_reached():
		var line = file.get_line()
		var stripped_line = line.strip_edges()
		if stripped_line.begins_with(';') or stripped_line.empty():
			if raw_levels.empty():
				raw_levels.append([])
			elif not raw_levels[-1].empty():
				raw_levels.append([])
		else:  # level character
			raw_levels[-1].append(line)
	file.close()
	
	# remove levels crated by extra newline
	if not raw_levels.empty() and raw_levels[-1].empty():
		raw_levels = raw_levels.slice(0, -2)

	for level in _parse_levels(raw_levels):
		levels.append(level)
	number_of_levels = len(levels)

func _parse_levels(raw_levels: Array):
	var game_levels = []
	for raw_level in raw_levels:
		var level = _parse_level(raw_level)
		game_levels.append(level)
	return game_levels

func _find_ground_tiles(raw_level: Array):
	# use flood fill algorithm to find all tiles within the level and
	# mark them using the 'ground' character

	# place all positions with create or player in stack
	var y = 0
	var stack = []
	for row in raw_level:
		var x = 0
		for tile in row:
			if tile == PLAYER or tile == PLAYER_ON_GOAL or tile == CRATE or tile == CRATE_ON_GOAL:
				stack.append(Vector2(x, y))
			x += 1
		y += 1

	# flood fill to find all ground tiles
	var ground_positions = PoolVector2Array()
	while not stack.empty():
		var tile_pos = stack.pop_back()
		if raw_level[tile_pos.y][tile_pos.x] != WALL and not tile_pos in ground_positions:
			ground_positions.append(tile_pos)
			stack.push_back(tile_pos + Vector2.DOWN)
			stack.push_back(tile_pos + Vector2.UP)
			stack.push_back(tile_pos + Vector2.LEFT)
			stack.push_back(tile_pos + Vector2.RIGHT)

	return ground_positions

func _parse_level(raw_level: Array):
	var x = 0
	var y = 0
	var player
	var walls = PoolVector2Array()
	var ground = _find_ground_tiles(raw_level)
	var crates = PoolVector2Array()
	var goals = PoolVector2Array()
	for row in raw_level:
		x = 0
		for ch in row:
			var position = Vector2(x, y)
			if ch == PLAYER or ch == PLAYER_ON_GOAL:
				player = position
			if ch == CRATE or ch == CRATE_ON_GOAL:
				crates.append(position)
			if ch == GOAL or ch == CRATE_ON_GOAL or ch == PLAYER_ON_GOAL:
				goals.append(position)
			if ch == WALL:
				walls.append(position)
			x += 1
		y += 1
	return _create_level(player, goals, crates, walls, ground)

func _create_level(player, goals, crates, walls, ground):
	var pre_level_info = load("res://utils/LevelInfo.gd")
	var level_info = pre_level_info.new(player, crates, goals, walls, ground)
	return level_info
