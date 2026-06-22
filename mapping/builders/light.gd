extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	var node := OmniLight3D.new()
	node.omni_range = entity.get_unit_property("light", 300)
	node.light_energy = entity.get_unit_property("light", 300)
	return node
