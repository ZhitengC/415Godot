class_name Player

extends CharacterBody2D

const RUN_SPEED :=200.0
const JUMP_VELOCITY := -300.0

signal playerHealthChanged
signal playerCoinChanged

var gravity := ProjectSettings.get("physics/2d/default_gravity") as float
var b

var twoShot = 1

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@onready var bullet = preload("res://bullet.tscn")
@onready var stats: Node = $Stats


func _physics_process(delta: float) -> void :
	var direction := Input.get_axis("move_left","move_right")
	velocity.x = direction *RUN_SPEED
	velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	if is_on_floor():
		if is_zero_approx(direction):
			animation_player.play("idle")
		else: 
			animation_player.play("running")
			
		
	else:
		animation_player.play("jump")
		
		
	if Input.is_action_just_pressed("shoot"):
		print("Shooting now! sprite_2d.flip_h:", sprite_2d.flip_h)  # Debug 输出

		b = bullet.instantiate()
		b.direction = -1 if sprite_2d.flip_h else 1
		var offset_x = -10 if sprite_2d.flip_h else 10
		var offset_y = -20
		b.position.x = b.position.x + offset_x
		b.position.y = b.position.y + offset_y
		print("Bullet position set to:", b.position)  # Debug 输出子弹位置
		add_child(b)
		
		if twoShot ==2:
			var b2 = bullet.instantiate()
			b2.direction = -1 if sprite_2d.flip_h else 1
			var offset_x2 = -11 if sprite_2d.flip_h else 11  # 调整第二发子弹的位置
			var offset_y2 = -10
			b2.position.x = b.position.x + offset_x2
			b2.position.y = b.position.y + offset_y2
			print("Second bullet position set to:", b2.position)  # Debug 输出子弹位置
			add_child(b2)
		


		
	if not is_zero_approx(direction):
		sprite_2d.flip_h = direction<0
		
		
	
	
	move_and_slide()
	



	
var max_phealth: int = 5
var PHealth: int = max_phealth

var Pcoin: int = 0

func _ready() -> void :
	max_phealth = 5
	PHealth = max_phealth
	var Pcoin = 0
	playerHealthChanged.emit()
	return

func _on_hurtbox_hurt(hitbox: Variant) -> void:
	PHealth -= 1
	playerHealthChanged.emit()
	if PHealth ==0:
		queue_free()
		get_tree().reload_current_scene()
	
	#var stats = get_node("Stats")
	#stats.health -= 1
	#if stats.health ==0:
		#queue_free()
		#get_tree().reload_current_scene()


func increase_health(amount: int):
	if PHealth <5:
		
		PHealth += amount
		playerHealthChanged.emit()
	print("Health increased to : ", PHealth)
	
func increase_ammo(amount: int):
	if twoShot<2:
		twoShot+=amount
		print("now two shot mode ")
	
func decrease_health(amount: int):
	if PHealth <=5:
		
		PHealth -= amount
		playerHealthChanged.emit()
	if PHealth == 0:
		get_tree().reload_current_scene()
	print("Health decreased to : ", PHealth)


func increase_score(amount: int):
	Pcoin+= amount
	print("Pcoin increased to : ",Pcoin)
	playerCoinChanged.emit()
