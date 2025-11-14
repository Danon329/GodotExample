extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var gravity: float = 400.0
@export var break_factor: float = 20.0
@export var speed: float = 200.0

const JUMP_HEIGHT: float = -300.0

var direction: float = 0
var is_walking: bool = false
var is_in_air: bool = false

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_break()
	
	movement()
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor() and is_in_air:
		is_in_air = false
		if is_walking:
			anim_player.play("walk")
		else:
			anim_player.play("idle")


#func apply_break() -> void:
#	if !is_equal_approx(velocity.x, 0) and Input.get_axis("links", "rechts") == 0:
#		velocity.x += break_factor * -direction
#	else:
#		velocity.x = 0

func apply_break() -> void:
	if velocity.x < -10 or velocity.x > 10:
		velocity.x += break_factor * -direction # improve math behind break
	elif velocity.x > -10 and velocity.x < 10:
		velocity.x = 0
		if is_on_floor():
			anim_player.play("idle")
			is_walking = false


func movement() -> void:
	walk()
	jump()


func walk() -> void:
	var dir: float = Input.get_axis("links", "rechts")

	if dir != 0:
		direction = dir
		velocity.x = speed * direction
		flip_sprite()
		if !is_walking and is_on_floor():
			anim_player.play("walk")
			is_walking = true


func jump() -> void:
	if Input.is_action_pressed("springen") and is_on_floor():
		velocity.y = JUMP_HEIGHT
		anim_player.play("jump")
		is_in_air = true
	elif Input.is_action_just_released("springen"):
		velocity.y = 0


func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

