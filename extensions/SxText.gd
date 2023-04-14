extends Object
class_name SxText

# Convert a text to camel case.
# Example:
#   SxText.to_camel_case("hello_world")  # => "helloWorld"
static func to_camel_case(s: String) -> String:
    var should_upper := false
    var output := ""
    for c in s:
        if c == "_":
            should_upper = true
        else:
            if should_upper:
                output += c.to_upper()
                should_upper = false
            else:
                output += c
    return output

# Convert a text to pascal case.
# Example:
#   SxText.to_pascal_case("hello_world")  # => "HelloWorld"
static func to_pascal_case(s: String) -> String:
    var should_upper := true
    var output := ""
    for c in s:
        if c == "_":
            should_upper = true
        else:
            if should_upper:
                output += c.to_upper()
                should_upper = false
            else:
                output += c
    return output
