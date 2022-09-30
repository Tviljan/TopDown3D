extends CharacterBody3D

@export var speed = 12.0
@onready var nav_agent : NavigationAgent3D = $"NavigationAgent3d"
var next_nav_position : Vector3 
var movement_delta : float
var target

func update_target_location(target_location):
	
	print("update target", target_location)
	target = target_location
	if nav_agent:
		nav_agent.set_target_location(target)
	

func _ready():
	#this is required to make things move
	nav_agent.avoidance_enabled = true
	# connect nav agent signal callback functions
	nav_agent.path_changed.connect(character_path_changed)
	nav_agent.target_reached.connect(character_target_reached_reached)
	nav_agent.navigation_finished.connect(character_navigation_finished)
	nav_agent.velocity_computed.connect(enemy_velocity_computed)
	nav_agent.max_speed = speed
	nav_agent.set_target_location(target)
	nav_agent.get_next_location
	

func _physics_process(_delta):	
	print("mob location ", global_position)
	if nav_agent.is_navigation_finished():
		return
	var targetpos = nav_agent.get_next_location()
	var direction = global_position.direction_to(targetpos)
	print(direction)
	velocity = direction * nav_agent.max_speed
	nav_agent.set_velocity(velocity)

func character_path_changed() -> void:
	#print("character_path_changed", nav_agent.get_nav_path())
	pass
	
func character_target_reached_reached() -> void:
	print("character_target_reached_reached")
	pass
	
func character_navigation_finished() -> void:
	print("character_navigation_finished")
	pass
	
func enemy_velocity_computed(safe_velocity : Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
