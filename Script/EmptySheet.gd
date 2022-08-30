extends Control

export var window: NodePath 
export var name_sheet: NodePath 
export var title_sheet: NodePath 
export var characteristics_node: NodePath 
export var sheet_node : NodePath

#Characteristics

var ws_modifier = 0
var bs_modifier = 0
var s_modifier = 0
var t_modifier = 0
var i_modifier = 0
var ag_modifier = 0
var dex_modifier = 0
var int_modifier = 0
var wp_modifier = 0
var fell_modifier = 0

var ws_advance  = 0
var bs_advance  = 0
var s_advance  = 0
var t_advance  = 0
var i_advance  = 0
var ag_advance = 0
var dex_advance = 0
var int_advance = 0
var wp_advance = 0
var fell_advance = 0

var creature_name

#Bonus Characteristics
var regex = RegEx.new()

#Resize window
export onready var resize_area = $ResizeArea
export onready var color_rect = $ColorRect
var resize_area_vec2 := Vector2(8,8)
var minimized = false
var save_rect_x 
var save_rect_y 

var teste 

func _ready():
#Change Name
	var sheet_number = $".".name
	get_node(".").add_to_group(sheet_number)
	get_node(name_sheet).text = Global.creatures[creature_name].Name
	get_node(title_sheet).text = Global.creatures[creature_name].Name
	teste = get_node(title_sheet).text 
#updade basic Characteristics
# Is weird like this because otherwise it will update all the open sheets
	for total in get_node(characteristics_node).get_child_count():
		get_node(characteristics_node).get_child(
			total).get_child(1).text = str(Global.creatures[
			creature_name].get(
			get_node(characteristics_node).get_child(
			total).get_child(0).text.to_lower() +
			"_basic_value")) 

	update_characteristics()
#Connect Basic Text
	for basic in get_tree().get_nodes_in_group("CharacteristicsBasic"):
		basic.connect("text_changed",self,"Change_Characteristics",[basic.get_node('../BasicValue')] )
		#get_node(skill_option).add_item(basic.get_node("../").name)

#resie Window Dialog
	resize_area.rect_min_size = resize_area_vec2

	resize_area.rect_position = $".".rect_size - (resize_area.rect_min_size / 2)

	color_rect.rect_min_size = resize_area.rect_min_size
	color_rect.rect_position = resize_area.rect_position
	resize_area.connect('gui_input', self, 'mouse_drag_management')


func Change_Characteristics(new_text, t):
#Ban characters when editing Characteristics. Cant' ban "[]" for some reason but i don't mind that
	regex.compile("[{}:qwertyuiop´`asdfghjklçzxcvbnm<>,.:/?/*-+.!@#$%¨&*_=()]")
	var result = regex.search(new_text)
	var cached_caret_pos = t.caret_position
	if result:
		t.text = regex.sub(t.text, "", true)
		t.caret_position = cached_caret_pos - 1

	update_characteristics()


func update_characteristics():
	for total in get_tree().get_nodes_in_group("CharacteristicsTotal"):

		total.get_node('../Advance').text = str(get(
			total.get_node("../Button").text.to_lower() + "_advance"))

		total.get_node('../Modifiers').text = str(get(
			total.get_node("../Button").text.to_lower() + "_modifier"))

		total.text = str(int(total.get_node('../Advance').text) + 
		int(total.get_node('../Modifiers').text) +
		int(total.get_node('../BasicValue').text))

		var totalstr = total.text
		var totallng = totalstr.length()
		var tens_total = int(totalstr[totallng-2])
		if totallng == 3:
			tens_total = int(str(str(int(totalstr[totallng-3])) + 
				str(int(totalstr[totallng-2])))) 
			
		total.get_node('../Bonus').text = str(tens_total)
#Skills. 
#I was making the skills in the same scene before decidint to make it in to another. 
#Both condes do the same thing and the last time i tested _on_OptionButton_item_selected(index) was working just fine. 
#Don't know if it will work since the node is now in another scene
# This conde still here just for me to see it what i've done previously. When i fix the SKill issue it will be deleted
#func _on_OptionButton_item_selected(index):
#	print(get_node(characteristics_node).get_node(str(get_node(
#		skill_option).get_item_text(index)) +"/Total").text) 
#	
#func update_skills():
#	var item_id = 10
#	var remenber_skill
#	for total in get_tree().get_nodes_in_group("CharacteristicsTotal"):
#		if total.get_node("../").name == get_node(skill_option).get_item_text(item_id):
#			var char_total = int(get_node("../Total").text)
#			var skill = int(get_node(skill_advance).text)
#			get_node(skill_total).text = str(int(char_total + int(skill)))
#			item_id -= 1
#			pass

#Close the sheet 
func _on_Exit_pressed():
	$".".queue_free()

#Change the original name
func _on_SheetName_text_changed(new_text):
	get_node(title_sheet).text = new_text

#"Minimize" sheet
func _on_Minimize_pressed():
	if minimized == false:
		save_rect_x = $".".rect_size.x
		save_rect_y = $".".rect_size.y
		$".".rect_size = Vector2(int(get_node(title_sheet).rect_size.x + 100),40)
		get_node(sheet_node).hide()
		resize_area.hide()
		minimized = true
	elif minimized == true:
		$".".rect_size = Vector2(save_rect_x, save_rect_y)
		resize_area.show()
		get_node(sheet_node).show()
		minimized = false
	resize_area.rect_position = $".".rect_size - (resize_area.rect_min_size / 2)
	color_rect.rect_position = resize_area.rect_position

# Drag the sheet on the screen.
# The Painel Node was substituite with a Control Node  
func _on_Panel_gui_input(event):
	if event is InputEventScreenDrag:
		rect_position += event.relative

#Resize the sheet
func mouse_drag_management(event):
	if event is InputEventScreenDrag:
		$".".rect_size = get_global_mouse_position()
		resize_area.rect_position = $".".rect_size - resize_area.rect_min_size / 2
		
#		DEBUG
		color_rect.rect_position = resize_area.rect_position

# Call skill
func _on_Button_pressed():
	var a = preload("res://Cenas/Sheets/Skill.tscn")
	var i = a.instance()
	$WindowDialog/ScrollContainer/VBoxContainer/Skills/Basic.add_child(i)
