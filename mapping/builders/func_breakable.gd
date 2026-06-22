extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	return create_brush_entity(entity, "Node3D", "RigidBody3D")
