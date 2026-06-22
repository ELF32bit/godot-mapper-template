extends MapperUtilities

@warning_ignore("unused_parameter")
static func build(map: MapperMap, entity: MapperEntity) -> Node:
	entity.node_groups.append("info_player_start")
	return Marker3D.new()
