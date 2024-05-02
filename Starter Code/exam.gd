extends Node2D

var slider: Slider
var label: Label
var slidervalue = 0


func _ready():
	# Get references to the Slider and Label nodes
	slider = $CanvasLayer/HSlider
	label = $CanvasLayer/HSlider/Label  # Assuming the label is the first child of the slider
	
	# Set the slider's min and max values
	slider.min_value = 1
	slider.max_value = 20
	
	# Connect the slider's value_changed signal to a function
	
	
	# Initialize the label's text
	update_label_text()

func _on_h_slider_value_changed(value):
	slidervalue = int(value)
	update_label_text()

func update_label_text():
	# Set the label's text to the value of the slider
	label.text = str(int(slider.value))

func _on_button_pressed():
	slidervalue = int(slidervalue)
	
	# Center position of the spawned sprites
	var center_position = Vector2(516, 512)  # Adjust this based on your center position
	
	# Calculate angle increment based on the number of sprites to spawn
	var angle_increment = 360.0 / slidervalue
	
	for i in range(slidervalue):
		# Calculate the angle for the current sprite
		var angle = i * angle_increment
		
		# Calculate the position of the sprite around the center
		var position = center_position + Vector2(100 * cos(deg_to_rad(angle)), 100 * sin(deg_to_rad(angle)))
		
		# Spawn the sprite
		spawn_sprite(position)

# Define a collision layer and mask for the spawned rigid bodies
const SPAWNED_RIGIDBODY_LAYER = 1
const SPAWNED_RIGIDBODY_MASK = 0




func spawn_sprite(position):
	# Create a new RigidBody2D node
	var rigidbody = RigidBody2D.new()

	# Enable gravity for the rigidbody
	rigidbody.gravity_scale = 1.0  # You can adjust this value if needed
	rigidbody.mass = 2.0
	
	# Add the RigidBody2D node to the scene
	$CanvasLayer.add_child(rigidbody)

	# Create a new Sprite2D node
	var sprite_instance = Sprite2D.new()
	var center_position = Vector2(516, 512)

	# Load the texture
	var texture = load("res://icon.svg")

	# Set the texture
	sprite_instance.texture = texture 

	# Set the scale of the sprite
	sprite_instance.scale.x = 1  # Scale factor along the X-axis
	sprite_instance.scale.y = 1  # Scale factor along the Y-axis
	
	# Adjust the distance from the center sprite
	var distance_factor = 250  # Adjust this value as needed
	var direction_vector = position - center_position
	position = center_position + direction_vector.normalized() * distance_factor
	
	# Set the position of the sprite
	sprite_instance.position = position

	# Add the Sprite2D node as a child of the rigidbody
	rigidbody.add_child(sprite_instance)

	# Create a new RectangleShape2D for the collision shape
	var collision_shape = RectangleShape2D.new()
	collision_shape.extents = sprite_instance.texture.get_size() / 2  # Set the size of the collision shape to half the size of the sprite

	# Create a new CollisionShape2D node
	var collision_shape_node = CollisionShape2D.new()
	# Assign the collision shape to the CollisionShape2D node
	collision_shape_node.shape = collision_shape
	# Add the CollisionShape2D node as a child of the rigidbody
	rigidbody.add_child(collision_shape_node)

	# Set collision layers and masks to disable collisions with other spawned rigid bodies
	rigidbody.collision_layer = SPAWNED_RIGIDBODY_LAYER
	rigidbody.collision_mask = SPAWNED_RIGIDBODY_MASK


func _on_area_2d_area_entered(area):
	var collider = area.get_collider()
	# Check if the collider exists
	if collider:
		print("Object entered the Area2D:", collider.name)
		# Get the children of the collider (assuming the sprite is a direct child)
		var children = collider.get_children()
		# Iterate over the children and destroy them
		for child in children:
			print("Destroying child:", child.name)
			child.queue_free()
		# Destroy the collider (rigid body)
		print("Destroying collider:", collider.name)
		collider.queue_free()





func _on_rigid_body_2d_body_entered(body):
	self.queue_free()
	if body:
		body.queue_free()
