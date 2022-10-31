extends CharacterBody3D

@export var speed = 12.0
@onready var nav_agent : NavigationAgent3D = $"NavigationAgent3d"
var next_nav_position : Vector3 
var target_object : Node3D
var movement_delta : float
var target_location
const gravity = 4.5

@onready var animationPlayer : AnimationPlayer = $"AnimationPlayer"
@onready var meshInstance : MeshInstance3D = $"MeshInstance"
@onready var defaultMesh = load("res://EnemyMesh.tres")
@onready var explosionMesh = load("res://ExplosionMesh.tres")


func update_target(target: Node3D):
	target_object= target
	target_location = target.global_transform.origin
	#print("update target", target_location)
	if nav_agent:
		nav_agent.distance_to_target()
		nav_agent.set_target_location(target_location)
		nav_agent.get_next_location
		if !nav_agent.is_target_reachable():
			print("can't reach that")
		if nav_agent.is_target_reached():
			print("already there..waiting")
			await get_tree().create_timer(1.0).timeout
			update_target(target_object)
	

func _ready():
	print("start ready")
	meshInstance.mesh = defaultMesh 
	#this is required to make things move
	animationPlayer.current_animation = "[stop]"
	nav_agent.avoidance_enabled = true
	# connect nav agent signal callback functions
	nav_agent.path_changed.connect(character_path_changed)
	nav_agent.target_reached.connect(character_target_reached_reached)
	nav_agent.navigation_finished.connect(character_navigation_finished)
	nav_agent.velocity_computed.connect(enemy_velocity_computed)
	nav_agent.max_speed = speed
	print("end ready")
	

func _physics_process(delta):	
	if not nav_agent.is_target_reachable():
		explode()
		
	var next_path_position : Vector3 = nav_agent.get_next_location()
	var current_agent_position : Vector3 = global_transform.origin
	var new_velocity : Vector3 = (next_path_position - current_agent_position).normalized() * speed
	nav_agent.set_velocity(new_velocity)


func character_path_changed() -> void:
#	print("character_path_changed", nav_agent.get_nav_path())
	if nav_agent.is_target_reached():
		print("Alredy there")
	
func character_target_reached_reached() -> void:
	print("character_target_reached_reached")
	var s = target_object.global_position.distance_to(self.global_position)
	if s < 10:
		explode()
	else:
		update_target(target_object)
	
func character_navigation_finished() -> void:	
	print("character_navigation_finished")
#	var s = target_object.global_position - self.global_position
	var s = target_object.global_position.distance_to(self.global_position)
	if s < 5:
		explode()
	else:
		update_target(target_object)
	
func enemy_velocity_computed(safe_velocity : Vector3) -> void:
	if not is_on_floor():
		safe_velocity.y -= gravity
	velocity = safe_velocity
	
	move_and_slide()


func _on_collision_shape_child_entered_tree(node):
	print("Child entered") # Replace with function body.

func explode():
	meshInstance.mesh = explosionMesh
	animationPlayer.play("explosion")
	nav_agent.path_changed.disconnect(character_path_changed)
	nav_agent.target_reached.disconnect(character_target_reached_reached)
	nav_agent.navigation_finished.disconnect(character_navigation_finished)
	nav_agent.velocity_computed.disconnect(enemy_velocity_computed)
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
func _on_stats_death_signal():
	explode()
