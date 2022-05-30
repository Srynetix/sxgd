# SxGlobalAudioFxPlayer

*Source* [SxGlobalAudioFxPlayer.gd](../../../nodes/audio/SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.gd)

A wrapper around a [SxAudioMultiStreamPlayer](#sxaudiomultistreamplayer), to be used through inheritance as an autoload, which means:

- inherit the node in your game,
- configure the `streams` parameter,
- and set it as **autoload**.

## Parameters

### `max_voices`
`export(int, 1, 16) var max_voices = 4`  
Maximum simultaneous voices.

### `streams`
`export(Dictionary) var streams = {}`  
Audio streams to play.

## Methods

### `play`
`func play(stream_name: String, voice: int = -1) -> void`  
Play a stream on an automatically selected voice, or a specific voice.

### `get_voice`
`func get_voice(voice: int) -> AudioStreamPlayer`  
Get voice by index.