extends Enemy

enum State {
	IDLE,
	HIT,
	RUN
	
}
@onready var calm_down_timer: Timer = $CalmDownTimer

@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
var current_state = State.IDLE

var player_detected = false
func _ready():
	transition_state(-1, current_state)
	calm_down_timer.connect("timeout", Callable(self, "_on_calm_down_timeout"))

func _on_calm_down_timeout():
	player_detected = false  # 重置玩家检测标志
	
func tick_physics(state: State, delta: float)->void:
	match state:
		State.IDLE:
			move(0.0, delta)
		State.RUN:
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				direction *=-1
			move(max_speed,delta)
			if player_checker.is_colliding():
				calm_down_timer.start()

func get_next_state(state: State) -> State:
	if player_checker.is_colliding():
		player_detected = true
	match state:
		State.IDLE:
			if calm_down_timer.is_stopped() and player_detected:
				return State.RUN
				
		State.RUN:
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				return State.IDLE
		
	return state
	
	
func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" % [
		Engine.get_physics_frames(),
		State.keys()[from] if from !=-1 else "<START>",
		State.keys()[to],
	]
		
	)
	
	match to:
		State.IDLE:
			animation_player.play("idle")
			
		State.RUN:
			animation_player.play("run")


func _physics_process(delta: float):
	#print("Current State: ", State.keys()[current_state])
	var next_state = get_next_state(current_state)
	if next_state != current_state:
		transition_state(current_state, next_state)
		current_state = next_state
	tick_physics(current_state, delta)
	



var max_health: int = 4

var health: int = max_health

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	health -=1
	if health ==0:
		queue_free()
