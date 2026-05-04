extends AudioStreamPlayer

var current_music: AudioStream

func play_music(stream: AudioStream):
	if stream == current_music:
		return

	current_music = stream
	self.stream = stream
	play()

func stop_music():
	current_music = null
	stop()
