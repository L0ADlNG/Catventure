extends Node2D

func _ready():
	var fade = $CanvasLayer/Fade
	fade.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 0.5)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
