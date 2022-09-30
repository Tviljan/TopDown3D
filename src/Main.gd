extends Node3D

@onready var Player :CharacterBody3D = $Player
@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
var spawn_points
func _ready():
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	
func _physics_process(_delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var mob = enemy_scene.instantiate()

	# And give it a random offset.
	var player_position = Player.transform.origin
	var point = spawn_points[randi_range(0, spawn_points.size()-1)]
	mob.set_position(point.global_position)
	mob.update_target_location(player_position)
	add_child(mob)
	
