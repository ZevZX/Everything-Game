extends Node2D

@onready var screen_size = get_viewport().size

func _ready():
	$Apple.position = Vector2(screen_size.x - 60,screen_size.y - 40)
	$ScoreText.position = Vector2(screen_size.x - 40,screen_size.y - 50)
func update_score(snake_length):
	$ScoreText.text = str(snake_length - 2)
