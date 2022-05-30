# SxText - Text utilities

*Source*: [SxText.gd](../../extensions/SxText.gd)

This extension exposes text utilities.

## Static methods

### `to_camel_case`
`SxText.to_camel_case(s: String) -> String`  
Convert a text to camel case (like helloWorld).  
*Example*: `var t = SxText.to_camel_case("hello_world") # => "helloWorld"`

### `to_pascal_case`
`SxText.to_pascal_case(s: String) -> String`  
Convert a text to pascal case (like HelloWorld).  
*Example*: `var t = SxText.to_pascal_case("hello_world") # => "HelloWorld"`