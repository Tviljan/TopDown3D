extends Node3D

@onready var Player :CharacterBody3D = $Player
@onready var Camera : Camera3D = $Camera
@onready var timer : Timer = $EnemySpawnTimer

@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
var spawn_points

func _ready():
	Player.connect("player_killed", _player_killed)
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	
func _player_killed():
	Player == null
	Camera.Player = null
	timer.stop()
	
func _on_enemy_spawn_timer_timeout():

	# And give it a random offset.

	print('get point')
	var point = spawn_points[randi_range(0, spawn_points.size()-1)]
#
	print('instantiate')
	var mob = enemy_scene.instantiate()
#
	print('set position to ', point.global_position)
	mob.set_position(point.global_position)
	print('add')
	add_child(mob)
	if (Player != null):
		mob.update_target(Player)
