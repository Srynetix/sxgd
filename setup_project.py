#!/usr/bin/env python3

# Setup a dummy project to develop and test sxgd.

from argparse import ArgumentParser
from pathlib import Path
import os
import shutil
import textwrap

BASE_DIR = Path(__file__).parent
DUMMY_PROJECT_GODOT = textwrap.dedent(
    """; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=4

[application]

config/name="sxgd dummy project"
config/description="sxgd dummy project"
run/main_scene="res://Dummy.tscn"

[debug]

gdscript/warnings/return_value_discarded=false
gdscript/warnings/unsafe_property_access=true
gdscript/warnings/unsafe_method_access=true
gdscript/warnings/unsafe_call_argument=true

[editor_plugins]

enabled=PoolStringArray( "res://addons/sxgd/plugin.cfg" )
"""
)
DUMMY_MAIN_SCENE = textwrap.dedent(
    """[gd_scene format=2]

[node name="Dummy" type="Node"]
"""
)


def main() -> None:
    parser = ArgumentParser(
        description="Setup a dummy project to develop and test sxgd"
    )
    parser.add_argument("path", help="project location")
    args = parser.parse_args()

    target_path = Path(args.path)
    if target_path.exists():
        raise RuntimeError(f"Path {target_path} already exists.")

    setup_project_at_path(target_path)


def setup_project_at_path(path: Path) -> None:
    os.makedirs(path)

    # Create a "Godot project" file
    with open(path / "project.godot", mode="w", encoding="utf-8") as f:
        f.write(DUMMY_PROJECT_GODOT)

    # Create an "addons" directory
    os.makedirs(path / "addons")

    # Copy this folder in "addons/sxgd"
    shutil.copytree(BASE_DIR, path / "addons" / "sxgd")

    # Copy a dummy scene
    with open(path / "Dummy.tscn", mode="w", encoding="utf-8") as f:
        f.write(DUMMY_MAIN_SCENE)

    print(f"Dummy project built at '{path}'.")


main()
