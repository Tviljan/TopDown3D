extends CharacterBody3D

@onready var gun_controller =$GunController

var speed = 500

func _physics_process(delta):
	
	#movement
	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1	
	if Input.is_action_pressed("ui_up"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.z += 1
	
	velocity = velocity.normalized() * speed * delta
	move_and_slide()

	#shoot
	if Input.is_action_pressed("primary_action"):
		gun_controller.shoot()
