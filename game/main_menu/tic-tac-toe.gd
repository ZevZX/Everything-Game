extends Button

func _on_pressed():
	get_tree().change_scene_to_file("res://game/tic_tac_toe/main.tscn")
