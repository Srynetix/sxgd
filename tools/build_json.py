import argparse
import json
from pathlib import Path
from typing import Any, Union

JsonData = Union[dict[str, Any], list[Any]]


class GDScriptBuilder:
    _input_json: JsonData

    def __init__(self, input_json: JsonData) -> None:
        self._input_json = input_json

    def build(self) -> str:
        return (
            f"extends Object\n"
            f"\n"
            f"const DATA = {json.dumps(self._input_json, indent=4)}"
        )


def main():
    parser = argparse.ArgumentParser("Build a GDScript file from a JSON file")
    parser.add_argument("input_file", type=Path, help="Input JSON file")
    parser.add_argument("output_file", type=Path, help="Output GDScript file")
    args = parser.parse_args()

    input_file: Path = args.input_file
    output_file: Path = args.output_file

    with open(input_file, mode="r", encoding="utf-8") as fd:
        file_content = json.loads(fd.read())

    builder = GDScriptBuilder(file_content)
    output = builder.build()

    with open(output_file, mode="w", encoding="utf-8") as fd:
        fd.write(output)

    print(f"GDScript code generated at path '{output_file}'")


if __name__ == "__main__":
    main()
