extends RichTextLabel

func _ready():
	$TimeToDisplay.connect("timeout", self, "fade_text_out")
	$FadeIn.connect("tween_completed", self, "fade_text_in")
	
	$FadeIn.interpolate_property(self, "percent_visible", 0, 1, 1)
	$FadeIn.start()

func fade_text_in(_obj, _key):
	print_debug("Faded in")
	$TimeToDisplay.start()

func fade_text_out():
	$FadeOut.interpolate_property(self, "percent_visible", 1, 0, 2)
	$FadeOut.start()
	
	print_debug("DONE")
	$TimeToDisplay.stop()
