var levels = {}
var number_of_levels

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
	file.open("res://levels/levels.txt", File.READ)
	var lines = []
	var level_name
	var raw_levels = {}
	while not file.eof_reached():
		var line = file.get_line()
		var stripped_line = line.strip_edges()
		if stripped_line.begins_with(';') or stripped_line.empty():
			continue
		if stripped_line.begins_with('-'):
			level_name = line.substr(1)
			raw_levels[level_name] = []
		else:  # level character
			raw_levels[level_name].append(line)
	file.close()

	var i = 0
	for level in _parse_levels(raw_levels).values():
		levels[i] = level
		i += 1
	number_of_levels = i

func _parse_levels(levels: Dictionary):
	var game_levels = {}
	for level_name in levels.keys():
		var level = _parse_level(levels[level_name])
		game_levels[level_name] = level
	return game_levels

func _parse_level(raw_level: Array):
	var inside = false
	var x = 0
	var y = 0
	var player
	var walls = PoolVector2Array()
	var ground = PoolVector2Array()
	var crates = PoolVector2Array()
	var goals = PoolVector2Array()
	for row in raw_level:
		x = 0
		inside = false
		for ch in row.rstrip(GROUND):
			var position = Vector2(x, y)
			if ch == PLAYER or ch == PLAYER_ON_GOAL:
				player = position
			if ch == CRATE or ch == CRATE_ON_GOAL:
				crates.append(position)
			if ch == GOAL or ch == CRATE_ON_GOAL or ch == PLAYER_ON_GOAL:
				goals.append(position)
			if ch == WALL:
				walls.append(position)
				inside = true
			if ch == GROUND and inside:
				ground.append(position)
			x += 1
		y += 1
	return _create_level(player, goals, crates, walls, ground)

func _create_level(player, goals, crates, walls, ground):
	var pre_level_info = load("res://utils/LevelInfo.gd")
	var level_info = pre_level_info.new(player, crates, goals, walls, ground)
	return level_info
