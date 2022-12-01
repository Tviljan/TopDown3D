extends CharacterBody3D

@onready var gun_controller =$GunController
@onready var robotAnimation : AnimationPlayer = $"George/AnimationPlayer"

var camera : Camera3D
signal player_killed
var killed = false
var speed = 25
func _ready():
	camera = get_parent().find_child("Camera")
	
func Kill():
	print("killed")
	killed = true
	await get_tree().create_timer(1.0).timeout
	player_killed.emit()
	

var running = false
func DeadState(delta):
	if (!running):
		running = true
		robotAnimation.play("Death")

var fallingAnimationShown = false
var fallTime = 0
var fall_time_limit = 2;
func FallingState(delta):
	velocity.y -= 150 * delta
	fallTime += delta
	
	if fallingAnimationShown == false:
		robotAnimation.play("Jump")
		fallingAnimationShown = true
	else:		
		robotAnimation.play("Idle")
		
	if fallTime > fall_time_limit:
		robotAnimation.play("Hello")
		await get_tree().create_timer(1).timeout
		Kill()

func ActionState(delta):	
	var moving = false;
	
	if Input.is_action_pressed("ui_right"):
		rotate_y(-0.05)
	if Input.is_action_pressed("ui_left"):
		rotate_y(0.05)	
	if Input.is_action_pressed("ui_up"):
		moving = true
		var forward_direction= -global_transform.basis.z.normalized()
		global_translate(forward_direction * speed * delta)
	if Input.is_action_pressed("ui_down"):
		moving = true
		var forward_direction= global_transform.basis.z.normalized()
		global_translate(forward_direction * speed * delta)
		
	if moving:
		if Input.is_action_pressed("primary_action"):
			robotAnimation.play("Run_Holding")
		else:
			robotAnimation.play("Run")
	else:
		if Input.is_action_pressed("primary_action"):
			robotAnimation.play("Holding")
		else:
			robotAnimation.play("Idle")
		
		

	#shoot
	if Input.is_action_pressed("primary_action"):
		await get_tree().create_timer(0.1).timeout
		gun_controller.shoot()
		
	
func _physics_process(delta):
	
	#movement
	camera.get_global_transform()
	velocity = Vector3.ZERO
		# Add the gravity.
	if not is_on_floor():
		FallingState(delta)
	elif killed:
		DeadState(delta)
	else:
		ActionState(delta)
	
	move_and_slide()

func _on_gun_controller_tree_entered():
	pass # Replace with function body.


func _on_area_3d_area_entered(area):
	#Kill()
	pass
