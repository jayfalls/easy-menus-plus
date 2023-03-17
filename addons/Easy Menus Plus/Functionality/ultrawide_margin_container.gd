extends MarginContainer

var border_margin: Vector2 = Vector2(15,30)

# Called when the node enters the scene tree for the first time.
func _ready():
	adjust_size()

func adjust_size():
	var resolution: Vector2 = get_viewport_rect().size
	var ratio: float = snapped(resolution.x / resolution.y, 0.1)
	if ratio > 1.6:
		custom_minimum_size.x = int(resolution.y * 1.6)
	else:
		custom_minimum_size.x = resolution.x
