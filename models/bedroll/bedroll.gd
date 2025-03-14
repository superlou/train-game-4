extends RelativeBody


@export var deployed := true


func _ready() -> void:
    if not deployed:
        $AnimationPlayer.play("Roll-Up")
        $AnimationPlayer.seek(2)