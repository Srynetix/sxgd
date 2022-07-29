extends Control

onready var background := $Background as Control
onready var effect_selection := $UI/Margin/Margin/HBox/EffectType/Value as OptionButton
onready var params := $UI/Margin/Margin/HBox/Params as VBoxContainer
onready var vignette := $Effects/SxVignette as SxVignette
onready var shockwave := $Effects/SxShockwave as SxShockwave
onready var motion_blur := $Effects/SxMotionBlur as SxMotionBlur
onready var better_blur := $Effects/SxBetterBlur as SxBetterBlur
onready var texture := load("res://addons/sxgd/assets/textures/icon.png") as Texture

var _sprites := Array()
var _touched := false
var _last_touched_position := Vector2()

class FloatParamOptions:
    var step := 0.01
    var min_value := 0.0
    var max_value := 9999.0
    var min_size_x := 50.0

    func with_step(value: float) -> FloatParamOptions:
        self.step = value
        return self

    func with_min_value(value: float) -> FloatParamOptions:
        self.min_value = value
        return self

    func with_max_value(value: float) -> FloatParamOptions:
        self.max_value = value
        return self


func _ready() -> void:
    var viewport_size := get_viewport_rect().size

    var sprite_count := 50
    for i in range(sprite_count):
        var sprite := Sprite.new()
        sprite.texture = texture
        sprite.scale = Vector2(rand_range(0.5, 2), rand_range(0.5, 2))
        sprite.position = Vector2(rand_range(0, viewport_size.x), rand_range(0, viewport_size.y))
        sprite.modulate = SxColor.rand()
        sprite.rotation_degrees = rand_range(0, 360)

        _sprites.append(sprite)
        background.add_child(sprite)

    effect_selection.add_item("Vignette")
    effect_selection.add_item("Shockwave")
    effect_selection.add_item("MotionBlur")
    effect_selection.add_item("BetterBlur")
    effect_selection.connect("item_selected", self, "_on_item_selected")

    _on_item_selected(0)

func _process(delta: float) -> void:
    var viewport_size := get_viewport_rect().size

    for spr in _sprites:
        var sprite := spr as Sprite
        var position := sprite.position
        var rotation := sprite.rotation_degrees
        var texture_size := sprite.texture.get_size()
        var total_size := sprite.scale * texture_size

        position.x -= sprite.scale.x * 100 * delta
        rotation += sprite.scale.y * 10 * delta

        while rotation > 360:
            rotation -= 360

        if position.x < -total_size.x:
            position.x = viewport_size.x + total_size.x
        elif position.x > viewport_size.x + total_size.x:
            position.x = -total_size.x

        sprite.rotation_degrees = rotation
        sprite.position = position

    var selected_idx := effect_selection.selected
    var selected_effect := effect_selection.get_item_text(selected_idx)
    _update_params(selected_effect)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        _touched = event.pressed
        if event.pressed:
            _last_touched_position = event.position
            _on_touch_position_update()

    elif event is InputEventMouseMotion:
        if _touched:
            _last_touched_position = event.position
            _on_touch_position_update()

    elif event is InputEventScreenTouch:
        if _touched:
            _last_touched_position = event.position
            _on_touch_position_update()

func _build_params(effect: String) -> void:
    for node in params.get_children():
        node.queue_free()
        params.remove_child(node)

    if effect == "Vignette":
        _pr_visible(vignette)
        _pr_float(vignette, "vignette_size")
        _pr_float(vignette, "vignette_ratio")

    elif effect == "Shockwave":
        _pr_visible(shockwave)
        _pr_float(shockwave, "wave_size", FloatParamOptions.new().with_max_value(1))
        _pr_float(shockwave, "force", FloatParamOptions.new().with_max_value(1))
        _pr_float(shockwave, "thickness", FloatParamOptions.new().with_max_value(1))
        _pr_vector2(shockwave, "wave_center")

        var hbox := HBoxContainer.new()
        hbox.size_flags_horizontal = SIZE_EXPAND_FILL
        var btn := Button.new()
        btn.text = "Animate"
        btn.size_flags_horizontal = SIZE_EXPAND_FILL
        btn.connect("pressed", self, "_animate_shockwave")
        hbox.add_child(btn)
        params.add_child(hbox)

    elif effect == "MotionBlur":
        _pr_visible(motion_blur)
        _pr_float(motion_blur, "strength")
        _pr_float(motion_blur, "angle_degrees")

    elif effect == "BetterBlur":
        _pr_visible(better_blur)
        _pr_float(better_blur, "strength")

func _update_params(effect: String) -> void:
    if effect == "Vignette":
        params.get_node("VignetteRatio/Value").value = vignette.vignette_ratio
        params.get_node("VignetteSize/Value").value = vignette.vignette_size

    elif effect == "Shockwave":
        var center := shockwave.wave_center
        params.get_node("WaveCenter/VBox/X").value = center.x
        params.get_node("WaveCenter/VBox/Y").value = center.y
        params.get_node("Force/Value").value = shockwave.force
        params.get_node("Thickness/Value").value = shockwave.thickness
        params.get_node("WaveSize/Value").value = shockwave.wave_size

    elif effect == "MotionBlur":
        params.get_node("Strength/Value").value = motion_blur.strength
        params.get_node("AngleDegrees/Value").value = motion_blur.angle_degrees

    elif effect == "BetterBlur":
        params.get_node("Strength/Value").value = better_blur.strength

func _set_effect_visibility(value: bool, obj: Control) -> void:
    obj.visible = value

func _pr_visible(control: Control) -> void:
    var visible_hbox := HBoxContainer.new()
    visible_hbox.size_flags_horizontal = SIZE_EXPAND_FILL
    var visible_label := Label.new()
    visible_label.text = "Visible"
    visible_label.rect_min_size = Vector2(40, 0)
    var visible_checkbox := CheckBox.new()
    visible_checkbox.size_flags_horizontal = SIZE_EXPAND_FILL
    visible_checkbox.pressed = control.visible

    visible_checkbox.connect("toggled", self, "_set_effect_visibility", [control])
    visible_hbox.add_child(visible_label)
    visible_hbox.add_child(visible_checkbox)
    params.add_child(visible_hbox)

func _pr_float(control: Control, name: String, opts: FloatParamOptions = null) -> void:
    if opts == null:
        opts = FloatParamOptions.new()

    var cap_name := SxText.to_pascal_case(name)
    var current := control.get(name) as float
    var hbox := HBoxContainer.new()
    hbox.name = cap_name
    hbox.size_flags_horizontal = SIZE_EXPAND_FILL
    var label_obj := Label.new()
    label_obj.name = "Label"
    label_obj.text = cap_name
    label_obj.rect_min_size = Vector2(opts.min_size_x, 0)
    var input := SpinBox.new()
    input.name = "Value"
    input.size_flags_horizontal = SIZE_EXPAND_FILL
    input.step = opts.step
    input.min_value = opts.min_value
    input.max_value = opts.max_value
    input.value = current

    input.connect("value_changed", self, "_on_value_changed", [control, name])
    hbox.add_child(label_obj)
    hbox.add_child(input)
    params.add_child(hbox)

func _pr_vector2(control: Control, name: String, step: float = 0.01, min_size_x: float = 50) -> void:
    var cap_name := SxText.to_pascal_case(name)
    var current := control.get(name) as Vector2
    var hbox := HBoxContainer.new()
    hbox.name = cap_name
    hbox.size_flags_horizontal = SIZE_EXPAND_FILL
    var label_obj := Label.new()
    label_obj.name = "Label"
    label_obj.text = cap_name
    label_obj.rect_min_size = Vector2(min_size_x, 0)
    var vbox := VBoxContainer.new()
    vbox.name = "VBox"
    vbox.size_flags_horizontal = SIZE_EXPAND_FILL
    var input_x := SpinBox.new()
    input_x.name = "X"
    input_x.size_flags_horizontal = SIZE_EXPAND_FILL
    input_x.max_value = 9999
    input_x.step = step
    input_x.value = current.x
    var input_y := SpinBox.new()
    input_y.name = "Y"
    input_y.size_flags_horizontal = SIZE_EXPAND_FILL
    input_y.max_value = 9999
    input_y.step = step
    input_y.value = current.y

    input_x.connect("value_changed", self, "_on_value_changed_vector2", ["x", control, name])
    input_y.connect("value_changed", self, "_on_value_changed_vector2", ["y", control, name])
    vbox.add_child(input_x)
    vbox.add_child(input_y)
    hbox.add_child(label_obj)
    hbox.add_child(vbox)
    params.add_child(hbox)

func _update_shader(obj: Control, name: String, value) -> void:
    obj.set(name, value)

func _animate_shockwave():
    var x := params.get_node("WaveCenter/VBox/X") as SpinBox
    var y := params.get_node("WaveCenter/VBox/Y") as SpinBox
    shockwave.start_wave(Vector2(x.value, y.value))

func _on_value_changed(value: float, obj: Control, name: String) -> void:
    _update_shader(obj, name, value)

func _on_value_changed_vector2(value: float, coord: String, obj: Control, name: String) -> void:
    var current := obj.get(name) as Vector2
    var param_name := name

    if coord == "x":
        _update_shader(obj, param_name, Vector2(value, current.y))
    else:
        _update_shader(obj, param_name, Vector2(current.x, value))

func _on_touch_position_update() -> void:
    var viewport_size := get_viewport_rect().size
    var selected_idx := effect_selection.selected
    var effect_name := effect_selection.get_item_text(selected_idx)

    if effect_name == "Shockwave":
        var x := params.get_node("WaveCenter/VBox/X") as SpinBox
        var y := params.get_node("WaveCenter/VBox/Y") as SpinBox
        x.value = _last_touched_position.x / viewport_size.x
        y.value = 1 - _last_touched_position.y / viewport_size.y

func _on_item_selected(index: int) -> void:
    var effect := effect_selection.get_item_text(index)
    _build_params(effect)
