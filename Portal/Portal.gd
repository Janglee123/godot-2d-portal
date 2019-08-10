extends Node2D

onready var link = {
	$PortalA : $PortalB,
	$PortalB : $PortalA
}

onready var portals = [$PortalA, $PortalB];

var clone : KinematicBody2D;
var body : KinematicBody2D;
var from : Area2D;
var to : Area2D;
var is_porting : bool;

func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if not is_porting :
		for portal in portals:
			var overlapping_bodies = portal.get_overlapping_bodies();
			
			if overlapping_bodies.size() <= 0:
				continue;
			
			var overlapping_body = overlapping_bodies[0];
			
			if overlapping_body :
				body = overlapping_body as KinematicBody2D;
				from = portal as Area2D;
				to = link[from] as Area2D;
				is_porting = true;
			break;
	
	if is_porting:
		do_porting();
		
		if from.get_overlapping_bodies().size() == 0:
			handle_body_exit();
		
	pass


func do_porting():
	var body_pos = body.global_transform
	var from_pos = from.global_transform
	var to_pos = to.global_transform
		
	var rel_pos = from_pos.inverse()*body_pos
		
	if not clone:
		clone = body.duplicate(0)
		body.get_parent().add_child(clone)
		
	clone.global_transform = to_pos * rel_pos

func handle_body_exit():
	if not clone :
		return
	
	body.global_transform = clone.global_transform;
	
	clone.queue_free()
	
	clone = null;
	body = null;
	to = null;
	from = null;
	is_porting = false;
