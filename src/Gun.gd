extends Node3D

@export var Bullet :PackedScene

@export var muzzle_speed = 30
@export var millis_between_shots = 100
@onready var rof_timer = $Timer
var can_shoot = true

func _ready():
	rof_timer.wait_time = millis_between_shots/1000.0
	
func _physics_process(_delta):
	pass
	
	
func shoot():
	if can_shoot:
		rof_timer.start()
		var newBullet = Bullet.instantiate()
		$Shoot2.play()
		newBullet.global_transform = $MeshInstance/Muzzle.global_transform
		newBullet.scale = Vector3(1, 1.2, 1)
		newBullet.speed = muzzle_speed

		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(newBullet)
		#print("pew!")
		can_shoot = false
		


func _on_Timer_timeout():
	can_shoot = true
