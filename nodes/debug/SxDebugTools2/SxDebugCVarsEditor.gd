extends MarginContainer
class_name SxDebugCVarsEditor

var container: VBoxContainer

func _ready() -> void:
    container = VBoxContainer.new()
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    add_child(container)

    _refresh()

func _refresh() -> void:
    # Clear existing container
    while container.get_child_count() > 0:
        var child := container.get_child(0)
        container.remove_child(child)
        child.queue_free()

    for unit in SxCVars.list_units():
        var hbox := HBoxContainer.new()
        var label := Label.new()
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.text = unit.name
        hbox.add_child(label)
        container.add_child(hbox)

        _build_variant_input(unit, hbox)

func _build_variant_input(unit: SxCVars.CVarUnit, hbox: HBoxContainer) -> void:
    var data := unit.value

    var data_type := typeof(data)
    if data_type == TYPE_STRING:
        var value := LineEdit.new()
        value.text = data
        value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(value)

        value.text_changed.connect(func(new_value):
            unit.value = new_value
        )

    elif data_type == TYPE_FLOAT || data_type == TYPE_INT:
        var value := SpinBox.new()
        value.allow_greater = true
        value.allow_lesser = true
        value.step = 0
        value.rounded = false
        value.value = data
        value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(value)

        value.value_changed.connect(func(new_value):
            unit.value = new_value
        )

    elif data_type == TYPE_BOOL:
        var value := CheckBox.new()
        value.button_pressed = data
        value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        hbox.add_child(value)

        value.toggled.connect(func(new_value):
            unit.value = new_value
        )

    else:
        print(unit)
