extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	var node: StaticBody3D = create_merged_brush_entity(entity, "StaticBody3D")
	if not node: return null

	# painting grass where info_grass entities are
	build_grass_multimesh(map, entity, node)

	# creating ambient audio player under the node
	var ambient_ost_player := AudioStreamPlayer.new()
	ambient_ost_player.stream = map.loader.load_sound("sounds/ambience1")
	node.add_child(ambient_ost_player, true)
	ambient_ost_player.autoplay = true

	# creating world environment (sky and fog)
	var world_environment := WorldEnvironment.new()
	world_environment.environment = map.loader.load_resource(
		"resources/environments/above_clouds.tres")
	node.add_child(world_environment, true)

	return node


static func build_grass_multimesh(map: MapperMap, entity: MapperEntity, parent: Node) -> void:
	var multimesh := map.loader.load_resource("resources/multimeshes/grass1")
	var transform_array := entity.generate_surface_distribution(
		["prototype/*"], 1.0, 0.0, 60.0, false, false,
		map.settings.options.get("grass_seed", 0))

	spread_transform_array(transform_array, 0.25)
	scale_transform_array(transform_array,
		Vector3(0.5, 0.5, 0.5), Vector3(0.75, 1.0, 0.75))
	rotate_transform_array(transform_array, Vector3(-1.0, 0.0, -1.0))

	var painted_transform_array: PackedVector3Array = []
	for map_entity in map.classnames.get("info_grass", []):
		var position = map_entity.get_origin_property(null)
		if position == null: continue

		var local_position := Vector3(position) - entity.center
		var radius = map_entity.get_unit_property("radius", 300.0)
		var hardness = map_entity.get_float_property("hardness", 1.0)
		painted_transform_array.append_array(erase_transform_array(
			transform_array, local_position, radius, hardness))

	create_multimesh_instance(entity, parent, multimesh, painted_transform_array)
