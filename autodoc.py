#!/usr/bin/python

from enum import Enum, auto
import os
from dataclasses import dataclass
from typing import List, Optional
import argparse

@dataclass
class Export:
    comments: str
    code: str

    @property
    def export_name(self) -> str:
        return self.code.split("var")[1].split()[0]

@dataclass
class Method:
    comments: str
    code: str

    @property
    def function_name(self) -> str:
        return self.code.removeprefix("static ").removeprefix("func ").split("(")[0].strip()

@dataclass
class Variable:
    comments: str
    code: str

    @property
    def variable_name(self) -> str:
        return self.code.removeprefix("var ").split(" ")[0].removesuffix(":")

@dataclass
class Signal:
    comments: str
    code: str

    @property
    def signal_name(self) -> str:
        return self.code.removeprefix("signal ").split("(")[0].strip()

@dataclass
class GdEnum:
    comments: str
    code: str

    @property
    def enum_name(self) -> str:
        return self.code.removeprefix("enum ").split("{")[0].strip()

@dataclass
class GdClass:
    script_path: str
    script_name: str
    extends: str = "Node"
    class_comments: str = ""
    class_name: Optional[str] = None
    public_variables: List[Variable] = None
    enums: List[GdEnum] = None
    exports: List[Export] = None
    methods: List[Method] = None
    signals: List[Signal] = None
    static_methods: List[Method] = None
    classes: List["GdClass"] = None

class ParseState(Enum):
    File = auto()
    Class = auto()

class ScriptStructure:
    @staticmethod
    def _parse_extends(line: str) -> str:
        return line.removeprefix("extends").strip()

    @staticmethod
    def _parse_class_name(line: str) -> str:
        return line.removeprefix("class_name").strip()

    @classmethod
    def _parse_gdenum(cls, line: str, comments: List[str]) -> GdEnum:
        return GdEnum(
            comments="\n".join(comments),
            code=cls._parse_code(line)
        )

    @classmethod
    def _parse_signal(cls, line: str, comments: List[str]) -> Signal:
        return Signal(
            comments="\n".join(comments),
            code=cls._parse_code(line)
        )
    
    @classmethod
    def _parse_gdclass(cls, script_path: str, line: str, comments: List[str]) -> GdClass:
        class_name = line.removeprefix("class ").split(":")[0].strip()
        new_class = cls._prepare_class(script_path, class_name)
        new_class.class_comments = "\n".join(comments)
        return new_class

    @staticmethod
    def _parse_code(line: str) -> str:
        return line.removesuffix(":")

    @classmethod
    def _parse_method(cls, line: str, comments: List[str]) -> Method:
        return Method(
            code=cls._parse_code(line),
            comments="\n".join(comments)
        )

    @classmethod
    def _parse_export(cls, line: str, comments: List[str]) -> Export:
        return Export(
            code=cls._parse_code(line),
            comments="\n".join(comments)
        )

    @classmethod
    def _parse_variable(cls, line: str, comments: List[str]) -> Variable:
        return Variable(
            code=cls._parse_code(line),
            comments="\n".join(comments)
        )

    @classmethod
    def _prepare_class(cls, script_path: str, script_name: str) -> GdClass:
        return GdClass(
            script_path=script_path,
            script_name=script_name,
            class_comments="",
            class_name=None,
            enums=[],
            exports=[],
            methods=[],
            signals=[],
            static_methods=[],
            classes=[],
            public_variables=[]
        )

    @classmethod
    def parse_structure(cls, script_path: str, script_name: str, contents: str) -> GdClass:
        base_class = cls._prepare_class(script_path, script_name)

        class_stack = [base_class]
        current_class = class_stack[-1]

        comments = []

        for line in contents.splitlines():
            if line.strip() == "":
                continue

            if len(class_stack) > 1:
                spaces = " " * 4 * (len(class_stack) - 1)
                if line.startswith(spaces):
                    line = line.removeprefix(spaces)
                else:
                    class_stack.pop()
                    current_class = class_stack[-1]

            if line.startswith("# "):
                comments.append(line.removeprefix("# "))
            elif line.startswith("#"):
                comments.append(line.removeprefix("#"))
            elif line.startswith("enum "):
                current_class.enums.append(cls._parse_gdenum(line, comments))
                comments.clear()
            elif line.startswith("var ") and not line.startswith("var _"):
                current_class.public_variables.append(cls._parse_variable(line, comments))
                comments.clear()
            elif line.startswith("class "):
                new_class = cls._parse_gdclass(script_path, line, comments)
                current_class.classes.append(new_class)
                comments.clear()
                class_stack.append(new_class)
                current_class = new_class
            elif line.startswith("signal"):
                current_class.signals.append(cls._parse_signal(line, comments))
                comments.clear()
            elif line.startswith("export ") or line.startswith("export("):
                current_class.exports.append(cls._parse_export(line, comments))
                comments.clear()
            elif line.startswith("extends "):
                current_class.extends = cls._parse_extends(line)
                if len(comments) > 0:
                    current_class.class_comments = "\n".join(comments)
                comments.clear()
            elif line.startswith("class_name "):
                current_class.class_name = cls._parse_class_name(line)
            elif line.startswith("func ") and not line.startswith("func _"):
                current_class.methods.append(cls._parse_method(line, comments))
                comments.clear()
            elif line.startswith("static func ") and not line.startswith("static func _"):
                current_class.static_methods.append(cls._parse_method(line, comments))
                comments.clear()

        return base_class

class StructWriter:
    @classmethod
    def write_file_header(cls, base_class: GdClass, top_level: bool = True) -> str:
        if top_level:
            level = 1
        else:
            level = 2

        output = (
            cls.write_header_line(base_class.script_name, level=level)
            + cls.write_line()
        )

        if top_level:
            output += cls.write_line(f"*Source*: [{base_class.script_name}.gd]({base_class.script_path})")
            output += cls.write_line()

        output += cls.write_line(f"*Inherits from `{base_class.extends}`*")
        output += cls.write_line()

        if base_class.class_name:
            output += (
                cls.write_line(f"*Globally exported as `{base_class.class_name}`*")
                + cls.write_line()
            )

        if base_class.class_comments:
            output += (
                cls.write_line(base_class.class_comments)
                + cls.write_line()
            )

        return output

    @classmethod
    def write_header_line(cls, line: str, *, level: int) -> str:
        return cls.write_line(f"{'#' * level} {line}")

    @classmethod
    def write_line(cls, line: str = "") -> str:
        return f"{line}\n"

    @classmethod
    def write_enum(cls, gdenum: GdEnum, level: int) -> str:
        output = (
            cls.write_header_line(f"`{gdenum.enum_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Prototype*: `{gdenum.code}`")
            + cls.write_line()
        )

        if gdenum.comments:
            output += (
                cls.write_line(gdenum.comments)
                + cls.write_line()
            )

        return output

    @classmethod
    def write_signal(cls, signal: Signal, level: int) -> str:
        output = (
            cls.write_header_line(f"`{signal.signal_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Code*: `{signal.code}`")
            + cls.write_line()
        )

        if signal.comments:
            output += (
                cls.write_line(signal.comments)
                + cls.write_line()
            )

        return output

    @classmethod
    def write_export(cls, export: Export, level: int) -> str:
        output = (
            cls.write_header_line(f"`{export.export_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Code*: `{export.code}`")
            + cls.write_line()
        )

        if export.comments:
            output += (
                cls.write_line(export.comments)
                + cls.write_line()
            )
        
        return output

    @classmethod
    def write_variable(cls, variable: Variable, level: int) -> str:
        output = (
            cls.write_header_line(f"`{variable.variable_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Code*: `{variable.code}`")
            + cls.write_line()
        )

        if variable.comments:
            output += (
                cls.write_line(variable.comments)
                + cls.write_line()
            )
        
        return output

    @classmethod
    def write_method(cls, method: Method, level: int) -> str:
        output = (
            cls.write_header_line(f"`{method.function_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Prototype*: `{method.code}`")
            + cls.write_line()
        )

        if method.comments:
            output += (
                cls.write_line(method.comments)
                + cls.write_line()
            )
        
        return output

    @classmethod
    def write_class(cls, gdclass: GdClass, *, top_level: bool = True) -> str:
        if top_level:
            prefix = ""
            base_level = 1
        else:
            prefix = f"{gdclass.script_name}, "
            base_level = 2

        output = cls.write_file_header(gdclass, top_level)

        if gdclass.enums:
            output += cls.write_header_line(f"{prefix}Enums", level=base_level + 1)
            output += cls.write_line()
            for gdenum in gdclass.enums:
                output += cls.write_enum(gdenum, base_level + 2)

        if gdclass.signals:
            output += cls.write_header_line(f"{prefix}Signals", level=base_level + 1)
            output += cls.write_line()
            for signal in gdclass.signals:
                output += cls.write_signal(signal, base_level + 2)

        if gdclass.exports:
            output += cls.write_header_line(f"{prefix}Exports", level=base_level + 1)
            output += cls.write_line()
            for export in gdclass.exports:
                output += cls.write_export(export, base_level + 2)
        
        if gdclass.public_variables:
            output += cls.write_header_line(f"{prefix}Public variables", level=base_level + 1)
            output += cls.write_line()
            for variable in gdclass.public_variables:
                output += cls.write_variable(variable, base_level + 2)

        if gdclass.static_methods:
            output += cls.write_header_line(f"{prefix}Static methods", level=base_level + 1)
            output += cls.write_line()
            for method in gdclass.static_methods:
                output += cls.write_method(method, base_level + 2)

        if gdclass.methods:
            output += cls.write_header_line(f"{prefix}Methods", level=base_level + 1)
            output += cls.write_line()
            for method in gdclass.methods:
                output += cls.write_method(method, base_level + 2)

        if gdclass.classes:
            for gdclass in gdclass.classes:
                output += cls.write_class(gdclass, top_level=False)

        return output

    @classmethod
    def write(cls, base_class: GdClass) -> str:
        return cls.write_class(base_class, top_level=True)

def generate_doc_for_script(path: str) -> str:
    filename = os.path.basename(path)
    base, ext = os.path.splitext(filename)
    assert ext == ".gd", "Script should be a .gd file"

    with open(path, mode="r") as hndl:
        contents = hndl.read()

    structure = ScriptStructure.parse_structure(path, base, contents)
    output = StructWriter.write(structure)
    return output

# generate_doc_for_script("./nodes/audio/SxGlobalMusicPlayer/SxGlobalMusicPlayer.gd")
# generate_doc_for_script("./nodes/audio/SxAudioMultiStreamPlayer/SxAudioMultiStreamPlayer.gd")
# generate_doc_for_script("./nodes/audio/SxGlobalAudioFxPlayer/SxGlobalAudioFxPlayer.gd")
# generate_doc_for_script("./nodes/utils/SxGameData/SxGameData.gd")
# generate_doc_for_script("./extensions/SxLog.gd")

parser = argparse.ArgumentParser("autodoc", description="generate documentation for a GDScript file")
parser.add_argument("script_path", help="path to script")
parser.add_argument("-o", "--output", help="output path, defaults to stdout", default="-")

args = parser.parse_args()
data = generate_doc_for_script(args.script_path)
output_file = args.output
if output_file == "-":
    print(data)
else:
    with open(output_file, mode="w") as hndl:
        hndl.write(data)