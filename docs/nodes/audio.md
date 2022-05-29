# Audio nodes

## SxAudioMultiStreamPlayer
*Source*: [SxAudioMultiStreamPlayer.gd](../../nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.gd)  
An audio player with multiple simultaneous voices, configurable through the `max_voices` parameter.

## SxGlobalAudioFxPlayer
*Source* [SxGlobalAudioFxPlayer.gd](../../nodes/audio/SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.gd)  
A wrapper around a [SxAudioMultiStreamPlayer](#sxaudiomultistreamplayer), to be used through inheritance as an autoload, which means:

- inherit the node in your game,
- configure the `streams` parameter,
- and set it as **autoload**.

## SxGlobalMusicPlayer
*Source* [SxGlobalMusicPlayer.gd](../../nodes/audio/SxGlobalMusicPlayer/SxGlobalMusicPlayer.gd)  
An audio player, used to play sound tracks, to be used through inheritance as an autoload. (see [SxGlobalAudioFxPlayer](#sxglobalaudiofxplayer)).
