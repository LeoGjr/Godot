extends Node2D

onready var felpudo = get_node("Felpudo")
onready var timereplay = get_node("TimeToReplay")
onready var label = get_node("Node2D/Control/Label")

var pontos = 0
var estado = 1

const JOGANDO = 1
const PERDENDO = 2

var high = 0

var save_files = File.new()
var save_path = "user://savegame.save"
var save_data = {"highscore": 0}

func _ready():
	if not save_files.file_exists(save_path):
		create_save()
	else:
		read()
		get_node("Node2D/Control/High").set_text(str(high))	
	
func create_save():
	save_files.open(save_path, File.WRITE)
	save_files.store_var(save_data)
	save_files.close()

func save():
	save_data["highscore"] = high
	save_files.open(save_path, File.WRITE)
	save_files.store_var(save_data)
	save_files.close()
	
func read():
	save_files.open(save_path, File.READ)
	save_data = save_files.get_var()
	save_files.close()
	high = save_data["highscore"]	

func kill():
	felpudo.apply_impulse(Vector2(0,0), Vector2(-1000,0))
	get_node("BackAnim").stop()
	estado = PERDENDO
	timereplay.start()
	get_node("SomHit").play()
	save()
	
func pontuar():
	pontos += 1	
	if pontos > high:
		high = pontos
		get_node("Node2D/Control/High").set_text(str(high))	
	label.set_text(str(pontos))
	get_node("SomScore").play()

func _on_TimeToReplay_timeout():
	get_tree().reload_current_scene()
