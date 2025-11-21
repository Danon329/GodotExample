class_name Spieler
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var gravity: float = 400.0
@export var break_factor: float = 1.0
@export var speed: float = 200.0

const JUMP_HEIGHT: float = -300.0

var direction: float = 0
var weight: float = 0.0
var is_walking: bool = false
var is_in_air: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		var main_scene: PackedScene = load("uid://cr07o1s3r4bs3")
		get_tree().change_scene_to_packed(main_scene)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_break(delta)
	
	movement()
	print(velocity)
	move_and_slide()

	fall_off()


func apply_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor() and is_in_air:
		is_in_air = false
		break_factor = 1.0
		if is_walking:
			anim_player.play("walk")
		else:
			anim_player.play("idle")


#func apply_break() -> void:
#	if !is_equal_approx(velocity.x, 0) and Input.get_axis("links", "rechts") == 0:
#		velocity.x += break_factor * -direction
#	else:
#		velocity.x = 0


func apply_break(delta: float) -> void:
	if (velocity.x <= -10 or velocity.x >= 10) and Input.get_axis("links", "rechts") == 0:
		weight += 0.7 * delta * break_factor

		velocity = velocity.lerp(Vector2(0, velocity.y),1 - exp(-weight))
	elif velocity.x > -10 and velocity.x < 10:
		velocity.x = 0
		weight = 0.0
		break_factor = 1.0

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
		break_factor = 0.1
	elif Input.is_action_just_released("springen"):
		velocity.y = 0


func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func fall_off():
	if position.y > 1000:
		queue_free()
