extends Node2D

var _db : Dictionary

const MODULE_NAME := "CardDB"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_disk()
	Utils.logger.info("ready", MODULE_NAME)
	pass # Replace with function body.


func get_card_by_id(id: String) -> CardData:
	if _db.has(id):
		return _db[id]
	return null

func get_card_by_name(arg: String) -> CardData:
	for key in _db.keys():
		if _db[key].card_name == arg:
			return _db[key]
	return null

func get_card_id(arg: String) -> String:
	for key in _db.keys():
		if _db[key].card_name == arg:
			return key
	return "not found"

func has_card(id: String) -> bool:
	return _db.has(id)

func insert_into_db(card: CardData) -> bool:
	if !card:
		return false
	if _db.has(card.card_id):
		return false
	_db[card.card_id] = card
	return true

func remove_from_db(id: int):
	if _db.has(id):
		_db.erase(id)


func load_from_disk(path: String = Data.PATH_CARD_DB):
	Utils.logger.info("Loading data from disk", MODULE_NAME)
	#EventBus.buses["LoggerEvents"].emit_signal("log_message","Loading data from disk")
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
				#print("Found directory: " + file_name)
			else:
				#print("Found file: " + file_name)
				var card = load(dir.get_current_dir() + "/" + file_name) as CardData
				var res = insert_into_db(card)
				if res:
					pass
					#print("Added card to DB: " + card.card_name)
				file_name = dir.get_next()
	else:
		Utils.logger.error("An error occurred when trying to access the path.", MODULE_NAME)
