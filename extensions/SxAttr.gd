extends Object
class_name SxAttr

static func _build_static_key(namespace_: String, attribute: String) -> String:
    return "SxAttr_" + namespace_ + "_" + attribute

static func set_static_attribute(namespace_: String, attribute: String, value: Variant) -> void:
    Engine.set_meta(_build_static_key(namespace_, attribute), value)
    
static func setup_static_attribute(namespace_: String, attribute: String, value: Variant) -> void:
    if !has_static_attribute(namespace_, attribute):
        set_static_attribute(namespace_, attribute, value)
        
static func has_static_attribute(namespace_: String, attribute: String):
    var key := _build_static_key(namespace_, attribute)
    return Engine.has_meta(key)
    
static func get_static_attribute(namespace_: String, attribute: String, default: Variant = null) -> Variant:
    var key := _build_static_key(namespace_, attribute)
    print(Engine.get_meta_list())
    return Engine.get_meta(key, default)
