extends Control

@export var optionsBack:AnimationPlayer

func back():
	optionsBack.play("optionsBack")
