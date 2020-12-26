
var _levels = [
	_create_level(Vector2(3, 3), [Vector2(3, 2)], [Vector2(2, 2)], [Vector2(0, 0), Vector2(0, 1), Vector2(0, 2),
	Vector2(0, 3), Vector2(0, 4), Vector2(1, 4), Vector2(2, 4), Vector2(3, 4), Vector2(4, 4), Vector2(5,4),
	Vector2(5, 3), Vector2(5, 2), Vector2(5, 1), Vector2(5, 0),
	Vector2(4, 0), Vector2(3,0), Vector2(2, 0), Vector2(1, 0), 
	])
]
func parse_level(id):
	return _levels[id]

func _create_level(player, goals_arr, crates_arr, walls_arr):
	var pre_level_info = load("res://utils/LevelInfo.gd")
	var goals = PoolVector2Array(goals_arr)
	var crates = PoolVector2Array(crates_arr)
	var walls = PoolVector2Array(walls_arr)
	var level_info = pre_level_info.new(player, crates, goals, walls, PoolVector2Array([Vector2(1,1)]))
	return level_info
