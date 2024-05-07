extends Sprite2D

var speed = 400  # 子弹的速度，可根据需要调整
var direction = 1  # 默认方向为右（1为右，-1为左）
var locked_y_position = null  # 锁定的y坐标，初始时未设置

func _ready():
	locked_y_position = position.y
	$Hitbox.connect("body_entered", Callable(self, "_on_body_entered"))




func _physics_process(delta: float) -> void:
	if speed == null or direction == null:
		print("Error: 'speed' or 'direction' is null.")
		return

	position.x += speed * direction * delta  # 根据方向和速度更新位置
	if locked_y_position != null:
		position.y = locked_y_position 


func _on_body_entered(body):
	print("Collided with", body.name)
	queue_free()



func _on_hitbox_hit(hurtbox: Variant) -> void:
	queue_free()
