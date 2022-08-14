from argparse import ArgumentParser
from dataclasses import dataclass
import os
from pathlib import Path
from typing import Dict, List
import re

FileDict = Dict[Path, str]

MISSING_VAR_TYPE_INFERENCE_RGX = re.compile(r"var\s+(?P<var>[a-zA-Z0-9-_]+)\s+=")
TYPE_DECLARATION_WITHOUT_AS_RGX = re.compile(r"var\s+(?P<var>[a-zA-Z0-9-_]+)\s*:\s*(?P<type>[a-zA-Z0-9-_]+)")

@dataclass
class LintError:
    error: str
    file: Path
    lineno: int
    col: int

    def __str__(self):
        return f"{self.file}:{self.lineno}:{self.col}: {self.error}"

def main() -> None:
    parser = ArgumentParser(description="Lint code")
    parser.add_argument("-i", "--ignore", default=[], dest="ignores", action="append", help="paths to ignore")
    args = parser.parse_args()
    base_dir = Path(os.getcwd())

    patterns = _build_patterns(args.ignores)
    code_dict = parse_all_code(base_dir, ignores=patterns)

    errors = check_rules(code_dict)
    errors_count = len(errors)

    if errors_count > 0:
        print(f"❌ {errors_count} error(s) found.")
        for error in errors:
            print(error)
    else:
        print("🎊 All good.")

def _build_patterns(ignores: List[str]) -> List[re.Pattern]:
    return [re.compile(ignore) for ignore in ignores]

def parse_all_code(base_dir: Path, *, ignores: List[re.Pattern]) -> FileDict:
    files_contents = {}

    for root, folder, files in os.walk(base_dir):
        for file in files:
            if not file.endswith(".gd"):
                # Ignore non .gd files
                continue

            path = Path(root) / Path(file)
            should_skip = False
            for ignore in ignores:
                if ignore.match(str(path)):
                    should_skip = True
                    break

            if should_skip:
                continue

            with open(path, mode="r", encoding="utf-8") as hndl:
                files_contents[path] = hndl.read()

    return files_contents


def check_rules(files: FileDict) -> List[LintError]:
    errors = []
    print(f"Checking {len(files)} files ...")

    for path, contents in files.items():
        errors.extend(_check_type_inference_file(path, contents))
        errors.extend(_check_type_declaration_without_as(path, contents))

    return errors

def _check_type_inference_file(path: Path, contents: str) -> List[LintError]:
    errors = []

    lines = contents.splitlines()
    for idx, line in enumerate(lines):
        lineno = idx + 1
        if line.startswith("#"):
            continue

        match = MISSING_VAR_TYPE_INFERENCE_RGX.search(line)
        if match:
            errors.append(LintError(
                error="Missing type inference",
                file=path.relative_to(os.getcwd()),
                lineno=lineno,
                col=match.start() + 1
            ))

    return errors

def _check_type_declaration_without_as(path: Path, contents: str) -> List[LintError]:
    errors = []

    lines = contents.splitlines()
    for idx, line in enumerate(lines):
        lineno = idx + 1
        if line.startswith("#"):
            continue

        match = TYPE_DECLARATION_WITHOUT_AS_RGX.search(line)
        if match:
            errors.append(LintError(
                error="Type declaration without 'as'",
                file=path.relative_to(os.getcwd()),
                lineno=lineno,
                col=match.start() + 1
            ))

    return errors

main()
