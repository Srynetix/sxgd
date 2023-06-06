# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

### Added

- SxDebugConsole: Interactive in-game console you can use to live edit values and nodes
- SxCVars: Simple console vars system, compatible with the SxDebugConsole

### Changed

- SxFxShockwave: Add a WaveBuilder structure to control the wave
- SxFxBetterBlur: Rewrite the blur shader for better quality and still GLES2 compatibility
- SxFxBetterBlur: Disable the effect when hidden
- SxDoubleTap: New "target_rect" var to detect the double tap on a specific surface

### Fixes

- SxFxCamera: Do not force set "anchor mode" and "current"
- SxFxVignette: Do not leak implementation details in the final scene

## [1.1.0] - 2023-03-07

### Changed

- All plugins are now scripts instead of scenes.
- Existing audio nodes were merged in SxAudioStreamPlayer.

## [1.0.0] - 2022-10-04

- Initial version.

[1.1.0]: https://github.com/Srynetix/sxgd/releases/tag/1.1.0
[1.0.0]: https://github.com/Srynetix/sxgd/commit/808c85b66379fd9da1454820063f432d6b364515