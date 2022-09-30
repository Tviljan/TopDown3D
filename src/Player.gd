extends CharacterBody3D

@onready var gun_controller =$GunController

var speed = 25

func _physics_process(delta):
	
	#movement
	velocity = Vector3.ZERO
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= 100 * delta
		
	if Input.is_action_pressed("ui_right"):
		rotate_y(-0.1)
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.1)	
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
