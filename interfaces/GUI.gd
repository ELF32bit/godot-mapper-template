extends Control


func update_coins_collected() -> void:
	$CoinsCounter.text = str(GameState.coins_collected)
