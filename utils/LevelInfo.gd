var player
var crates
var goals
var walls
var ground

class_name LevelInfo

func _init(player: Vector2, crates: PoolVector2Array, goals: PoolVector2Array,
	walls: PoolVector2Array, ground: PoolVector2Array):
	self.player = player
	self.crates = crates
	self.goals = goals
	self.walls = walls
	self.ground = ground
