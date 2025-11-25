class_name Gegner
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_ray_cast: RayCast2D = $EnemyRayCast
@onready var floor_ray_cast: RayCast2D = $FloorRayCast
@onready var timer: Timer = $Timer

@export var speed: float = 50

var on_screen: bool = false
var direction: float = 0.0
var turned: bool = false


func _ready() -> void:
	animated_sprite_2d.connect("animation_finished", on_animation_finished)


func _process(delta: float) -> void:
	turn()

	if on_screen: move(delta)
	


func move(delta: float) -> void:
	position.x += speed * delta * get_direction()


func turn() -> void:
	if !floor_ray_cast.is_colliding() and !turned:
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		floor_ray_cast.position *= -1
		turn_enemy_ray_cast()
		timer.start(0.3)
		turned = true


func turn_enemy_ray_cast() -> void:
	enemy_ray_cast.rotation_degrees += 180
		
	if enemy_ray_cast.rotation_degrees > 360:
		enemy_ray_cast.rotation_degrees -= 360


func get_direction() -> float:
	if animated_sprite_2d.flip_h:
		direction = -1
	else:
		direction = 1
	
	return direction


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
	animated_sprite_2d.play("wake")


func _on_timer_timeout() -> void:
	turned = false


func on_animation_finished() -> void:
	if animated_sprite_2d.animation == "wake":
		animated_sprite_2d.play("idle")


func _on_area_entered(area: Area2D) -> void:
	if enemy_ray_cast.is_colliding():
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		turn_enemy_ray_cast()
		floor_ray_cast.position *= -1
