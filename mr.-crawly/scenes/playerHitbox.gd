extends Area2D
# This Area2D exists to carry damage into whatever it touches.
# The var declaration IS what creates the 'damage' property —
# player.gd writes it, enemy hurtboxes read it.
var damage: int = 10
