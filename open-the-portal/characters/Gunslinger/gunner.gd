extends BasicEntity

var i := 0

@export var gun_ammo_count = 3

func _ready():
	print("hello world")


func _process(delta: float) -> void:
	print_rich("[bgcolor=black]" + str(i), delta)
	i += 1


#func _physics_process(delta: float) -> void:
	#print(velocity, delta)


func change_state():
	print("hello my baby, hello my darling, hello my ragtime gaaaal")
	velocity.y = 50
	velocity.x = 50
