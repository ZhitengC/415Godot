extends CollisionShape2D


var game_success_screen = preload("res://game_success_screen.tscn")
func _ready():
	
	print(game_success_screen) 

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var success_screen_instance = game_success_screen.instantiate()
		get_tree().root.add_child(success_screen_instance)
		get_tree().reload_current_scene()
		queue_free()
