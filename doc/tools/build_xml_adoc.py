#!/usr/bin/env python3

import argparse
from dataclasses import dataclass
from io import StringIO
import sys
from typing import IO, Any, Dict, List, Optional, Set, Union
import xml.etree.ElementTree as ET
import textwrap
from pathlib import Path
import os


def strip_ws(text: str):
    return textwrap.dedent(text).strip()


@dataclass
class ArgumentDef:
    name: str
    type: str
    default: Any

    @classmethod
    def parse_argument_def(cls, element: ET.Element):
        return cls(
            name=element.attrib["name"],
            type=element.attrib["type"],
            default=element.attrib.get("default")
        )


@dataclass
class ConstantDef:
    name: str
    value: Any
    description: str


@dataclass
class EnumDef:
    name: str
    values: List[ConstantDef]


@dataclass
class Constants:
    enums: List[EnumDef]
    constants: List[ConstantDef]

    @classmethod
    def empty(cls):
        return cls(enums=[], constants=[])

    @classmethod
    def parse_constants(cls, element: ET.Element):
        enum_defs = {}
        constant_defs = []

        constant_nodes = element.findall("constant")
        for constant in constant_nodes:
            enum_name = constant.attrib.get("enum")
            if enum_name:
                if enum_name not in enum_defs:
                    enum_defs[enum_name] = EnumDef(name=enum_name, values=[])

                enum_def = enum_defs[enum_name]
                enum_def.values.append(
                    ConstantDef(
                        name=constant.attrib["name"],
                        value=constant.attrib["value"],
                        description=strip_ws(constant.text)
                    )
                )
            else:
                constant_defs.append(
                    ConstantDef(
                        name=constant.attrib["name"],
                        value=constant.attrib["value"],
                        description=strip_ws(constant.text)
                    )
                )

        return cls(
            enums=list(enum_defs.values()),
            constants=constant_defs
        )


@dataclass
class MemberDef:
    name: str
    return_type: str
    description: str
    default_value: Any

    @classmethod
    def parse_member_def(cls, element: ET.Element):
        return cls(
            name=element.attrib["name"],
            return_type=element.attrib["type"],
            description=strip_ws(element.text),
            default_value=element.attrib.get("default")
        )


@dataclass
class SignalDef:
    name: str
    arguments: List[ArgumentDef]
    description: str

    @classmethod
    def parse_signal_def(cls, element: ET.Element):
        return cls(
            name=element.attrib["name"],
            arguments=[ArgumentDef.parse_argument_def(e) for e in element.findall("argument")],
            description=strip_ws(element.find("description").text)
        )


@dataclass
class MethodDef:
    name: str
    qualifiers: Optional[str]
    return_type: str
    arguments: List[ArgumentDef]
    description: str

    @classmethod
    def parse_method_def(cls, element: ET.Element):
        return cls(
            name=element.attrib["name"],
            qualifiers=element.attrib.get("qualifiers", None),
            return_type=element.find("return").attrib["type"],
            arguments=[ArgumentDef.parse_argument_def(e) for e in element.findall("argument")],
            description=strip_ws(element.find("description").text)
        )


@dataclass
class ClassDef:
    name: str
    inherits: str
    brief_description: Optional[str]
    description: str
    constants: Constants
    classes: List["ClassDef"]
    methods: List[MethodDef]
    members: List[MemberDef]
    signals: List[SignalDef]

    @classmethod
    def parse_class_def(cls, element: ET.Element):
        classes = []
        methods = []
        members = []
        signals = []
        constants = Constants.empty()
        classes_node = element.find("classes")
        methods_node = element.find("methods")
        members_node = element.find("members")
        constants_node = element.find("constants")
        signals_node = element.find("signals")

        if classes_node is not None:
            classes = [
                cls.parse_class_def(e)
                for e in classes_node.findall("class")
            ]

        if methods_node is not None:
            methods = [
                MethodDef.parse_method_def(e)
                for e in methods_node.findall("method")
            ]

        if members_node is not None:
            members = [
                MemberDef.parse_member_def(e)
                for e in members_node.findall("member")
            ]

        if constants_node is not None:
            constants = Constants.parse_constants(constants_node)

        if signals_node is not None:
            signals = [
                SignalDef.parse_signal_def(e)
                for e in signals_node.findall("signal")
            ]

        brief_description = None
        brief_description_node = element.find("brief_description")
        if brief_description_node is not None:
            brief_description = strip_ws(brief_description_node.text)

        description = "No description."
        description_node = element.find("description")
        if description_node is not None:
            description = strip_ws(description_node.text)

        return cls(
            name=element.attrib["name"],
            inherits=element.attrib.get("inherits", "Node"),
            brief_description=brief_description,
            description=description,
            classes=classes,
            constants=constants,
            methods=methods,
            members=members,
            signals=signals
        )


@dataclass
class Context:
    known_names: Set[str]
    standard_names: Set[str]
    known_classes: Dict[Path, ClassDef]

    @classmethod
    def load_context_from_path(cls, path: Path):
        known_classes = {}
        standard_names = {
            "void"
        }
        known_names = set()

        for xml_file in os.listdir(path):
            xml_file_path = path / xml_file
            cdef = read_classdef_from_xmlfile(xml_file_path)
            known_classes[xml_file_path] = cdef
            known_names.add(cdef.name)

            for c in cdef.classes:
                known_names.add(c.name)

        return cls(
            known_names=known_names,
            standard_names=standard_names,
            known_classes=known_classes
        )

    def convert_to_adoc(self):
        os.makedirs(Path(os.getcwd()) / "classes", exist_ok=True)
        sorted_paths = sorted(list(self.known_classes.keys()))

        for path in sorted_paths:
            cdef = self.known_classes[path]
            stream = StringIO()
            writer = ADocWriter(stream=stream, known_names=self.known_names, standard_names=self.standard_names)
            writer.write_class_def(cdef)

            output_stream = stream.getvalue()
            output_path = (
                Path(os.getcwd())
                / "classes"
                / path.with_suffix(".adoc").name
            )

            with open(output_path, mode="w", encoding="utf-8") as f:
                f.write(output_stream)
            print(f"AsciiDoc written to {output_path}.")


class ADocWriter:
    def __init__(self, *, stream: IO, known_names: Set[str], standard_names: Set[str]):
        self.stream = stream
        self.known_names = known_names
        self.standard_names = standard_names

    def write_class_def(self, cdef: ClassDef, *, indent: int = 3):
        self.stream.write(f"{'=' * indent} {cdef.name}\n\n")
        self.stream.write(f"*Inherits: {self._write_type(cdef.inherits)}*\n\n")
        if cdef.brief_description:
            self.stream.write(f"{cdef.brief_description}\n\n")
        self.stream.write(f"Description::\n    {cdef.description}\n\n")
        self._write_signals_descriptions(cdef, indent + 1)
        self._write_constants(cdef, indent + 1)
        self._write_members_table(cdef, indent + 1)
        self._write_methods_table(cdef, indent + 1)
        self._write_members_descriptions(cdef, indent + 1)
        self._write_methods_descriptions(cdef, indent + 1)

        if cdef.classes:
            self.stream.write("\n\n")
            self._write_inner_classes(cdef, indent=indent)

    def _build_section_hash(self, cdef: ClassDef, section: str) -> str:
        return "_" + "_".join((cdef.name.lower(), section)).replace(".", "_")

    def _build_method_hash(self, cdef: ClassDef, method: MethodDef) -> str:
        return "_" + "_".join((cdef.name.lower(), "method", method.name.lower())).replace(".", "_")

    def _build_method_header(self, cdef: ClassDef, method: MethodDef, *, include_type: bool = False, include_link: bool = False) -> str:
        stream = StringIO()
        if method.qualifiers:
            stream.write(f"{method.qualifiers} ")
        if include_type:
            stream.write(f"{self._write_type(method.return_type)} ")

        if include_link:
            stream.write(f"<<{self._build_method_hash(cdef, method)},{method.name}>> ")
        else:
            stream.write(f"{method.name} ")

        stream.write(self._get_arguments_str(method.arguments))
        return stream.getvalue()

    def _build_member_hash(self, cdef: ClassDef, member: MemberDef) -> str:
        return "_" + "_".join((cdef.name.lower(), "member", member.name.lower())).replace(".", "_")

    def _build_member_header(self, cdef: ClassDef, member: MemberDef, *, include_type: bool = False, include_link: bool = False) -> str:
        stream = StringIO()
        if include_type:
            stream.write(f"{self._write_type(member.return_type)} ")

        if include_link:
            stream.write(f"<<{self._build_member_hash(cdef, member)},{member.name}>>")
        else:
            stream.write(member.name)
        return stream.getvalue()

    def _build_signal_hash(self, cdef: ClassDef, signal: SignalDef) -> str:
        return "_" + "_".join((cdef.name.lower(), "signal", signal.name.lower())).replace(".", "_")

    def _build_signal_header(self, cdef: ClassDef, signal: SignalDef) -> str:
        stream = StringIO()
        stream.write(f"{signal.name} {self._get_arguments_str(signal.arguments)}")
        return stream.getvalue()

    def _get_arguments_str(self, arguments: List[ArgumentDef]) -> str:
        stream = StringIO()
        stream.write("(")
        arg_count = len(arguments)
        for idx, argument in enumerate(arguments):
            stream.write(f" {self._write_type(argument.type)} {argument.name}")
            if argument.default:
                stream.write(f" = {argument.default}")
            if idx != arg_count - 1:
                stream.write(",")
            else:
                stream.write(" ")
        stream.write(")")
        return stream.getvalue()

    def _write_inner_classes(self, cdef: ClassDef, indent: int):
        for kls in cdef.classes:
            self.write_class_def(kls, indent=indent)

    def _write_type(self, type: str):
        if type in self.known_names:
            return f"<<_{type.lower().replace('.', '_')}>>"
        elif type in self.standard_names:
            return type
        elif "." in type:
            ftype = type.split(".")[0]
            if ftype in self.known_names:
                return f"<<_{ftype.lower().replace('.', '_')},{type}>>"
            else:
                return type
        else:
            return f"https://docs.godotengine.org/en/stable/classes/class_{type.lower()}.html#{type.lower()}[{type}^]"

    def _write_constants(self, cdef: ClassDef, indent: int):
        if cdef.constants.enums:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'enumerations')}]\n")
            self.stream.write(f"{'=' * indent} Enumerations\n\n")

            for enum in cdef.constants.enums:
                self.stream.write(f"enum *{enum.name}*:\n\n")
                for v in enum.values:
                    self.stream.write(f"* *{v.name} = {v.value}* --- {v.description}\n")
                self.stream.write("\n")

        if cdef.constants.constants:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'constants')}]\n")
            self.stream.write(f"{'=' * indent} Constants\n\n")
            for c in cdef.constants.constants:
                self.stream.write(f"* *{c.name} = {c.value}* --- {c.description}\n")
            self.stream.write("\n")

    def _write_methods_table(self, cdef: ClassDef, indent: int):
        if cdef.methods:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'methods')}]\n")
            self.stream.write(f"{'=' * indent} Methods\n\n")
            self.stream.write("[cols=\"1,2\"]\n")
            self.stream.write("|===\n")
            for method in cdef.methods:
                self.stream.write(f"|`{self._write_type(method.return_type)}`\n")
                self.stream.write(f"|`{self._build_method_header(cdef, method, include_link=True)}`\n")
            self.stream.write("|===\n\n")

    def _write_members_table(self, cdef: ClassDef, indent: int):
        if cdef.members:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'properties')}]\n")
            self.stream.write(f"{'=' * indent} Properties\n\n")
            self.stream.write("[cols=\"1,2,1\"]\n")
            self.stream.write("|===\n")
            for member in cdef.members:
                self.stream.write(f"|`{self._write_type(member.return_type)}`\n")
                self.stream.write(f"|`{self._build_member_header(cdef, member, include_link=True)}`\n")
                self.stream.write(f"|`{member.default_value}`\n")
            self.stream.write("|===\n\n")

    def _write_members_descriptions(self, cdef: ClassDef, indent: int):
        if cdef.members:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'property_descriptions')}]\n")
            self.stream.write(f"{'=' * indent} Property Descriptions\n\n")
            members_count = len(cdef.members)
            for idx, member in enumerate(cdef.members):
                self.stream.write(f"[#{self._build_member_hash(cdef, member)}]\n")
                self.stream.write(f"* `{self._build_member_header(cdef, member, include_type=True)}`\n+\n")
                self.stream.write(f"{member.description}")
                if idx != members_count - 1:
                    self.stream.write("\n\n")
            self.stream.write("\n\n")

    def _write_methods_descriptions(self, cdef: ClassDef, indent: int):
        if cdef.methods:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'method_descriptions')}]\n")
            self.stream.write(f"{'=' * indent} Method Descriptions\n\n")
            methods_count = len(cdef.methods)
            for idx, method in enumerate(cdef.methods):
                self.stream.write(f"[#{self._build_method_hash(cdef, method)}]\n")
                self.stream.write(f"* `{self._build_method_header(cdef, method, include_type=True)}`\n+\n")
                self.stream.write(f"{method.description}")
                if idx != methods_count - 1:
                    self.stream.write("\n\n")
            self.stream.write("\n\n")

    def _write_signals_descriptions(self, cdef: ClassDef, indent: int):
        if cdef.signals:
            self.stream.write(f"[#{self._build_section_hash(cdef, 'signals')}]\n")
            self.stream.write(f"{'=' * indent} Signals\n\n")
            signals_count = len(cdef.signals)
            for idx, signal in enumerate(cdef.signals):
                self.stream.write(f"[#{self._build_signal_hash(cdef, signal)}]\n")
                self.stream.write(f"* `{self._build_signal_header(cdef, signal)}`\n+\n")
                self.stream.write(f"{signal.description}")
                if idx != signals_count - 1:
                    self.stream.write("\n\n")
            self.stream.write("\n\n")


def read_classdef_from_xmlfile(path: Path) -> ClassDef:
    with open(path, mode="r", encoding="utf-8") as f:
        xml_contents = f.read()
        root = ET.fromstring(xml_contents)
        return ClassDef.parse_class_def(root)


def convert_all_classes_to_adoc():
    xml_path = Path(os.getcwd()) / "classes_xml"
    context = Context.load_context_from_path(xml_path)
    context.convert_to_adoc()


def generate_index():
    stream = StringIO()
    index_path = Path(os.getcwd()) / "classes" / "index.adoc"
    xml_path = Path(os.getcwd()) / "classes_xml"
    for xml_file in sorted(os.listdir(xml_path)):
        adoc_path = Path(xml_file).with_suffix(".adoc").name
        stream.write(f"include::./{adoc_path}[]\n\n")
        stream.write("'''\n\n")

    with open(index_path, mode="w", encoding="utf-8") as f:
        f.write(stream.getvalue())


parser = argparse.ArgumentParser(description="Convert XML class to .adoc")
parser.add_argument("--all", help="build all XML classes", action="store_true")
parser.add_argument("--index", help="build XML classes index", action="store_true")

args = parser.parse_args()

if not args.all and not args.index:
    parser.print_help()
    sys.exit(1)

if args.all:
    convert_all_classes_to_adoc()
    generate_index()
elif args.index:
    generate_index()
