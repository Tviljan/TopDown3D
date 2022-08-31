extends CharacterBody3D

@export var speed = 3.0
@export var gravity = 1.0
@onready var nav_agent : NavigationAgent3D = $"NavigationAgent3D"
var next_nav_position : Vector3 
var movement_delta : float

func update_target_location(target_location):
	print("update target", target_location)
	nav_agent.set_target_location(target_location)
	

func _ready():
	# connect nav agent signal callback functions
	nav_agent.path_changed.connect(character_path_changed)
	nav_agent.target_reached.connect(character_target_reached_reached)
	nav_agent.navigation_finished.connect(character_navigation_finished)
	nav_agent.velocity_computed.connect(enemy_velocity_computed)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	movement_delta = speed * delta
	var next_path_position : Vector3 = nav_agent.get_next_location()
	var current_agent_position : Vector3 = global_transform.origin
	
	#print("next_path_position", next_path_position)
	#print("current_agent_position", current_agent_position)
	var new_velocity : Vector3 = (next_path_position - current_agent_position).normalized() * movement_delta
	nav_agent.set_velocity(new_velocity)
	move_and_slide()
#	
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
	pass
	# check if nav agent target is reached
#	if !nav_agent.is_target_reached():
#		# move and slide with the new calculated velocity
#		move_and_slide()
#	else:
#		# if reached target, stand at the closest point in the navigation map
#		global_transform.origin = NavigationServer3D.map_get_closest_point(nav_agent.get_navigation_map(), global_transform.origin)
