extends Node

@export var o_scene : PackedScene
@export var x_scene : PackedScene

var player : int
var moves : int
var winner : int
var grid_data : Array
var grid_pos : Vector2i
var board_size : int
var cell_size : int
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int

# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = $Board.texture.get_width()
	# divide board size by 3 to get the size of individual cell
	cell_size = board_size / 3
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#check if mouse is on the game board
			if event.position.x < board_size:
				#convert mouse position into grid location
				grid_pos = Vector2i(event.position / cell_size)
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					moves += 1
					grid_data[grid_pos.y][grid_pos.x] = player
					#place that player's marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					if check_win() != 0:
						get_tree().paused = true
						$GameOverMenu.show()
						if winner == 1:
							$GameOverMenu.get_node("ResultLabel").text = "Player 1 Wins!"
						elif winner == -1:
							$GameOverMenu.get_node("ResultLabel").text = "Player 2 Wins!"
					#check if the board has been filled
					elif moves == 9:
						get_tree().paused = true
						$GameOverMenu.show()
						$GameOverMenu.get_node("ResultLabel").text = "It's a Tie!"
					player *= -1
					print(grid_data)

func new_game():
	player = 1
	moves = 0
	winner = 0
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
		]
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	#clear existing markers
	get_tree().call_group("o", "queue_free")
	get_tree().call_group("x", "queue_free")
	$GameOverMenu.hide()
	get_tree().paused = false

func create_marker(player, position, temp=false):
	#create a marker node and add it as a child
	if player == 1:
		var o = o_scene.instantiate()
		o.position = position
		add_child(o)
	else:
		var x = x_scene.instantiate()
		x.position = position
		add_child(x)

func check_win():
	#add up the markers in each ros, column and diagonal
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
		#check if either player has all of the markers in one line
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner


func _on_game_over_menu_restart():
	new_game()
