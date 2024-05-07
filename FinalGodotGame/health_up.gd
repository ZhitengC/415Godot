extends Node2D

class_name HealthUp

#
#@onready var player = get_node("TileMap/Player") as Player
#
#func _ready():
	#if player:
		#print("Player found and ready.")
	#else:
		#print("Player not found.")


func _on_area_2d_area_entered(area: Area2D) -> void:
	#player.increase_health(1)
	if area.get_parent() is Player:
	
		area.get_parent().increase_health(1)
		queue_free()
