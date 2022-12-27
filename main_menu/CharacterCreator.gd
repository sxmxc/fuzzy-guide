extends Panel

signal back_requested

@export var available_bodies := {}
@export var available_hairs := {}
@export var available_tops := {}
@export var available_bottoms := {}
@export var available_shoes := {}
@export var available_accessories := {}

var animation_path_dict = {
	"idle" : "/idle/", 
	"jump" : "/jump/", 
	"run" : "/run/",
	"walk" : "/walk/"
}

var _current_body := ""
var _current_hair := ""
var _current_top := ""
var _current_bottoms := ""
var _current_shoes := ""
var _current_accessory := ""

var _body_dir : String = Data.PATH_CHARACTER_BODYS + animation_path_dict["idle"]
var _hair_dir : String = Data.PATH_CHARACTER_HAIRS + animation_path_dict["idle"]
var _top_dir : String = Data.PATH_CHARACTER_BODYS + animation_path_dict["idle"]
var _bottoms_dir : String = Data.PATH_CHARACTER_BODYS + animation_path_dict["idle"]
var _shoes_dir : String = Data.PATH_CHARACTER_BODYS + animation_path_dict["idle"]
var _accessory_dir : String = Data.PATH_CHARACTER_BODYS + animation_path_dict["idle"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var cnt = 1
	var regx = RegEx.new()
	regx.compile(".")
	for file in Utils.get_files_recursive(_body_dir,regx):
		available_bodies["Body" + str(cnt)] = file
		cnt += 1
	cnt = 1
	for file in Utils.get_files_recursive(_hair_dir,regx):
		available_hairs["Hair" + str(cnt)] = file
		cnt += 1
	cnt = 1
	for file in Utils.get_files_recursive(_top_dir,regx):
		available_hairs["Top" + str(cnt)] = file
		cnt += 1
	cnt = 1
	for file in Utils.get_files_recursive(_bottoms_dir,regx):
		available_hairs["Bottom" + str(cnt)] = file
		cnt += 1
	cnt = 1
	for file in Utils.get_files_recursive(_shoes_dir,regx):
		available_hairs["Shoes" + str(cnt)] = file
		cnt += 1
	cnt = 1
	for file in Utils.get_files_recursive(_accessory_dir,regx):
		available_hairs["Accessory" + str(cnt)] = file
		cnt += 1

	# _current_body = available_bodies.keys()[0]
	# _current_hair = available_hairs.keys()[0]
	# _current_top = available_tops.keys()[0]
	# _current_bottoms = available_bottoms.keys()[0]
	# _current_shoes = available_shoes.keys()[0]
	# _current_accessory = available_accessories.keys()[0]




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_char_creator_back_button_pressed():
	emit_signal("back_requested")
	pass # Replace with function body.
