extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 6
const SENSITIVITY = 0.004

const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = 15

signal charge_updated(charge_value)
signal holding_object(is_holding)

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interaction = $Head/Camera3D/interaction
@onready var hand = $Head/Camera3D/hand

var picked_object: RigidBody3D
var pull_power = 4.0
var charge = 0.0

var trajectory_mesh_instance: MeshInstance3D
var trajectory_immediate_mesh: ImmediateMesh
var trajectory_material: StandardMaterial3D

@onready var trajectory_end_sphere: MeshInstance3D = null

const TRAJECTORY_POINTS = 500
const THROW_VELOCITY_MULTIPLIER = 2.6
const TRAJECTORY_VISUAL_BOOST = 1.2
const TRAJECTORY_SPHERE_RADIUS = 0.15

const LINE_THICKNESS_SIMULATION_COUNT = 3
const LINE_THICKNESS_OFFSET = 0.01

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	global.player = self
	
	trajectory_immediate_mesh = ImmediateMesh.new()
	trajectory_mesh_instance = MeshInstance3D.new()
	trajectory_mesh_instance.mesh = trajectory_immediate_mesh
	
	trajectory_material = StandardMaterial3D.new()
	trajectory_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	trajectory_material.albedo_color = Color(0.0, 1.0, 0.0, 1.0)
	trajectory_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	trajectory_material.vertex_color_use_as_albedo = true
	
	trajectory_mesh_instance.set_surface_override_material(0, trajectory_material)

	hand.add_child(trajectory_mesh_instance)

	trajectory_end_sphere = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = TRAJECTORY_SPHERE_RADIUS
	sphere_mesh.height = TRAJECTORY_SPHERE_RADIUS * 2
	sphere_mesh.radial_segments = 8
	sphere_mesh.rings = 4
	trajectory_end_sphere.mesh = sphere_mesh
	
	var sphere_material = StandardMaterial3D.new()
	sphere_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sphere_material.albedo_color = Color(0.0, 1.0, 0.0, 1.0)
	trajectory_end_sphere.set_surface_override_material(0, sphere_material)
	
	hand.add_child(trajectory_end_sphere)
	trajectory_end_sphere.visible = false

	var particle_quad_mesh = QuadMesh.new()
	particle_quad_mesh.size = Vector2(0.1, 0.1)

	var particle_process_material = ParticleProcessMaterial.new()
	particle_process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	particle_process_material.emission_sphere_radius = TRAJECTORY_SPHERE_RADIUS * 2.0
	particle_process_material.direction = Vector3(0, 0, 0)
	particle_process_material.spread = 180.0
	particle_process_material.initial_velocity_min = 0.5
	particle_process_material.initial_velocity_max = 1.5
	particle_process_material.gravity = Vector3(0, 0, 0)
	particle_process_material.linear_accel_min = 0.0
	particle_process_material.linear_accel_max = 0.0
	
	var color_ramp = Gradient.new()
	color_ramp.add_point(0.0, Color(0.0, 1.0, 0.0, 1.0))
	color_ramp.add_point(0.5, Color(0.0, 1.0, 0.0, 0.8))
	color_ramp.add_point(1.0, Color(0.0, 1.0, 0.0, 0.2))
	particle_process_material.color_ramp = color_ramp

	particle_process_material.angle_min = -360.0
	particle_process_material.angle_max = 360.0
	particle_process_material.angular_velocity_min = 150.0
	particle_process_material.angular_velocity_max = 300.0

	particle_process_material.scale_min = 0.8
	particle_process_material.scale_max = 1.5
	particle_process_material.scale_curve = Curve.new()

	var particle_material = StandardMaterial3D.new()
	particle_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	particle_material.albedo_color = Color(0.0, 1.0, 0.0, 1.0)
	particle_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	particle_quad_mesh.material = particle_material
	process_mode = Node.PROCESS_MODE_PAUSABLE


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta):
	if Input.is_action_just_pressed("grab"):
		if picked_object == null:
			pick_object()
		else:
			remove_object()
			
	if Input.is_action_pressed("right_click"):
		if picked_object != null:
			charge += 0.15 * delta * 60
			charge = min(charge, 10.0)
			charge_updated.emit(charge)
			if charge >= 10.0:
				charge = 10
				
	if Input.is_action_just_released("right_click"):
		if picked_object != null:
			throw()
			
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("spacebar") and is_on_floor():
		jump()
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	if picked_object != null:
		var target_pos = hand.global_transform.origin
		var current_obj_pos = picked_object.global_transform.origin
		picked_object.set_linear_velocity((target_pos - current_obj_pos) * pull_power)
		
		if Input.is_action_pressed("right_click"):
			_draw_trajectory(delta)
		else:
			trajectory_immediate_mesh.clear_surfaces()
			trajectory_end_sphere.visible = false
	else:
		trajectory_immediate_mesh.clear_surfaces()
		trajectory_end_sphere.visible = false
	
			
	if global_position.y < -20:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://scenes/dead_screen.tscn")
		global.dead = true

	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle


func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)
	
func jump():
	velocity.y = JUMP_VELOCITY
	
func player():
	pass


func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		picked_object.angular_velocity = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(1.0, 5.0)
		holding_object.emit(true)


func remove_object():
	if picked_object != null:
		picked_object = null
		holding_object.emit(false)
		trajectory_immediate_mesh.clear_surfaces()
		trajectory_end_sphere.visible = false


func is_holding_object():
	return picked_object != null


func throw():
	if picked_object == null: return
	
	var throw_direction = (picked_object.global_position - global_position).normalized()
	
	picked_object.apply_central_impulse(throw_direction * charge * THROW_VELOCITY_MULTIPLIER)
	
	picked_object.angular_velocity = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(1.0, 5.0)
	
	remove_object()
	charge = 0.0
	charge_updated.emit(charge)


func _draw_trajectory(trajectory_time_step: float):
	if picked_object == null:
		trajectory_immediate_mesh.clear_surfaces()
		trajectory_end_sphere.visible = false
		return

	trajectory_immediate_mesh.clear_surfaces()
	trajectory_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	var start_position = hand.global_transform.origin
	
	var throw_direction = (picked_object.global_position - global_position).normalized()
	var impulse_magnitude = charge * THROW_VELOCITY_MULTIPLIER
	
	var initial_velocity = picked_object.linear_velocity + (throw_direction * impulse_magnitude) / picked_object.mass
	
	initial_velocity *= TRAJECTORY_VISUAL_BOOST

	var current_position = start_position
	var current_velocity = initial_velocity
	
	var linear_damp = picked_object.linear_damp
	
	var space_state = get_world_3d().direct_space_state
	
	trajectory_immediate_mesh.surface_set_color(trajectory_material.albedo_color)

	var last_valid_position = start_position
	
	var camera_forward = -camera.global_transform.basis.z

	for i in range(TRAJECTORY_POINTS):
		var prev_position = current_position
		
		current_velocity *= exp(-linear_damp * trajectory_time_step)
		
		current_velocity.y -= gravity * trajectory_time_step
		
		current_position += current_velocity * trajectory_time_step

		var query = PhysicsRayQueryParameters3D.new()
		query.from = prev_position
		query.to = current_position
		query.exclude = [self.get_rid(), picked_object.get_rid()]
		
		var result = space_state.intersect_ray(query)

		var segment_direction = (current_position - prev_position).normalized()
		var perpendicular_offset_base = camera_forward.cross(segment_direction).normalized()

		for j in range(LINE_THICKNESS_SIMULATION_COUNT):
			var offset_amount = (j - (LINE_THICKNESS_SIMULATION_COUNT - 1) / 2.0) * LINE_THICKNESS_OFFSET
			var current_offset_vector = perpendicular_offset_base * offset_amount

			if result:
				trajectory_immediate_mesh.surface_add_vertex(trajectory_mesh_instance.to_local(prev_position + current_offset_vector))
				trajectory_immediate_mesh.surface_add_vertex(trajectory_mesh_instance.to_local(result.position + current_offset_vector))
			else:
				trajectory_immediate_mesh.surface_add_vertex(trajectory_mesh_instance.to_local(prev_position + current_offset_vector))
				trajectory_immediate_mesh.surface_add_vertex(trajectory_mesh_instance.to_local(current_position + current_offset_vector))

		if result:
			last_valid_position = result.position
			break
		
		last_valid_position = current_position
		
		if current_position.y < -100.0:
			break

	trajectory_immediate_mesh.surface_end()
	
	if trajectory_end_sphere != null:
		trajectory_end_sphere.global_transform.origin = last_valid_position
		trajectory_end_sphere.visible = true


func go_to(x, y, z):
	global_position.x = x
	global_position.y = y
	global_position.z = z
