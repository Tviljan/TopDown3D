extends Node3D

var ray_origin = Vector3()
var ray_target = Vector3()

@onready var Camera = $Camera
@onready var Player :CharacterBody3D = $Player
@onready var enemy = $Enemy

func _ready():
	enemy.update_target_location(Player.global_position)
	
func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
#	print("Mouse position", mouse_position)

	ray_origin = Camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + Camera.project_ray_normal(mouse_position) * 2000
	
	var space_state = get_world_3d().direct_space_state
	
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_target
	#params.exclude = obstacles
	var intersection = space_state.intersect_ray(params)
	
	if not intersection.is_empty():
		#print("not empty")
		var pos = intersection.values()[0]
		var look_at_me = Vector3(pos.x, Player.position.y, pos.z)
		Player.look_at(look_at_me, Vector3.UP)
	
	
	if Input.is_action_pressed("primary_action"):
			
		enemy.update_target_location(Player.global_position)
		
