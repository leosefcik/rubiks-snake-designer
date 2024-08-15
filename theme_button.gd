extends Button

signal themeButtonSelected(this_theme)
var this_theme: String

func _on_ThemeButton_pressed():
	emit_signal("themeButtonSelected", this_theme)
