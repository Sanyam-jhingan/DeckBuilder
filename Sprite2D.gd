extends Sprite2D

@onready var animated_sprite = $AnimatedSprite2D  # Get the AnimatedSprite2D node

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")  # Start playing the animation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
