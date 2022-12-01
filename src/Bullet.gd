extends Area3D

@export var speed = 60
const KILL_TIME = 1
var timer = 0

func _physics_process(delta):
	var forward_direction= global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)
	timer += delta
	
	if (timer > KILL_TIME):
		queue_free()
		

func _on_body_entered(body):
	print("area entered", body)
	queue_free() # Replace with function body..

	if body.has_node("Stats"):
		var stats_node = body.find_child("Stats") as Stats
		stats_node.take_hit(5)
