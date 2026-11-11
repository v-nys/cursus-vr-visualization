class_name CourseMagazine
extends Node

@export_range(0, 30) var rounds: int = 3

func take_round() -> bool:
    if rounds <= 0:
        return false
    rounds -= 1
    return true
