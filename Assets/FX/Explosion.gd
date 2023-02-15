extends Node2D

func complete_explosion():
	call_deferred("queue_free")
