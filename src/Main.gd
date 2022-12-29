extends Node3D

@onready var Player :CharacterBody3D = $Player
@onready var PlayerCamera : Camera3D = $Player/PlayerCamera
@onready var timer : Timer = $EnemySpawnTimer
@onready var DeathCamera : Camera3D = $DeathCamera

@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@export var player :PackedScene = preload("res://Player.tscn")

var spawn_points
var points = 0
var listen_to_input = false
func _ready():
	wait_for_input_timer = get_tree().create_timer(1.5)
	listen_to_input = false
	Player.connect("player_killed", _player_killed)	
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	
var player_killed = false

func _restart():
	get_tree().reload_current_scene()
	
func _player_killed():
	if not player_killed:
		set_process_input(false)
		player_killed = true
		switch_camera()
		timer.stop()
	
func switch_camera():
	if player_killed:
		PlayerCamera.clear_current()
		DeathCamera.global_transform.origin = PlayerCamera.global_transform.origin
		DeathCamera.global_position = PlayerCamera.global_position
		DeathCamera.global_rotation = PlayerCamera.global_rotation
		DeathCamera.global_transform = PlayerCamera.global_transform
		DeathCamera.init(Player)
		_setGameOverVisibility(true)
		DeathCamera.set_physics_process(true)
		DeathCamera.make_current()
		
	else:
		points = 0
		_addPoints(0)
		DeathCamera.set_physics_process(false)
		_setGameOverVisibility(false)
		DeathCamera.clear_current()
		PlayerCamera.make_current()

var wait_for_input_timer
func _setGameOverVisibility(visible):
	$Player/PlayerCamera/Points.visible = !visible
	$DeathCamera/GameOverText.visible = visible
	$DeathCamera/GameOverPoints.text =  str(points)
	$DeathCamera/GameOverPoints.visible = visible	
	
	if not visible:
		$DeathCamera/AnyKeyText.visible = false
	else:
		if wait_for_input_timer.time_left <= 0.0:
			wait_for_input_timer = get_tree().create_timer(1.5)
			await wait_for_input_timer.timeout
			$DeathCamera/AnyKeyText.visible = true
			listen_to_input = true
	
func _physics_process(delta):
	if not listen_to_input:
		return
	
	if Input.is_anything_pressed() and player_killed:
		_restart()
	
		
func _on_enemy_spawn_timer_timeout():

	# And give it a random offset.

	var point = spawn_points[randi_range(0, spawn_points.size()-1)]
	var mob = enemy_scene.instantiate()
	mob.set_position(point.global_position)
	mob.connect("enemy_hit", _enemy_hit)
	mob.add_to_group("enemy")
	add_child(mob)
	if (Player != null):
		print($Player.global_position)
		mob.update_target($Player)


func _enemy_hit():
	_addPoints(1)
	
func _addPoints(p):
	points += p
	$Player/PlayerCamera/Points.text = str(points)
