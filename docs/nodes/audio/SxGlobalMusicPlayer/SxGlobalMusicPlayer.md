# SxGlobalMusicPlayer

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxGlobalMusicPlayer.gd](../../../../nodes/audio/SxGlobalMusicPlayer/SxGlobalMusicPlayer.gd)|
|*Inherits from*|`AudioStreamPlayer`|
|*Globally exported as*|`SxGlobalMusicPlayer`|

> An audio player, used to play sound tracks, to be used through inheritance as an autoload.  
> (see [SxGlobalAudioFxPlayer](../SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.md)).  
## Public variables

### `global_volume_db`

*Code*: `var global_volume_db: float setget _set_global_volume_db`

> Global volume in DB  
## Methods

### `fade_in`

*Prototype*: `func fade_in(duration: float = 0.5) -> void`

> Apply a "fade in" effect on sound with an optional duration in seconds.  
> Duration defaults to 0.5 seconds.  
>   
> Examples:  
>   player.fade_in()  
>   player.fade_in(2.0)  
### `fade_out`

*Prototype*: `func fade_out(duration: float = 0.5) -> void`

> Apply a "fade out" effect on sound with an optional duration in seconds.  
> Duration defaults to 0.5 seconds.  
>   
> Examples:  
>   player.fade_out()  
>   player.fade_out(2.0)  
### `play_stream`

*Prototype*: `func play_stream(stream: AudioStream) -> void`

> Plays an audio stream.  
>   
> Example:  
>   player.play_stream(my_stream)  
