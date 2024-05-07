extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	#player.increase_health(1)
	if area.get_parent() is Player:
	
		area.get_parent().decrease_health(1)

