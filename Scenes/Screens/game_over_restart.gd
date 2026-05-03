extends Node2D

var main = preload("res://main.tscn")

func restart():
    get_tree().change_scene_to_file("res://main.tscn")
