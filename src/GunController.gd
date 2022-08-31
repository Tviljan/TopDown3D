extends Node



@export var StartingWeapon : PackedScene
var hand : Node3D
var equiped_weapon : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hand = get_parent().find_child("HandPosition")
	
	if (StartingWeapon):
		equip_weapon(StartingWeapon)
		
func shoot():
	if (equiped_weapon):
		equiped_weapon.shoot()
		
func equip_weapon(weapon_to_equip):
	if equiped_weapon:
		#print("Deleting weapong")
		equiped_weapon.queue_free()
	else:
		#print("No weapon")
		equiped_weapon = weapon_to_equip.instantiate() #Create instance of the PackedScene
		hand.add_child(equiped_weapon)
