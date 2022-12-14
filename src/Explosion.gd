extends Area3D


signal caught_in_explosion

@onready var animationPlayer : AnimationPlayer = $"AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("explosion")
	$GPUParticles3D.emitting = true
	
	var i = randi() % 1
	if i == 0:
		print("boom 1")
		$RobotExplode1.play()
	else:		
		print("boom 2")
		$RobotExplode2.play()
	await get_tree().create_timer(1.0).timeout	
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body: CharacterBody3D):
	emit_signal("caught_in_explosion")
