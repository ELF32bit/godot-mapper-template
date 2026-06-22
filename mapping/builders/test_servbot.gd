extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	var pivot_offset := Vector3.DOWN * entity.aabb.size.y * 0.5
	entity.node_properties["position"] = entity.center + pivot_offset
	entity.node_properties["script"] = map.loader.load_script("scripts/test_servbot")
	var servbot: PackedScene = load("res://characters/maps/servbot.map")
	var servbot_instance := servbot.instantiate()
	return servbot_instance
