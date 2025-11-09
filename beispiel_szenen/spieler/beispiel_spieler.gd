extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var gravity: float = 400.0
@export var break_factor: float = 20.0
@export var speed: float = 200.0

const JUMP_HEIGHT: float = -300.0

var direction: float = 0
var anim_playing: bool = false

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_break()
	check_for_idle()
	
	movement()
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta


func apply_break() -> void:
	if !is_equal_approx(velocity.x, 0) and Input.get_axis("links", "rechts") == 0:
		velocity.x += break_factor * -direction
	else:
		velocity.x = 0


func check_for_idle() -> void:
	if is_on_floor() and velocity == Vector2.ZERO:
		sprite.play("idle")
		anim_playing = false


func movement() -> void:
	walk()
	jump()


func walk() -> void:
	var dir: float = Input.get_axis("links", "rechts")

	if dir != 0:
		direction = dir
		velocity.x = speed * direction
		flip_sprite()
		play_anim("walk")


func jump() -> void:
	if Input.is_action_pressed("springen") and is_on_floor():
		velocity.y = JUMP_HEIGHT
		play_anim("jump");
	elif Input.is_action_just_released("springen"):
		velocity.y = 0


func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func play_anim(animation: String): # rework animation system
	if !anim_playing:
		sprite.play(animation)
		anim_playing = true
	else:
		return
