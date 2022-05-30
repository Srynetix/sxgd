# SxAudioMultiStreamPlayer

*Source*: [SxAudioMultiStreamPlayer.gd](../../../nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.gd)

An audio player with multiple simultaneous voices, configurable through the `max_voices` parameter.

## Parameters

### `max_voices`
`export(int, 1, 16) var max_voices = 4`  
Maximum simultaneous voices.

## Methods

### `get_voice`
`func get_voice(voice: int) -> AudioStreamPlayer`  
Get a voice by index.

### `play`
`func play(stream: AudioStream) -> void`  
Play a stream on an automatically selected voice.

### `play_on_voice`
`func play_on_voice(stream: AudioStream, voice: int) -> void`  
Play a stream on a specific voice.

### `play_on_player`
`func play_on_player(stream: AudioStream, player: AudioStreamPlayer) -> void`  
Play a stream on a specific player.