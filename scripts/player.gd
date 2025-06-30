extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var target_position: Vector2 = Vector2(400.0, -1643.0)
@export var arrival_threshold: float = 5.0
var is_hit := false 
var has_arrived := false

func _physics_process(delta: float) -> void:
	if is_hit or has_arrived:
		return 
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
		
	else:
		animated_sprite.play("jump")
	
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not has_arrived and position.distance_to(target_position) < arrival_threshold:
		Music.get_node("/root/Music").stream_paused = true
		has_arrived = true
		velocity = Vector2.ZERO
		zoom_camera()
		animated_sprite.play("end")
		await get_tree().create_timer(12.0).timeout
		zoom_out_and_pan()
		
	move_and_slide()

func hit():
	is_hit = true
	velocity = Vector2.ZERO
	animated_sprite.play("hit")
	
func zoom_camera():
	var tween = create_tween()
	tween.tween_property($Camera2D, "zoom", Vector2(10, 10), 1.0)  
	
func zoom_out_and_pan():
	var camera := $Camera2D
	var tween := create_tween()

	tween.tween_property(camera, "zoom", Vector2(1.5, 1.5), 4.0)
	
	camera.offset = Vector2(-400, 0)
	
	tween.tween_property(camera, "offset:y", 450, 30.0)
	
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(35.0).timeout
	$AudioStreamPlayer2D.stop()
	
	Music.get_node("/root/Music").stream_paused = false
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
