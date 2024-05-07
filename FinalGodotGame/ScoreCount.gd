extends Label

@export var player:Player


func _ready() -> void:
	if player:
		player.connect("playerCoinChanged", Callable(self,"update"))
		update()
	else:
		print("player Node is not found")
		

func update():
	self.text = "Coins: " + str(player.Pcoin)
	
