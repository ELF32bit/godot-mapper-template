extends Node

var coins_collected: int = 0:
	set(value):
		coins_collected = value
		GUI.update_coins_collected()
