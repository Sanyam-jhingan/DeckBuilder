extends Node2D

var card_being_dragged = null
var drag_offset = Vector2.ZERO
var screen_size = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	screen_size = get_viewport_rect().size
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		# Calculate the target position based on where the card was grabbed.
		var target_pos = mouse_pos - drag_offset
		
		# --- Card Boundary Enhancements ---
		# Determine the card's visual size. Use a fallback size if no Sprite2D is found.
		var card_size = Vector2(195, 305)  # Default fallback; adjust as needed.
		if card_being_dragged.has_node("Sprite2D"):
			var sprite = card_being_dragged.get_node("Sprite2D") as Sprite2D
			if sprite.texture:
				card_size = sprite.texture.get_size()
		
		# If your card’s pivot is its center, then calculate half-size.
		var half_size = card_size / 2.0
		
		# Clamp the target so that the card remains fully visible on-screen.
		target_pos.x = clamp(target_pos.x, half_size.x, screen_size.x - half_size.x)
		target_pos.y = clamp(target_pos.y, half_size.y, screen_size.y - half_size.y)
		
		# Immediately update the card’s position to the clamped target position.
		card_being_dragged.position = target_pos

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card_being_dragged = card
				# Record the offset from the card's center to the mouse position.
				drag_offset = get_global_mouse_position() - card.position
		else:
			card_being_dragged = null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		# Assumes each collider is a child of your card container.
		return result[0].collider.get_parent()
	return null
