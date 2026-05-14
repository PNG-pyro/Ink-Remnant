extends RichTextLabel
func _ready() -> void:
	%TooltipLabel.bbcode_enabled = true
	%TooltipLabel.fit_content = true
	%TooltipLabel.autowrap_mode = TextServer.AUTOWRAP_OFF
