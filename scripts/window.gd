extends Area2D

func _on_area_entered():
	Player.set_focused_window()

func _on_area_exited():
	Player.set_free()
