extends Node

var dialogue_data: Dictionary = {}

func _ready():
	var file: FileAccess = FileAccess.open("res://assets/dialogues/dialogues.csv", FileAccess.READ)

	if file:
		var headers: PackedStringArray = []
		var is_header: bool = true
		while not file.eof_reached():
			var line: String = file.get_line().strip_edges()
			var fields: PackedStringArray = line.split(",")
			if fields.size() == 0:
				continue
			if is_header:
				headers = fields
				is_header = false
			else:
				if fields.size() >= 4:
					var section: String = fields[0]
					var dialogue: String = fields[1]
					if not dialogue_data.has(section):
						dialogue_data[section] = {}
					dialogue_data[section][dialogue] = {headers[2]: fields[2], headers[3]: fields[3]}
				else:
					print("Line does not have enough columns: ", fields)
		file.close()
	print(dialogue_data)

