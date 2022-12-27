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

# Game Settings ---------------------------
const DEBUG := true

const PLAYER_MAX_HAND := 7

const PATH_PLAYER_SAVE := "res://player/data/player_data.res"
const PATH_CARD_DB := "res://cards/data/"
const PATH_PLAYER_DECKS := "res://player/data/decks/"


const PATH_CHARACTER_SPRITES := "res://assets/SmallBurg_village_pack/assets/character/"
const PATH_CHARACTER_BODYS := "res://assets/SmallBurg_village_pack/assets/character/adult/body/"
const PATH_CHARACTER_CLOTHING := "res://assets/SmallBurg_village_pack/assets/character/adult/clothing/"
const PATH_CHARACTER_HAIRS := "res://assets/SmallBurg_village_pack/assets/character/adult/hairs/"

const MOTD_LIST := [
	"[color=green][Message][/color] Thank you for trying the new [b]WizardChess[/b]",
	"[color=green][Message][/color] Now with extra [b]MSG[/b]!",
	"[color=green][Message][/color] Clothes make the man. Naked people have little or no influence in society.\n[b]- Mark Twain[/b]",
	"[color=green][Message][/color] I’m not superstitious, but I am a little stitious.\n[b]- Michael Scott[/b]",
	]
	

const CARD_TEMPLATE := preload("res://cards/card.tscn")
