extends Control

export var skill_option : NodePath
export var skill_name : NodePath
export var skill_advance : NodePath
export var skill_total : NodePath

var sheet = load("res://Cenas/Sheets/Empty.tscn").instance()
var characteristics = sheet.characteristics_node
func _ready():
	for n in get_tree().get_nodes_in_group("CharacteristicsBasic"):
		get_node(skill_option).add_item(n.get_node("../").name)

# The current problem
func _on_OptionButton_item_selected(index):
	
	print(sheet.get_node(characteristics).get_node(
		"../../../HBoxContainer/Title").text) 
