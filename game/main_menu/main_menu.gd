extends Node2D

func _ready():
	# Connect to the resized signal of the main viewport
	get_viewport().connect("size_changed", self, "_on_viewport_resized")

func _on_viewport_resized():
	# Calculate the scale factor based on the new window size
	var scale_factor = Vector2(get_viewport_rect().size.x / 1920, get_viewport_rect().size.y / 1080)
	
	# Apply the scale factor to the root node
	$RootNode.scale = scale_factor

	# Adjust the camera if needed
	# $Camera.zoom = 1.0  # Adjust zoom level based on the window size
	
	# Adjust UI elements if needed
	# $UIContainer.rect_size = get_viewport_rect().size  # Resize UI container
