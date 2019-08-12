extends Node2D

onready var link = {
	$PortalA : $PortalB,
	$PortalB : $PortalA
}

onready var portals = [$PortalA, $PortalB];
onready var allowded_group = 'player';

var clone : KinematicBody2D;
var body : KinematicBody2D;
var from : Area2D;
var to : Area2D;
var is_porting : bool;
var enter_side;
var a = Vector2.ZERO;
var b = Vector2.ZERO;
var c = Vector2.ZERO;

func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if not is_porting :
		for portal in portals:
			var overlapping_bodies = portal.get_overlapping_bodies();
			
			if overlapping_bodies.size() <= 0:
				continue;
			
			var overlapping_body = overlapping_bodies[0];
			
			if overlapping_body and overlapping_body.get_groups().find(allowded_group) != -1 :
				body = overlapping_body as KinematicBody2D;
				from = portal as Area2D;
				to = link[from] as Area2D;
				is_porting = true;
				enter_side = get_front_side(from, overlapping_body);
				prints(body, from, to, is_porting, enter_side);
				break;
	
	if is_porting:
		do_porting();
		
		if from.get_overlapping_bodies().find(body) == -1:
			handle_body_exit();
	
	update();
	pass

func do_porting():
	var body_pos = body.global_transform
	var from_pos = from.global_transform
	var to_pos = to.global_transform
		
	var rel_pos = from_pos.inverse()*body_pos
		
	if not clone:
		clone = body.duplicate(15)
		body.get_parent().add_child(clone)
		
	clone.global_transform = to_pos * rel_pos

func handle_body_exit():
	if not clone :
		return
	
	if enter_side != get_front_side(from, body) :
		swap_body_clone(body, clone);
	
	clone.queue_free()
	
	clone = null;
	body = null;
	to = null;
	from = null;
	is_porting = false;

func swap_body_clone(body, clone):
	var body_pos = body.global_transform;
	var clone_pos = clone.global_transform;
	body.global_transform = clone_pos;
	clone.global_transform = body_pos;

func get_front_side(portal, body):
	var segment = portal.get_child(1).shape ;
	
	a = portal.global_position + segment.a.rotated(portal.global_rotation);
	b = portal.global_position + segment.b.rotated(portal.global_rotation);
	c = body.global_position;
	
	var body_enter_side = sign((a-b).cross(a-c));
	
	return body_enter_side
	pass
