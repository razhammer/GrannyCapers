@tool
extends EditorScript


func _run() -> void:
	var base_radius: float = 0.4
	var base_height: float = 0.0
	
	var editor_selection: EditorSelection = get_editor_interface().get_selection()
	var selected_nodes: Array[Node] = editor_selection.get_selected_nodes()
	
	for node in selected_nodes:
		if node is MultiMeshInstance3D:
			var mesh: Mesh = node.multimesh.mesh
			var aabb: AABB = mesh.get_aabb()
			
			base_height = aabb.size.y
			
			var multimesh: MultiMesh = node.multimesh
			var instance_count: int = multimesh.instance_count
			
			for i in range(instance_count):
				var instance_transform: Transform3D = multimesh.get_instance_transform(i)
				var full_basis: Basis = instance_transform.basis
				var scale: Vector3 = full_basis.get_scale()
				var rotation: Basis = full_basis.orthonormalized()
				
				var body: StaticBody3D = StaticBody3D.new()
				body.collision_layer = 1 << 0
				body.name = "COLLIDER_%d" % i
				body.transform = Transform3D(rotation, instance_transform.origin)
				body.position.y += base_height * scale.y / 2
				
				var shape: CapsuleShape3D = CapsuleShape3D.new()
				shape.radius = base_radius * scale.x
				shape.height = base_height * scale.y
				
				var collider: CollisionShape3D = CollisionShape3D.new()
				collider.shape = shape
				
				body.add_child(collider)
				node.get_parent().add_child(body)
				
				collider.owner = node.owner
				body.owner = node.owner
