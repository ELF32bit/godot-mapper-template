extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	var node: Area3D = create_merged_brush_entity(entity, "Area3D")
	if not node: return null

	# setting area script with properties and connecting signals
	node.set_script(map.loader.load_script("scripts/item-rotating"))
	node.set("rotation_speed", entity.get_float_property("rotation_speed", 1.0))
	node.body_entered.connect(Callable(node, "_on_body_entered"), CONNECT_PERSIST)

	# also connecting 'generic' pick up signal that should trigger an event
	entity.bind_signal_property("target", "targetname", "generic", "_on_generic_signal")

	return node
