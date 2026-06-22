extends Control


func update_coins_collected() -> void:
	$CoinsCounter.text = str(Singleton.coins_collected)
