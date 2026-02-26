extends Area2D

@onready var particles = $CPUParticles2D
@onready var sprite = $Sprite2D
var health = 100.0

#TODO: wait a tiny bit in order to destroy it, add an await func

func _input_event(viewport, event, shape_idx):
	# if event is InputEventScreenTouch and event.pressed:
	if event is InputEventMouseButton and event.pressed:
		add_damage()

func add_damage():
	health -= 25
	
	print(health)
	particles.emitting = true
	
	if is_equal_approx(health, 0.0):
		particles.emitting = true
		destroy_object()

func destroy_object():	
	if sprite:
		sprite.visible = false
		
	particles.emitting = true
		
	await get_tree().create_timer(particles.lifetime).timeout

	# here add it to the inventory	
	
	queue_free()
