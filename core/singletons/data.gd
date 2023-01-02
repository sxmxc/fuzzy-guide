# ----------------------------------------
# data.gd
# ----------------------------------------
# Stores all data and config presets.
extends Node
const MODULE_NAME = "GlobalData"

# Types ----------------------------------
enum UNIT_TYPE { PAWN, ROOK, BISHOP, KNIGHT, KING, QUEEN}
enum CARD_TYPE { UNIT, SPELL, TRAP}

# Scene Configs --------------------------
const SPLASH_SCENE_PATH : String = "res://core/ui/splash/splash.tscn"
const MAIN_SCENE_PATH : String = "res://main_menu/MainMenu.tscn"
const TRANSITION_IMAGE_PATH : String = "res://core/ui/transitions/transition_image.tscn"

# Resource & Packages --------------------
var LOADER_WAIT_TIME : float = 0.5
var PACKAGE_ROOT : String = OS.get_executable_path().get_base_dir()
var PACKAGE_PATHS : Array = [ 
	PACKAGE_ROOT.path_join("contents"),
	PACKAGE_ROOT.path_join("patches"),
]
var SPRITE_DICT := {}

# Game Settings ---------------------------
const DEBUG := true

const PLAYER_MAX_HAND := 7

const PATH_PLAYER_SAVE := "res://player/data/player_data.res"
const PATH_CARD_DB := "res://cards/data/"
const PATH_PLAYER_DECKS := "res://player/data/decks/"

const PATH_ANIMATION_DICT = {
	"idle" : "idle", 
	"jump" : "jump", 
	"run" : "run",
	"walk" : "walk"
}
const PATH_CHARACTER_SPRITES := "res://assets/SmallBurg_village_pack/assets/character/"
const PATH_CHARACTER_BODIES := "res://assets/SmallBurg_village_pack/assets/character/adult/body/"
const PATH_CHARACTER_CLOTHING := "res://assets/SmallBurg_village_pack/assets/character/adult/clothing/"
const PATH_CHARACTER_HAIRS := "res://assets/SmallBurg_village_pack/assets/character/adult/hairs/"

const MOTD_LIST := [
	"Thank you for trying the new [b]WizardChess[/b]",
	"Now with extra [b]MSG[/b]!",
	"Clothes make the man. Naked people have little or no influence in society.\n[b]- Mark Twain[/b]",
	"I’m not superstitious, but I am a little stitious.\n[b]- Michael Scott[/b]",
	]

const LOAD_SCREEN_IMAGES := [
	preload("res://core/images/transitions/10beaf07-4453-4706-bcc0-1cf6bc6d6e01.jpg"),
	preload("res://core/images/transitions/000175.1097673250.gfpgan.png"),
	preload("res://core/images/transitions/000174.775517731.png"),
	preload("res://core/images/transitions/000175.1097673250.gfpgan.png"),
	preload("res://core/images/transitions/000176.556678169.png"),
	preload("res://core/images/transitions/000178.1819809780.png"),
	preload("res://core/images/transitions/000191.1756847785.png"),
	preload("res://core/images/transitions/000193.2045306087.png"),
	preload("res://core/images/transitions/000210.1871755508.png"),
	preload("res://core/images/transitions/000212.1092408422.png"),
	preload("res://core/images/transitions/000221.1729325855.png"),
	preload("res://core/images/transitions/000254.1949674504.png"),
	preload("res://core/images/transitions/000254.1949674504.png")
	]

const LOAD_SCREEN_HINTS := []
	

const CARD_TEMPLATE := preload("res://cards/card.tscn")

# SpriteManager -------------------------
# Load sprites from filesystem
func load_sprites():
	for anim in PATH_ANIMATION_DICT:
		var cnt = 1
		var regx = RegEx.new()
		#Regex to filter out non png's and godot imports
		regx.compile("("+ anim +"_)+(?!shadow)\\w*\\.+(png)$(?!import)")
		for file in Utils.get_files_recursive(PATH_CHARACTER_BODIES + anim, regx):
			if !Data.SPRITE_DICT.has("Body" + str(cnt)):
				Data.SPRITE_DICT["Body" + str(cnt)] = {}
			Data.SPRITE_DICT["Body" + str(cnt)]["type"] = "body"
			if !Data.SPRITE_DICT["Body" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Body" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Body" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		cnt = 1
		for file in Utils.get_files_recursive(PATH_CHARACTER_HAIRS + anim, regx):
			if !Data.SPRITE_DICT.has("Hair" + str(cnt)):
				Data.SPRITE_DICT["Hair" + str(cnt)] = {}
			Data.SPRITE_DICT["Hair" + str(cnt)]["type"] = "hair"
			if !Data.SPRITE_DICT["Hair" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Hair" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Hair" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		cnt = 1
		for file in Utils.get_files_recursive(PATH_CHARACTER_CLOTHING + anim + "/top", regx):
			if !Data.SPRITE_DICT.has("Top" + str(cnt)):
				Data.SPRITE_DICT["Top" + str(cnt)] = {}
			Data.SPRITE_DICT["Top" + str(cnt)]["type"] = "top"
			if !Data.SPRITE_DICT["Top" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Top" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Top" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		cnt = 1
		for file in Utils.get_files_recursive(PATH_CHARACTER_CLOTHING + anim + "/bottom", regx):
			if !Data.SPRITE_DICT.has("Bottom" + str(cnt)):
				Data.SPRITE_DICT["Bottom" + str(cnt)] = {}
			Data.SPRITE_DICT["Bottom" + str(cnt)]["type"] = "bottom"
			if !Data.SPRITE_DICT["Bottom" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Bottom" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Bottom" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		cnt = 1
		for file in Utils.get_files_recursive(PATH_CHARACTER_CLOTHING + anim + "/shoes",regx):
			if !Data.SPRITE_DICT.has("Shoes" + str(cnt)):
				Data.SPRITE_DICT["Shoes" + str(cnt)] = {}
			Data.SPRITE_DICT["Shoes" + str(cnt)]["type"] = "shoes"
			if !Data.SPRITE_DICT["Shoes" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Shoes" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Shoes" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		cnt = 1
		for file in Utils.get_files_recursive(PATH_CHARACTER_CLOTHING + anim + "/acessories", regx):
			if !Data.SPRITE_DICT.has("Accessory" + str(cnt)):
				Data.SPRITE_DICT["Accessory" + str(cnt)] = {}
			Data.SPRITE_DICT["Accessory" + str(cnt)]["type"] = "accessory"
			if !Data.SPRITE_DICT["Accessory" + str(cnt)].has("animations"):
				Data.SPRITE_DICT["Accessory" + str(cnt)]["animations"] = {} 
			Data.SPRITE_DICT["Accessory" + str(cnt)]["animations"][anim] = load(file)
			cnt += 1
		#None sprite for no accessory
		if !Data.SPRITE_DICT.has("None"):
			Data.SPRITE_DICT["None"] = {}
			Data.SPRITE_DICT["None"]["animations"] = {}
			Data.SPRITE_DICT["None"]["type"] = "accessory"
		Data.SPRITE_DICT["None"]["animations"][anim] = null
	pass

func get_sprites_by_type(s_type : String) -> Array:
	var sprites := []
	for item in SPRITE_DICT:
		if SPRITE_DICT[item]["type"] == s_type:
			sprites.append(item)
	return sprites

