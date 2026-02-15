extends CharacterBody2D

@export var SPEED := 200.0
const TILE_SIZE := Vector2(10, 10)

var target_position: Vector2
var moving := false

@onready var walking_particles = $WalkingParticles
@onready var anim_player = $AnimationPlayer

func _ready():
	target_position = global_position

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed and not moving:
		var touch_pos = get_global_mouse_position()
		var diff = touch_pos - global_position
		
		var dir := Vector2.ZERO
		
		if abs(diff.x) > abs(diff.y):
			dir = Vector2.RIGHT if diff.x > 0 else Vector2.LEFT
		else:
			dir = Vector2.DOWN if diff.y > 0 else Vector2.UP
		
		try_move(dir)

func _physics_process(delta):
	if moving:
		var direction = target_position - global_position
		
		walking_particles.emitting = true
		
		if direction.length() < 2:
			global_position = target_position
			moving = false
		else:
			global_position += direction.normalized() * SPEED * delta
			
		anim_player.play("walking")
	
	walking_particles.emitting = false
	anim_player.play("idle")

func try_move(dir: Vector2):
	var next_position = target_position + dir * TILE_SIZE
	
	if not is_blocked(next_position):
		target_position = next_position
		moving = true

func is_blocked(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = collision_mask
	query.exclude = [self]
	
	var result = space_state.intersect_point(query)
		
	return result.size() > 0
