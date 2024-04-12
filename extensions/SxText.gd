extends Object
class_name SxText
## Text extensions.
##
## Additional methods to work with text.

## Convert a text to 'camelCase'.[br]
##
## Usage:
## [codeblock]
## SxText.to_camel_case("hello_world")
## # => "helloWorld"
## [/codeblock]
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

## Convert a text to 'PascalCase'.[br]
##
## Usage:
## [codeblock]
## SxText.to_pascal_case("hello_world")
## # => "HelloWorld"
## [/codeblock]
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
