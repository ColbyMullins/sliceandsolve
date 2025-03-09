extends Node

@onready var restart_delay: Timer = $RestartDelay
@onready var main_timer: Timer = $MainTimer
@onready var timer_bar: TextureProgressBar = $TimerBar
signal main_timeout
signal delay_timeout


func _process(delta: float) -> void:
	timer_bar.value = (main_timer.time_left / main_timer.wait_time) * 100


func _on_main_timer_timeout() -> void:
	main_timeout.emit()

func startDelay() -> void:
	main_timer.paused = true
	restart_delay.start()
	restart_delay.paused = false

func startMain() -> void:
	main_timer.start()
	main_timer.paused = false
	restart_delay.paused = true
	restart_delay.start()

func _on_restart_delay_timeout() -> void:
	delay_timeout.emit()
