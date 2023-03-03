extends Control

onready var next_button := $NextButton
onready var prev_button := $PrevButton
onready var page_1 := $"Tutorial-1"
onready var page_2 := $"Tutorial-2"
onready var page_3 := $"Tutorial-3"
onready var dismiss_button := $DismissButton
onready var defend_button := $"Tutorial-2/DefendButton"
onready var defense_hint_label := $"Tutorial-2/DefenseHintLabel"
onready var tutorial_timer := $TutorialTimer

var current_page = 0
var pages = []

func _ready():
	next_button.connect("pressed", self, "on_next_press")
	prev_button.connect("pressed", self, "on_prev_press")
	dismiss_button.connect("pressed", self, "on_dismiss_press")
	tutorial_timer.connect("timeout", self, "start_activation")
	pages = [page_1, page_2, page_3]
	defend_button.connect("pressed", self, "on_defend_press")

func refresh():
	prev_button.disabled = current_page == 0
	next_button.disabled = current_page == pages.size() - 1
	for i in pages.size():
		pages[i].visible = current_page == i
	if pages[1].visible:
		defense_hint_label.text = "Try it out!"
		tutorial_timer.start(3)

func on_defend_press():
	# hack to process button press first
	yield(get_tree().create_timer(0.1), "timeout")
	if defend_button.is_idle():
		defense_hint_label.text = "Wait for it to load..."
	else:
		if defend_button.is_success_activation:
			defense_hint_label.text = "Successful block!"
		else:
			defense_hint_label.text = "Too late!"

func on_next_press():
	if current_page < pages.size() - 1:
		current_page += 1
		refresh()
		
func on_prev_press():
	if current_page > 0:
		current_page -= 1
		refresh()

func on_dismiss_press():
	get_tree().paused = false	
	call_deferred("queue_free")

func start_activation():
	defend_button.start_activation_animation()
