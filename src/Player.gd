extends CharacterBody3D

@onready var gun_controller =$GunController
var camera : Camera3D
signal player_killed

var speed = 25
func _ready():
	camera = get_parent().find_child("Camera")
func Kill():
	print("killed")
	player_killed.emit()
	queue_free()
		
func _physics_process(delta):
	
	#movement
	camera.get_global_transform()
	velocity = Vector3.ZERO
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= 100 * delta
		
	if Input.is_action_pressed("ui_right"):
		rotate_y(-0.05)
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.05)	
	if Input.is_action_pressed("ui_up"):
		var forward_direction= -global_transform.basis.z.normalized()
		global_translate(forward_direction * speed * delta)
	if Input.is_action_pressed("ui_down"):
		var forward_direction= global_transform.basis.z.normalized()
		global_translate(forward_direction * speed * delta)

	move_and_slide()

	#shoot
	if Input.is_action_pressed("primary_action"):
		gun_controller.shoot()


func _on_gun_controller_tree_entered():
	pass # Replace with function body.


func _on_area_3d_area_entered(area):
	print("area entered")
	Kill()
