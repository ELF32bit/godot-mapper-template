extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	var pivot_offset := Vector3.DOWN * entity.aabb.size.y * 0.5
	entity.node_properties["position"] = entity.center + pivot_offset
	entity.node_properties["script"] = map.loader.load_script("scripts/test_origami")
	var origami: PackedScene = load("res://characters/maps/origami.map")
	var origami_instance := origami.instantiate()
	return origami_instance


static func post_build_node_paths(map: MapperMap, paths: Dictionary) -> void:
	for entity in map.classnames.get("test_origami", []):
		if not entity.node: continue
		var target := map.get_first_entity_target(
			entity, "target", "targetname", "path_corner")
		if not paths.get(target, []).size() > 0: continue
		var first_path: Dictionary = paths[target][0]

		entity.node.set("_path_to_follow",
			entity.node.get_path_to(first_path["path_node"]))
		entity.node.set("path_follow_progress", first_path["path_length"])
