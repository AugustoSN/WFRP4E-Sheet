extends Control


export var sheet_node: NodePath 

export var empty_sheet : PackedScene

#Variables for dice rolling
var result 
var target
var sl

var sheet_size = 0

func _ready():

	load_sheet()

	get_node(sheet_node).connect("item_selected", self, "_on_ItemList_item_selected" )

func load_sheet():
	for load_sheet in Global.creatures.size():
		get_node(sheet_node).add_item(str(Global.creatures[load_sheet].Name))
		sheet_size += 1


func _on_ItemList_item_selected(index):
# Call sheet

	var sheet = get_node(sheet_node).get_item_text(index)
	var a = preload("res://Cenas/Sheets/Empty.tscn")
	var i = a.instance()
	i.creature_name = index
	self.add_child(i)

	for button in get_tree().get_nodes_in_group("Dices_Skills") :
		button.connect("pressed", self, "Roll_Dices", [button.get_node(
			"../Total"),button.get_node("../")])

#Dice rolling
func Roll_Dices(t,n):
	if $PanelContainer/Rolls/HBoxContainer/Roll.disabled == true:
		sheet_size += 4
		target = t.text
		simple_test()


		get_node(sheet_node).add_item(str(n.get_node("../../SheetName").text))
		get_node(sheet_node).add_item(str(n.name))
		get_node(sheet_node).add_item(str("Target : " + str(target)))
		get_node(sheet_node).add_item("Dice : " + str(result) )
		success_level()
		get_node(sheet_node).add_item("SL : " + str(sl))
		

#Success Levels(SL) are macanics from the rpg
func success_level():
	var resultstr = str(result)
	var resultlng = resultstr.length()
	var tens_dice = int(resultstr[resultlng-2])
	
	var targetstr = str(target)
	var targetlng = targetstr.length()
	
	var tens_target = int(targetstr[targetlng-2])
	if targetlng == 3:
		tens_target = int(str(str(int(targetstr[targetlng-3])) + 
			str(int(targetstr[targetlng-2])))) 
	sl = tens_target - tens_dice

# More tipes of test will be needed. Extended Test (save the SL and add to the next text), Dramatic Tests (SL need to be a specific number or above),etc. 
func simple_test():
	roll_d100()

func roll_d100():
	randomize()
	var dice = rand_range(1,100)
	result = int(dice)




#'Change' the tab for sheet list to the rolling thest
func _on_Roll_pressed():
	$PanelContainer/Rolls/HBoxContainer/Sheet.disabled = false
	$PanelContainer/Rolls/HBoxContainer/Roll.disabled = true
	get_node(sheet_node).disconnect("item_selected", self, "_on_ItemList_item_selected")

	for item in sheet_size :
		get_node(sheet_node).remove_item(0)
		
	

	sheet_size = 0


#'Change' the tab for rolling to sheet list
func _on_Sheet_button_up():
	$PanelContainer/Rolls/HBoxContainer/Sheet.disabled = true
	$PanelContainer/Rolls/HBoxContainer/Roll.disabled = false
	get_node(sheet_node).connect("item_selected", self, "_on_ItemList_item_selected" )

	for item in sheet_size :
		get_node(sheet_node).remove_item(0)
		

	sheet_size = 0
	
	load_sheet()

