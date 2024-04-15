extends CanvasLayer

var time_since_last_shot = 0.0
var fire_rate = 1.0
var can_shoot = true

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
	$AnimatedSprite2D.play(Global.current_weapon + "_idle")

func _process(delta):
	time_since_last_shot += delta
	var can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	
# changes weapon to knife if out of bullets
	if Global.current_weapon != "knife" and Global.ammo <= 0:
		Global.current_weapon = "knife"
		$AnimatedSprite2D.play("knife_idle")
	
	if Input.is_action_pressed("ui_select") and can_shoot:
		
		if Global.current_weapon == "knife":
			$AnimatedSprite2D.play("stab")
		else:
			$AnimatedSprite2D.play(Global.current_weapon + "_shoot")
 
		time_since_last_shot = 0.0
		
		if Global.current_weapon != "knife":
			if Global.ammo > 0:
				Global.ammo -= 1
				
				
	match Global.current_weapon:
		"gun":
			fire_rate = 3.0
		"machine":
			fire_rate = 10.0
		"knife":
			fire_rate = 2.0
		_:
			fire_rate = 1.0

			
func _on_AnimatedSprite2D_animation_finished():
	$AnimatedSprite2D.play(Global.current_weapon + "_idle")
	


