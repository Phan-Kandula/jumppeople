extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$TextureRect.hide()
	$Controls.hide()
	$ZombieWin.hide()
	$HumanWin.hide()
	$Start2.hide()
	pass

func start():
	$Player_zombie._ready()
	$player_human._ready()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	$MainMenu.hide()
	start()
	
	
func end_game():
	$TextureRect.show()
	$Player_zombie/zombie.is_done()
	$player_human/human.is_done()
	
	if get_node("Player_zombie/zombie").get_health() == 0:
		$ZombieWin.show()
	else:
		$HumanWin.show() 

func _on_Controls_pressed():
	$MainMenu.hide()
	$Controls.show()
	$Start2.show()


func _on_HowToPlay_pressed():
	pass # replace with function body


func _on_Start2_pressed():
	$MainMenu.hide()
	$Controls.hide()
	$Start2.hide()
	start()
	pass # replace with function body
