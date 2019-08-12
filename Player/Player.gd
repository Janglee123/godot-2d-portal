extends KinematicBody2D

enum STATE{ IDLE, WALK, JUMP }

var STATE_NAME = {
	STATE.IDLE: 'IDLE',
	STATE.WALK: 'WALK',
	STATE.JUMP: 'JUMP'
}
var dir = 0;
var jump;
var pdir = 0;

export (int) var  speed  = 250;
export (int) var gravity = 2000;
export (int) var jump_force = 600;
export (int) var y_vel = 0;

onready var is_ported = false;
onready var current_state = STATE.IDLE


func _physics_process(delta):
	
	y_vel += gravity*delta;
	if is_on_floor() :
		y_vel = 5;
	
	pdir = dir;
	dir = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"));
	jump = int(Input.is_action_just_pressed("ui_select"));
	
	if pdir != dir and dir != 0 :
		$Sprite.flip_h = dir < 0;
	
	
	match current_state:
		STATE.IDLE:
			
			if !is_on_floor() :
				change_state(STATE.JUMP);
			
			if dir != 0 :
				change_state(STATE.WALK);
			
			if jump != 0:
				y_vel = -jump_force
				
		STATE.WALK:
			
			if dir == 0:
				change_state(STATE.IDLE);
				
			if !is_on_floor() :
				change_state(STATE.JUMP);
			
			if jump != 0:
				y_vel = -jump_force
		
		STATE.JUMP:
			
			if is_on_ceiling() :
				y_vel = 0;
			
			if is_on_floor() :
				if dir != 0:
					change_state(STATE.WALK);
				else:
					change_state(STATE.IDLE);
				
			pass
	
	move_and_slide(Vector2(speed*dir, y_vel), Vector2(0,-1));
	
	pass

func change_state(state):

	if current_state == state :
		return;
	
	if state == STATE.IDLE :
	
		pass
	elif state == STATE.WALK :
		
		pass
	elif state == STATE.JUMP :
		pass
	
	current_state = state;
	
	pass
