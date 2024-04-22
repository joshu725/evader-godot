extends Area2D
signal hit

#Definimos la velocidad y usamos @export para que la propiedad salga en el Inspector del nodo
@export var rapidez = 400
#Variable para el tamaño de la pantalla
var tamaño_pantalla

func _ready():
	#Obtenemos el tamaño de la pantalla
	tamaño_pantalla = get_viewport_rect().size
	hide()

func _process(delta):
	#Modificamos la velocidad del jugador dependiendo lo que se presione
	var velocidad = Vector2.ZERO
	if Input.is_action_pressed("mover_derecha"):
		velocidad.x += 1
	if Input.is_action_pressed("mover_izquierda"):
		velocidad.x -= 1
	if Input.is_action_pressed("mover_abajo"):
		velocidad.y += 1
	if Input.is_action_pressed("mover_arriba"):
		velocidad.y -= 1
	
	#Evitamos que al moverse en diagonal vaya mas rapido
	if velocidad.length() > 0:
		velocidad = velocidad.normalized() * rapidez
		#Reproducimos la animacion
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#Evitamos que el jugador salga de la pantalla
	position += velocidad * delta
	position = position.clamp(Vector2.ZERO, tamaño_pantalla)
	
	#Escogemos las animaciones correctas
	if velocidad.x == 0 && velocidad.y == 400:
		$AnimatedSprite2D.animation = "caminar_abajo"
	elif floor(velocidad.x) == -283 && floor(velocidad.y) == 282:
		$AnimatedSprite2D.animation = "caminar_abajo-izquierda"
	elif velocidad.x == -400 && velocidad.y == 0:
		$AnimatedSprite2D.animation = "caminar_izquierda"
	elif floor(velocidad.x) == -283 && floor(velocidad.y) == -283:
		$AnimatedSprite2D.animation = "caminar_izquierda-arriba"
	elif velocidad.x == 0 && velocidad.y == -400:
		$AnimatedSprite2D.animation = "caminar_arriba"
	elif floor(velocidad.x) == 282 && floor(velocidad.y) == -283:
		$AnimatedSprite2D.animation = "caminar_arriba-derecha"
	elif velocidad.x == 400 && velocidad.y == 0:
		$AnimatedSprite2D.animation = "caminar_derecha"
	elif floor(velocidad.x) == 282 && floor(velocidad.y) == 282:
		$AnimatedSprite2D.animation = "caminar_derecha-abajo"

# Señal de colision
func _on_body_entered(body):
	hide() # El jugador desaparece despues de haber sido golpeado
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
