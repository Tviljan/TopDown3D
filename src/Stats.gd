extends Node
class_name Stats

@export var max_HP = 10

signal death_signal
signal hit_signal

var current_HP = max_HP
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_hit(damage):
	current_HP -= damage
	print("I'm hit ", current_HP, "/", max_HP)
	
	emit_signal("hit_signal")
	if current_HP <= 0:
		die()
		
func die():
	print("Args I dies!")
	emit_signal("death_signal")
