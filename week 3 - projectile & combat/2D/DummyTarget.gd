class_name DummyTarget
extends CharacterBody2D

@export var max_health: float = 100
@export var speed: float = 100
@export var gravity: float = 1000

@onready var health_bar: ProgressBar = $HealthBar
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var _current_health: float = 0
var direction: int = -1
var is_frozen: bool = false

func _ready() -> void:
	_current_health = max_health
	health_bar.max_value = max_health

func _physics_process(delta: float) -> void:
	# mati
	if _current_health <= 0:
		queue_free()
		return
	
	# ❄️ freeze
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		anim.stop()
		return
	
	# ⬇️ gravitasi (biar jatuh)
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	# ➡️ gerak kiri/kanan
	velocity.x = direction * speed
	move_and_slide()
	
	# 🎬 animasi run
	if velocity.x != 0:
		anim.play("run")
	else:
		anim.stop()
	
	# 🔄 flip arah
	anim.flip_h = direction > 0
	
	# 🚧 nabrak tembok → balik arah
	if is_on_wall():
		direction *= -1

func _process(_delta: float) -> void:
	health_bar.value = _current_health

func take_damage(damage: float) -> void:
	_current_health -= damage

# ❄️ fungsi freeze
func freeze(duration: float) -> void:
	if is_frozen:
		return
	
	is_frozen = true
	modulate = Color(0.5, 0.8, 1)
	
	await get_tree().create_timer(duration).timeout
	
	is_frozen = false
	modulate = Color(1, 1, 1)
