extends Node3D

@onready var Player :CharacterBody3D = $Player
@onready var PlayerCamera : Camera3D = $Player/PlayerCamera
@onready var timer : Timer = $EnemySpawnTimer
@onready var DeathCamera : Camera3D = $DeathCamera

@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@export var player :PackedScene = preload("res://Player.tscn")

var spawn_points
var points = 0

func _ready():
	Player.connect("player_killed", _player_killed)	
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	
var player_killed = false

func _restart():
	get_tree().call_group("enemy", "explode")
	
	await get_tree().create_timer(.5).timeout
	player_killed = false
	Player.killed = false
	Player = null
	Player = player.instantiate()
	switch_camera()
	timer.start()
	
func _player_killed():
	if not player_killed:
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
		
func _setGameOverVisibility(visibile):
	$Player/PlayerCamera/Points.visible = !visibile
	$DeathCamera/GameOverText.visible = visibile
	$DeathCamera/GameOverPoints.text =  str(points)
	$DeathCamera/GameOverPoints.visible = visibile	
	$DeathCamera/AnyKeyText.visible = visibile	
	
func _physics_process(delta):
	if Input.is_action_just_released("ui_page_down"):
		pass #switch_camera()
	
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
