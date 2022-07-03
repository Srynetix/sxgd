# SxVirtualControls

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxVirtualControls.gd](../../../modules/SxVirtualControls/SxVirtualControls.gd)|
|*Inherits from*|`Control`|
|*Globally exported as*|`SxVirtualControls`|

> A simple virtual controls module.  
>   
> You only need to create a new scene, inheriting from SxVirtualControls,  
> and then instancing your controls in it.  
>   
> On buttons, you can affect an action key (mapped in the Input Map),  
> and on joysticks, you can affect 4 actions keys, one for each direction.  
>   
> You have 3 samples at your disposal in the [samples](../../../../sxgd/modules/SxVirtualControls/samples) folder.  
## Enums

### `DisplayMode`

*Prototype*: `enum DisplayMode {`

> Controls display mode  
## Exports

### `display_mode`

*Code*: `export(DisplayMode) var display_mode: int = DisplayMode.OnlyMobile`

> Controls display mode, defaults to "Only mobile"  
