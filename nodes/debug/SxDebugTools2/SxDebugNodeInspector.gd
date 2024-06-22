extends VBoxContainer
class_name SxDebugNodeInspector


class Property:
    extends RefCounted

    var name: String
    var usage: int
    var type: int
    var hint: int
    var hint_string: String
    var value: Variant

    func has_category_usage() -> bool:
        return self.usage & PROPERTY_USAGE_CATEGORY == PROPERTY_USAGE_CATEGORY

    func has_group_usage() -> bool:
        return self.usage & PROPERTY_USAGE_GROUP == PROPERTY_USAGE_GROUP

    func has_editor_usage() -> bool:
        return self.usage & PROPERTY_USAGE_EDITOR == PROPERTY_USAGE_EDITOR


class PropertyGroup:
    extends RefCounted

    var name: String
    var properties: Array[Property] = []

    func _init(name_: String):
        name = name_


class PropertyCategory:
    extends RefCounted

    var name: String
    var groups: Array[PropertyGroup] = []

    func _init(name_: String):
        name = name_


class PropertyInspectorData:
    extends RefCounted

    var node: Node
    var categories: Array[PropertyCategory] = []

    func _init(node_: Node) -> void:
        node = node_


class PropertyInspector:
    extends RefCounted

    static func generate_data(node: Node) -> PropertyInspectorData:
        var last_category
        var last_group

        var inspector_data := PropertyInspectorData.new(node)
        for prop_dict in node.get_property_list():
            var prop := Property.new()
            prop.name = prop_dict["name"] as String
            prop.usage = prop_dict["usage"] as int
            prop.hint = prop_dict["hint"] as int
            prop.hint_string = prop_dict["hint_string"] as String
            prop.type = prop_dict["type"] as int

            if prop.name == "":
                continue

            if prop.has_category_usage():
                var category := PropertyCategory.new(prop.name)
                last_category = category
                last_group = null
                inspector_data.categories.push_back(category)

            elif prop.has_group_usage():
                var group := PropertyGroup.new(prop.name)
                last_group = group
                last_category.groups.push_back(last_group)

            elif prop.has_editor_usage():
                if last_group == null:
                    var group := PropertyGroup.new("")
                    last_group = group

                prop.value = node.get(prop.name)
                last_group.properties.push_back(prop)

        # Reverse categories to match Godot inspector
        inspector_data.categories.reverse()

        return inspector_data


class PropertyCategoryField:
    extends VBoxContainer

    var _category: PropertyCategory
    var _inner_container: VBoxContainer
    var _groups: Array[PropertyGroupField]

    func _init(category: PropertyCategory) -> void:
        _category = category
        _groups = [] as Array[PropertyGroupField]

        var category_background := StyleBoxFlat.new()
        var category_label := Label.new()
        category_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        category_label.text = category.name
        category_label.add_theme_stylebox_override("normal", category_background)
        add_child(category_label)

        var inner_margin_container := MarginContainer.new()
        inner_margin_container.add_theme_constant_override("margin_left", 0)
        add_child(inner_margin_container)

        _inner_container = VBoxContainer.new()
        inner_margin_container.add_child(_inner_container)

    func add_group_field(field: PropertyGroupField) -> void:
        _inner_container.add_child(field)
        _groups.push_back(field)

    func get_group_field(idx: int) -> PropertyGroupField:
        return _groups[idx]


class PropertyGroupField:
    extends VBoxContainer

    var _group: PropertyGroup
    var _inner_container: VBoxContainer
    var _properties: Array[PropertyField]

    func _init(group: PropertyGroup) -> void:
        _group = group
        _properties = [] as Array[PropertyField]

        var group_container_btn := Button.new()
        group_container_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
        group_container_btn.text = "[v] %s" % group.name
        add_child(group_container_btn)

        var group_margin_container := MarginContainer.new()
        group_margin_container.add_theme_constant_override("margin_left", 8)
        add_child(group_margin_container)

        group_container_btn.pressed.connect(func():
            group_margin_container.visible = !group_margin_container.visible
            if group_margin_container.visible:
                group_container_btn.text = "[v]" + group_container_btn.text.substr(3)
            else:
                group_container_btn.text = "[>]" + group_container_btn.text.substr(3)
        )

        _inner_container = VBoxContainer.new()
        group_margin_container.add_child(_inner_container)

    func add_property_field(field: PropertyField) -> void:
        _inner_container.add_child(field)
        _properties.push_back(field)

    func get_property_field(idx: int) -> PropertyField:
        return _properties[idx]


class PropertyField:
    extends HBoxContainer

    var _property: Property
    var _value_container: HBoxContainer

    signal value_changed(new_value: Variant, new_processed_value: Variant)

    func _init(property: Property) -> void:
        _property = property

        size_flags_horizontal = Control.SIZE_EXPAND_FILL

        var label := Label.new()
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.text = _property.name.capitalize()
        label.tooltip_text = _property.name
        label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
        label.mouse_filter = Control.MOUSE_FILTER_PASS
        add_child(label)

        _value_container = HBoxContainer.new()
        _value_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        add_child(_value_container)

    func update(value: Variant) -> void:
        _property.value = value
        _update_value(_property.value)

    func _update_value(value: Variant) -> void:
        pass


class PropertyEnumField:
    extends PropertyField

    var _option: OptionButton

    func _init(property: Property) -> void:
        super._init(property)

        _option = OptionButton.new()
        _option.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
        _option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        for entry in _property.hint_string.split(","):
            _option.add_item(entry)
        _value_container.add_child(_option)
        _update_value(_property.value)

        _option.item_selected.connect(func(new_item):
            value_changed.emit(_option.get_item_id(new_item), _option.get_item_id(new_item))
        )

    func _update_value(value: Variant) -> void:
        _option.select(value)


class PropertyBoolField:
    extends PropertyField

    var _checkbox: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _checkbox = CheckBox.new()
        _checkbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _checkbox.button_pressed = _property.value
        _checkbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_checkbox)
        _update_value(_property.value)

        _checkbox.toggled.connect(func(new_value):
            value_changed.emit(new_value, new_value)
        )

    func _update_value(value: Variant) -> void:
        _checkbox.button_pressed = value


class PropertyFloatField:
    extends PropertyField

    var _spinbox: SpinBox
    var _overriden: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _spinbox = SpinBox.new()
        _spinbox.allow_greater = true
        _spinbox.allow_lesser = true
        _spinbox.step = 0
        _spinbox.rounded = false
        _spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_spinbox)

        _overriden = CheckBox.new()
        _value_container.add_child(_overriden)
        _update_value(_property.value)

        var has_radians_as_degrees := false
        if _property.hint == PROPERTY_HINT_RANGE:
            if "radians_as_degrees" in _property.hint_string:
                has_radians_as_degrees = true

        _spinbox.value_changed.connect(func(new_value):
            var processed_value = new_value
            if has_radians_as_degrees:
                processed_value = deg_to_rad(new_value)
            value_changed.emit(new_value, processed_value)
        )

    func _update_value(value: Variant) -> void:
        _overriden.button_pressed = value != null
        _spinbox.editable = value != null
        _spinbox.value = value


class PropertyIntField:
    extends PropertyField

    var _spinbox: SpinBox
    var _overriden: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _spinbox = SpinBox.new()
        _spinbox.allow_greater = true
        _spinbox.allow_lesser = true
        _spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_spinbox)

        _overriden = CheckBox.new()
        _value_container.add_child(_overriden)

        var initial_value = _property.value
        var has_radians_as_degrees := false
        if _property.hint == PROPERTY_HINT_RANGE:
            if "radians_as_degrees" in _property.hint_string:
                has_radians_as_degrees = true

        if has_radians_as_degrees:
            initial_value = rad_to_deg(initial_value)
        _update_value(initial_value)

        _spinbox.value_changed.connect(func(new_value):
            var processed_value = new_value
            if has_radians_as_degrees:
                processed_value = deg_to_rad(new_value)
            value_changed.emit(new_value, processed_value)
        )

    func _update_value(value: Variant) -> void:
        _overriden.button_pressed = value != null
        _spinbox.editable = value != null

        if value != null:
            var has_radians_as_degrees := false
            if _property.hint == PROPERTY_HINT_RANGE:
                if "radians_as_degrees" in _property.hint_string:
                    has_radians_as_degrees = true

            if has_radians_as_degrees:
                value = rad_to_deg(value)
            _spinbox.value = value


class PropertyVector2Field:
    extends PropertyField

    var _x_value: SpinBox
    var _y_value: SpinBox

    func _init(property: Property) -> void:
        super._init(property)

        var vector_container := HBoxContainer.new()
        vector_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

        var x := Label.new()
        x.text = "X"

        _x_value = SpinBox.new()
        _x_value.allow_greater = true
        _x_value.allow_lesser = true
        _x_value.rounded = false
        _x_value.step = 0

        var y := Label.new()
        y.text = "Y"

        _y_value = SpinBox.new()
        _y_value.allow_greater = true
        _y_value.allow_lesser = true
        _y_value.rounded = false
        _y_value.step = 0

        vector_container.add_child(x)
        vector_container.add_child(_x_value)
        vector_container.add_child(y)
        vector_container.add_child(_y_value)
        _value_container.add_child(vector_container)
        _update_value(_property.value)

        _x_value.value_changed.connect(func(new_value):
            var new_vec = Vector2(new_value, _y_value.value)
            value_changed.emit(new_vec, new_vec)
        )

        _y_value.value_changed.connect(func(new_value):
            var new_vec = Vector2(_x_value.value, new_value)
            value_changed.emit(new_vec, new_vec)
        )

    func _update_value(value: Variant) -> void:
        _x_value.value = value.x
        _y_value.value = value.y


class PropertyVector2IField:
    extends PropertyField

    var _x_value: SpinBox
    var _y_value: SpinBox

    func _init(property: Property) -> void:
        super._init(property)

        var vector_container := HBoxContainer.new()
        vector_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

        var x := Label.new()
        x.text = "X"

        _x_value = SpinBox.new()
        _x_value.allow_greater = true
        _x_value.allow_lesser = true
        _x_value.rounded = false
        _x_value.step = 0

        var y := Label.new()
        y.text = "Y"

        _y_value = SpinBox.new()
        _y_value.allow_greater = true
        _y_value.allow_lesser = true
        _y_value.rounded = false
        _y_value.step = 0

        vector_container.add_child(x)
        vector_container.add_child(_x_value)
        vector_container.add_child(y)
        vector_container.add_child(_y_value)
        _value_container.add_child(vector_container)
        _update_value(_property.value)

        _x_value.value_changed.connect(func(new_value):
            var new_vec = Vector2i(new_value, _y_value.value)
            value_changed.emit(new_vec, new_vec)
        )

        _y_value.value_changed.connect(func(new_value):
            var new_vec = Vector2i(_x_value.value, new_value)
            value_changed.emit(new_vec, new_vec)
        )

    func _update_value(value: Variant) -> void:
        _x_value.value = value.x
        _y_value.value = value.y


class PropertyColorField:
    extends PropertyField

    var _color: ColorPickerButton
    var _overriden: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _color = ColorPickerButton.new()
        _color.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _color.custom_minimum_size.y = 24
        _value_container.add_child(_color)

        _overriden = CheckBox.new()
        _value_container.add_child(_overriden)
        _update_value(_property.value)

        _color.color_changed.connect(func(new_color):
            value_changed.emit(new_color, new_color)
        )

    func _update_value(value: Variant) -> void:
        _overriden.button_pressed = value != null
        _color.disabled = value == null

        if value != null:
            _color.color = value


class PropertyStringField:
    extends PropertyField

    var _lineedit: LineEdit
    var _overriden: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _lineedit = LineEdit.new()
        _lineedit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_lineedit)

        _overriden = CheckBox.new()
        _value_container.add_child(_overriden)
        _update_value(_property.value)

        _lineedit.text_changed.connect(func(new_value):
            value_changed.emit(new_value, new_value)
        )

    func _update_value(value: Variant) -> void:
        _overriden.button_pressed = value != null
        _lineedit.editable = value != null
        _lineedit.text = value


class PropertyNodePathField:
    extends PropertyField

    var _lineedit: LineEdit
    var _overriden: CheckBox

    func _init(property: Property) -> void:
        super._init(property)

        _lineedit = LineEdit.new()
        _lineedit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_lineedit)

        _overriden = CheckBox.new()
        _value_container.add_child(_overriden)
        _update_value(_property.value)

        _lineedit.text_changed.connect(func(new_value):
            value_changed.emit(new_value, new_value)
        )

    func _update_value(value: Variant) -> void:
        _overriden.button_pressed = value != null
        _lineedit.editable = value != null
        _lineedit.text = str(value)


class PropertyObjectField:
    extends PropertyField

    var _label: Label

    func _init(property: Property) -> void:
        super._init(property)

        _label = Label.new()
        _label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
        _label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_label)
        _update_value(_property.value)

    func _update_value(value: Variant) -> void:
        _label.text = "Object: %s" % str(value)


class PropertyReadOnlyField:
    extends PropertyField

    var _label: Label

    func _init(property: Property) -> void:
        super._init(property)

        _label = Label.new()
        _label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
        _label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        _value_container.add_child(_label)
        _update_value(_property.value)

    func _update_value(value: Variant) -> void:
        _label.text = "Unknown: %s" % str(value)


var _already_generated: bool = false
var inspected_node: Node : set = _set_inspected_node
var _category_fields: Array[PropertyCategoryField]
var _updating: bool = false

func _init() -> void:
    _category_fields = [] as Array[PropertyCategoryField]

func _ready() -> void:
    size_flags_horizontal = Control.SIZE_EXPAND_FILL
    size_flags_vertical = Control.SIZE_EXPAND_FILL

func _process(delta: float):
    if inspected_node != null && _already_generated:
        if is_instance_valid(inspected_node):
            _update_inspector(_generate_inspector_data(inspected_node))
        else:
            # Reset inspected node
            inspected_node = null

func _set_inspected_node(value: Node):
    if value == null:
        inspected_node = value
        _clear_inspector()
        _already_generated = false
        return

    if value != inspected_node:
        _already_generated = false

    inspected_node = value

    var data := _generate_inspector_data(inspected_node)
    if !_already_generated:
        _generate_inspector(data)
        _already_generated = true
    else:
        _update_inspector(data)

func _generate_inspector_data(node: Node) -> PropertyInspectorData:
    return PropertyInspector.generate_data(node)

func _clear_inspector() -> void:
    # Clear existing inspector
    for category in _category_fields:
        category.queue_free()
    _category_fields.clear()

func _generate_inspector(data: PropertyInspectorData):
    _clear_inspector()

    for category in data.categories:
        var category_field := PropertyCategoryField.new(category)
        _category_fields.push_back(category_field)
        add_child(category_field)

        for group in category.groups:
            var group_field := PropertyGroupField.new(group)
            category_field.add_group_field(group_field)

            for prop in group.properties:
                var field: PropertyField

                if prop.hint == PROPERTY_HINT_ENUM:
                    field = PropertyEnumField.new(prop)

                elif prop.type == TYPE_BOOL:
                    field = PropertyBoolField.new(prop)

                elif prop.type == TYPE_FLOAT:
                    field = PropertyFloatField.new(prop)

                elif prop.type == TYPE_INT:
                    field = PropertyIntField.new(prop)

                elif prop.type == TYPE_VECTOR2:
                    field = PropertyVector2Field.new(prop)

                elif prop.type == TYPE_VECTOR2I:
                    field = PropertyVector2IField.new(prop)

                elif prop.type == TYPE_COLOR:
                    field = PropertyColorField.new(prop)

                elif prop.type == TYPE_STRING:
                    field = PropertyStringField.new(prop)

                elif prop.type == TYPE_NODE_PATH:
                    field = PropertyNodePathField.new(prop)

                elif prop.type == TYPE_OBJECT:
                    field = PropertyObjectField.new(prop)

                else:
                    field = PropertyReadOnlyField.new(prop)

                group_field.add_property_field(field)

                field.value_changed.connect(func(new_value, new_processed_value):
                    if !_updating:
                        data.node.set(prop.name, new_processed_value)
                )

func _update_inspector(data: PropertyInspectorData):
    _updating = true

    var category_idx := 0
    for category in data.categories:
        var category_container := _category_fields[category_idx]
        var group_idx := 0
        for group in category.groups:
            var group_container := category_container.get_group_field(group_idx)
            var prop_idx := 0
            for prop in group.properties:
                var prop_container := group_container.get_property_field(prop_idx)
                prop_container.update(prop.value)
                prop_idx += 1
            group_idx += 1
        category_idx += 1

    _updating = false
