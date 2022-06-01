# SxGlobalAudioFxPlayer

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxGlobalAudioFxPlayer.gd](../../../../nodes/audio/SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxGlobalAudioFxPlayer`|

> A wrapper around a SxAudioMultiStreamPlayer, to be used through inheritance as an autoload, which means:  
>   
> - inherit the node in your game,  
> - configure the `streams` parameter,  
> - and set it as **autoload**.  
## Exports

### `max_voices`

*Code*: `export(int, 1, 16) var max_voices = 4`

> Maximum simultaneous voices.  
### `streams`

*Code*: `export(Dictionary) var streams = {}`

> Audio streams to play  
## Public variables

### `player`

*Code*: `var player: SxAudioMultiStreamPlayer`

## Methods

### `get_voice`

*Prototype*: `func get_voice(voice: int) -> AudioStreamPlayer`

> Get voice by index.  
### `play`

*Prototype*: `func play(stream_name: String, voice: int = -1) -> void`

> Play a stream on an automatically selected voice, or a specific voice.  
