# SxAudioMultiStreamPlayer

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxAudioMultiStreamPlayer.gd](../../../../nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxAudioMultiStreamPlayer`|

> An audio player with multiple simultaneous voices, configurable through the `max_voices` parameter.  
## Exports

### `max_voices`

*Code*: `export(int, 1, 16) var max_voices = 4`

> Maximum simultaneous voices.  
## Methods

### `get_voice`

*Prototype*: `func get_voice(voice: int) -> AudioStreamPlayer`

> Get a voice by index.  
>   
> Example:  
>   var first_voice = player.get_voice(0)  
### `play`

*Prototype*: `func play(stream: AudioStream) -> void`

> Play a stream on an automatically selected voice.  
>   
> Example:  
>   player.play(my_stream)  
### `play_on_player`

*Prototype*: `func play_on_player(stream: AudioStream, player: AudioStreamPlayer) -> void`

> Play a stream on a specific player.  
>   
> Example:  
>   player.play_on_player(my_sound, specific_player)  
### `play_on_voice`

*Prototype*: `func play_on_voice(stream: AudioStream, voice: int) -> void`

> Play a stream on a specific voice.  
>   
> Example:  
>   player.play_on_voice(my_sound, 0)  
