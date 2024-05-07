extends ProgressBar


@export var player: Player


func _ready() -> void:
	#player.playerHealthChanged.connect(update)
	#update()
	if player:
		player.connect("playerHealthChanged", Callable(self, "update"))
		update()
	else:
		print("Player node is not found or not ready.")

func update():
	value = player.PHealth * 100/ player.max_phealth
