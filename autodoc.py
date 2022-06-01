#!/usr/bin/python

from enum import Enum, auto
import os
from dataclasses import dataclass
from typing import List, Optional, OrderedDict, cast
import argparse
from pathlib import Path

@dataclass
class Export:
    comments: str
    code: str

    @property
    def export_name(self) -> str:
        return self.code.split("var")[1].split()[0].removesuffix(":")

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
    is_tool: bool = False
    class_comments: str = ""
    class_name: Optional[str] = None
    public_variables: List[Variable] = cast(List[Variable], None)
    enums: List[GdEnum] = cast(List[GdEnum], None)
    exports: List[Export] = cast(List[Export], None)
    methods: List[Method] = cast(List[Method], None)
    signals: List[Signal] = cast(List[Signal], None)
    static_methods: List[Method] = cast(List[Method], None)
    classes: List["GdClass"] = cast(List["GdClass"], None)

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
            elif line == "tool":
                current_class.is_tool = True
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
    def write_file_header(cls, base_class: GdClass, output_path: str, top_level: bool = True) -> str:
        if top_level:
            level = 1
        else:
            level = 2

        output = (
            cls.write_header_line(base_class.script_name, level=level)
            + cls.write_line()
        )


        if top_level:
            output += write_backbutton(same_level=False)

        output += cls.write_line("|    |     |")
        output += cls.write_line("|----|-----|")
        if top_level:
            output_path_parts = Path(output_path).parts
            script_path_parts = Path(base_class.script_path).parts
            output_path_len = len(output_path_parts)
            script_path_len = len(script_path_parts) - 1
            full_path = os.path.normpath(os.path.join("../" * (script_path_len + output_path_len), base_class.script_path))
            full_path = full_path.replace("\\", "/")
            output += cls.write_line(f"|*Source*|[{base_class.script_name}.gd]({full_path})|")

            if base_class.is_tool:
                output += cls.write_line(f"|*Run*|Runs in editor (tool mode)|")

        output += cls.write_line(f"|*Inherits from*|`{base_class.extends}`|")

        if base_class.class_name:
            output += cls.write_line(f"|*Globally exported as*|`{base_class.class_name}`|")

        output += cls.write_line()

        if base_class.class_comments:
            output += cls.write_comment(base_class.class_comments)

        return output

    @classmethod
    def write_header_line(cls, line: str, *, level: int) -> str:
        return cls.write_line(f"{'#' * level} {line}")

    @classmethod
    def write_line(cls, line: str = "") -> str:
        return f"{line}\n"

    @classmethod
    def write_comment(cls, comments: str) -> str:
        return "\n".join(
            f"> {l}  " for l in comments.split("\n")
        ) + "\n"

    @classmethod
    def write_enum(cls, gdenum: GdEnum, level: int) -> str:
        output = (
            cls.write_header_line(f"`{gdenum.enum_name}`", level=level)
            + cls.write_line()
            + cls.write_line(f"*Prototype*: `{gdenum.code}`")
            + cls.write_line()
        )

        if gdenum.comments:
            output += cls.write_comment(gdenum.comments)

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
            output += cls.write_comment(signal.comments)

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
            output += cls.write_comment(export.comments)

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
            output += cls.write_comment(variable.comments)

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
            output += cls.write_comment(method.comments)

        return output

    @classmethod
    def write_class(cls, gdclass: GdClass, output_path: str, *, top_level: bool = True) -> str:
        if top_level:
            prefix = ""
            base_level = 1
        else:
            prefix = f"{gdclass.script_name}, "
            base_level = 2

        output = cls.write_file_header(gdclass, output_path, top_level)

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
                output += cls.write_class(gdclass, output_path, top_level=False)

        return output

    @classmethod
    def write(cls, base_class: GdClass, output_path: str) -> str:
        return cls.write_class(base_class, output_path, top_level=True)

def generate_doc_for_script(path: str, output_path: str) -> str:
    filename = os.path.basename(path)
    base, ext = os.path.splitext(filename)
    assert ext == ".gd", "Script should be a .gd file"

    with open(path, mode="r", encoding="utf-8") as hndl:
        contents = hndl.read()

    structure = ScriptStructure.parse_structure(path, base, contents)
    output = StructWriter.write(structure, output_path)
    return output

def scan_gdscript_files(path: str) -> List[str]:
    output = []

    for root, folders, files in os.walk(path):
        if ".git" in folders:
            folders.remove(".git")

        if "tests" in folders:
            folders.remove("tests")

        if "plugin.gd" in files:
            files.remove("plugin.gd")

        for f in files:
            base, ext = os.path.splitext(f)
            if ext == ".gd":
                output.append(os.path.join(root, f))

    output = sorted(output)
    return output

def generate_doc_for_paths(root: str, paths: List[str], output_path: str):
    tree = generate_file_tree(root, paths)
    output = generate_doc_for_tree(root, ".", tree, output_path)

    for k, v in output.items():
        full_path = os.path.normpath(os.path.join(output_path, k))
        print(f"Writing '{full_path}' ...")
        dirname = os.path.dirname(full_path)
        os.makedirs(dirname, exist_ok=True)
        with open(full_path, mode="w", encoding="utf-8") as hndl:
            hndl.write(v)

def generate_doc_for_tree(root: str, folder: str, tree: dict, output_path: str) -> dict:
    output = {}
    is_module = folder[0] == folder[0].upper()

    for key in tree:
        full_path = os.path.join(root, key)
        if os.path.isfile(full_path):
            base, _ext = os.path.splitext(full_path)
            doc_path = f"{base}.md"
            output[doc_path] = generate_doc_for_script(full_path, output_path)
        else:
            for k, v in generate_doc_for_tree(os.path.join(root, key), key, tree[key], output_path).items():
                output[k] = v

    if (not is_module or len(tree) > 1) and root != ".":
        readme_path = os.path.join(root, "readme.md")
        output[readme_path] = generate_folder_readme(folder, tree)

    return output

def generate_file_tree(root: str, paths: List[str]) -> dict:
    norm_root = os.path.normpath(root)
    tree = OrderedDict()

    for p in paths:
        path_without_root = os.path.relpath(p, norm_root)
        components = Path(path_without_root).parts
        first_comp = components[0]
        last_comp = components[-1]
        cursor = OrderedDict()

        if first_comp in tree:
            cursor = tree[first_comp]
        else:
            tree[first_comp] = cursor

        for component in components[1:-1]:
            if component in cursor:
                cursor = cursor[component]
            else:
                cursor[component] = OrderedDict()
                cursor = cursor[component]

        cursor[last_comp] = None

    return tree

def write_backbutton(*, same_level: bool) -> str:
    if same_level:
        link = "readme.md"
    else:
        link = "../readme.md"

    return f"**[◀️ Back]({link})**\n\n"

def generate_folder_readme(folder: str, tree: dict) -> str:
    if folder[0] == folder[0].upper():
        folder_cap = folder
    else:
        folder_cap = folder.capitalize()

    output = f"# {folder_cap}\n\n"
    output += write_backbutton(same_level=False)

    for key, value in tree.items():
        base, ext = os.path.splitext(key)
        base_cap = "".join((base[0].upper(), *base[1:]))

        # File
        if value is None:
            output += f"- [{base_cap}](./{base}.md)\n"
        elif key[0] == key[0].upper() and len(value) == 1:
            output += f"- [{base_cap}](./{base}/{base}.md)\n"
        else:
            output += f"- [{base_cap}](./{base}/readme.md)\n"

    return output

def main():
    parser = argparse.ArgumentParser("autodoc", description="generate documentation for a GDScript file")
    parser.add_argument("script_path", help="path to script")
    parser.add_argument("-o", "--output", help="output path")

    args = parser.parse_args()
    path = args.script_path
    output_path = args.output

    if os.path.isfile(path):
        data = generate_doc_for_script(args.script_path, output_path)
        with open(output_path, mode="w", encoding="utf-8") as hndl:
            hndl.write(data)
    else:
        files = scan_gdscript_files(path)
        generate_doc_for_paths(path, files, output_path)

main()
