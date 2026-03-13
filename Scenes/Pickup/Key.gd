extends Pickup

const KEY_APPEARS = preload("uid://c4uw42g7gfh7y")
const KEY_COLLECT = preload("uid://ow8brvgh5m5u")

func _ready() -> void:
	_disable()
	SignalHub.on_jewels_collected.connect(_enable)


func _enable():
	set_deferred("monitoring", true)
	show()
	GrannyUtils.play_clip(effects, KEY_APPEARS)


func kill():
	effects.stream = KEY_COLLECT
	super()
