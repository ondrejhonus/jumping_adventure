extends RichTextLabel

var dialog = [
	"Welcome to my game Jumping Adventure.",
	"The game begins with a view of a dark, mysterious forest. The camera zooms in on a boy sitting under a tree, trembling with fear. The wind whispers through the branches, and an owl hoots in the distance.",
	"Boy (fearfully):\n\"Where... where am I? This wasn’t the way home... Why did I even take that shortcut? I should have listened to Mom.\"",
	"(He looks around, searching for any clue or path.)",
	"Boy (hopefully):\n\"I have to do something. There’s got to be a way out of here. I can’t give up—I have to get back home to Mom and Dad!\"",
	"(Suddenly, there’s a rustling sound, and a glowing object appears between the trees. The boy gets up and moves closer.)",
	"Boy (confused):\n\"What’s this? An energy drink? Here, in the middle of the forest? That doesn’t make any sense...\"",
	"(At that moment, a mysterious voice echoes, sounding as if it comes from everywhere at once.)",
	"Mysterious Voice:\n\"Young one, you are lost, but hope is not gone. Within this forest lies a power. Collect enough of these energy drinks, and the path home will reveal itself to you. But beware... this forest is full of dangers and secrets. Every step you take will bring you closer to the truth—or deeper into the darkness.\"",
	"Boy (determined):\n\"I have to try. I don’t have a choice. I’ll find all the drinks and make it home, no matter what it takes!\"",
	"(The boy picks up the first can, and as he does, the surroundings light up briefly. On the screen, the text appears: \"Collect all the energy drinks to unlock the way home.\")",
	"(The game begins. The boy sets out into the forest, filled with hidden paths, tricky obstacles, and unexpected surprises.)"
]

var page = 0
var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)
	text = ""  # Clear text to start fresh
	visible_characters = 0
	
	# Add a Timer node dynamically if not already in the scene
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.wait_time = 0.05  # Adjust the speed of character reveal
	timer.start()
	
	show_page()  # Show the first page

# Function to handle showing a new page
func show_page() -> void:
	text = dialog[page]
	visible_characters = 0
	timer.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if visible_characters >= get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				show_page()
			else:
				print("End of dialog.")
		else:
			# Skip to show the full text instantly
			visible_characters = get_total_character_count()

func _on_timer_timeout() -> void:
	if visible_characters < get_total_character_count():
		visible_characters += 1
	else:
		timer.stop()  # Stop the timer when all characters are visible
