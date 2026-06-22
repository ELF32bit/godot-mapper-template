extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap) -> void:
	var lightmap_gi := create_lightmap_gi(map, map.node)
	var paths := preload("path_corner.gd").post_build(map)
	preload("test_origami.gd").post_build_node_paths(map, paths)
