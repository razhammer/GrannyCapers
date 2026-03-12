
class_name PickupScores


var coins_total: int = 0
var jewels_total: int = 0

var coins_count: int = 0
var jewels_count: int = 0



func all_jewels_collected() -> bool:
	return jewels_count == jewels_total


func _to_string() -> String:
	return "PickupScores: Coins %d/%d, Jewels %d/%d" % [
		coins_count, coins_total, jewels_count, jewels_total
		]
