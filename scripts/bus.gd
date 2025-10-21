extends VehicleBody3D

var MAX_STEER := 0.6
var ENGINE_POWER := 150.0
var ARRIVAL_DISTANCE := 2.0

var BUS_STOPS = [
	Vector3(100, 0.5, -110),
	Vector3(7, 0.5, -110),
	Vector3(5, 0.5, 0),
	Vector3(97, 0.5, 3),
	Vector3(100, 50, 140)
]

var current_target_index: int = 0

func _physics_process(delta):
	var target_position = BUS_STOPS[current_target_index]
	var to_target = target_position - global_transform.origin
	to_target.y = 0
	var distance = to_target.length()

	# Get the forward direction of the bus (negative Z)
	var forward = global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var target_dir = to_target.normalized()

	# Calculate steering angle
	var angle_to_target = forward.signed_angle_to(target_dir, Vector3.UP)
	steering = clamp(angle_to_target * 2.0, -MAX_STEER, MAX_STEER) # Adjust multiplier for sensitivity

	# Apply engine force (always moving forward)
	engine_force = ENGINE_POWER

	# Switch to the next waypoint when close enough
	if distance < ARRIVAL_DISTANCE:
		current_target_index = (current_target_index + 1) % BUS_STOPS.size()
