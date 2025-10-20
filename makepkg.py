#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
from argparse import Namespace
from dataclasses import dataclass, field
from pathlib import Path

import tomllib


@dataclass
class Manifest:
    name: str = ""
    version: str = ""
    release: int = 1
    dependencies: list[str] = field(default_factory=list)
    source: str = ""

    def fullname(self) -> str:
        return f"{self.name}-{self.version}-{self.release}"


TMP = Path("/tmp/makepkg")

aliases = {"b": "build", "w": "wizard"}


def main() -> None:
    global TMP
    Path("/tmp/makepkg/sources").mkdir(parents=True, exist_ok=True)
    Path("/tmp/makepkg/builds").mkdir(parents=True, exist_ok=True)
    args = vars(parse_args())
    command: str = args.pop("command")
    TMP = Path(args.pop("tmp"))
    globals()[aliases.get(command, command)](**args)


def parse_args() -> Namespace:
    argparser = argparse.ArgumentParser()
    argparser.add_argument(
        "--tmp", help="Temporary directory to use", default="/tmp/makepkg"
    )
    subparsers = argparser.add_subparsers(dest="command")
    build = subparsers.add_parser("build", aliases=["b"], help="Build the package")
    build.add_argument("package", help="Name of the package to build")
    build.add_argument(
        "-i",
        "--interactive",
        action="store_true",
        help="Drop into an interactive shell instead of running the build script",
    )
    upload = subparsers.add_parser("upload", help="Upload new packages to index")
    upload.add_argument("destination", help="Destination to upload packages to")
    release = subparsers.add_parser("release", help="Generate and release a new index")
    release.add_argument("destination", help="Destination to upload index to")
    wizard = subparsers.add_parser(
        "wizard", aliases=["w"], help="Create a new package recipe"
    )
    wizard.add_argument("name", help="Name of the new package")
    wizard.add_argument("version", help="Version of the new package")
    wizard.add_argument(
        "-d", "--dependencies", nargs="*", help="List of package dependencies"
    )
    wizard.add_argument("-s", "--source", help="Source URL for the package")
    args = argparser.parse_args()
    if args.command is None:
        argparser.print_help()
        exit(1)
    return args


def build(package: str, interactive: bool) -> None:
    path = Path("recipes").absolute() / package
    with (path / "manifest.toml").open("rb") as f:
        manifest = Manifest(**tomllib.load(f))
    args = ["/usr/bin/wget", "-c", manifest.source]
    subprocess.run(args, check=True, cwd=TMP / "sources")
    source_name = manifest.source.rsplit("/", 1)[-1]
    output = subprocess.check_output(
        ["/usr/bin/tar", "-tf", source_name], cwd=TMP / "sources"
    )
    files = output.decode().splitlines()
    files.sort()
    source_stem = files[0].split("/", 1)[0]
    source_dir = TMP / "sources" / source_stem
    shutil.rmtree(source_dir, ignore_errors=True)
    args = ["/usr/bin/tar", "-xf", source_name]
    subprocess.run(args, check=True, cwd=TMP / "sources")
    build_dir = TMP / "builds" / manifest.fullname()
    shutil.rmtree(build_dir, ignore_errors=True)
    build_dir.mkdir(parents=True)
    for patch in path.glob("*.patch"):
        args = ["/usr/bin/patch", "-Np1", "-i", patch]
        subprocess.run(args, check=True, cwd=source_dir)
    if interactive:
        print("Entering interactive shell. Type 'exit' to continue the build process.")
        args = ["/usr/bin/bash", "-i"]
    else:
        args = ["/usr/bin/bash", "-e", path / "build.sh"]
    env = os.environ.copy()
    env["DESTDIR"] = build_dir.as_posix()
    subprocess.run(args, check=True, cwd=source_dir, env=env)
    build_name = manifest.fullname() + ".tar.zst"
    args = [
        "/usr/bin/tar",
        "-acf",
        TMP / "builds" / build_name,
        ".",
    ]
    subprocess.run(args, check=True, cwd=build_dir)
    args = [
        "/usr/bin/bash",
        "-c",
        f'/usr/bin/tar -tf "{build_name}" | cut -c2- | /usr/bin/tree --fromfile .\ndu -h "{build_name}"',
    ]
    subprocess.run(args, check=True, cwd=TMP / "builds")


def upload(destination: str) -> None:
    args = [
        "/usr/bin/rsync",
        "--no-motd",
        "--archive",
        "--update",
        "--human-readable",
        "--progress",
        "--include=*.tar.zst",
        "--exclude=*",
        f"{TMP}/builds/",
        destination,
    ]
    subprocess.run(args, check=True)


def release(destination: str) -> None:
    with (TMP / "index.toml").open("w") as f:
        for package in Path("recipes").glob("*/manifest.toml"):
            f.write(f"[{package.parent.name}]\n")
            f.write(package.read_text())
    args = [
        "/usr/bin/rsync",
        "--no-motd",
        "--archive",
        "--update",
        "--human-readable",
        "--progress",
        TMP / "index.toml",
        destination,
    ]
    subprocess.run(args, check=True)


def wizard(name: str, version: str, dependencies: list[str], source: str) -> None:
    path = Path("recipes") / name
    if path.exists():
        raise FileExistsError(f"Recipe for package '{name}' already exists.")
    path.mkdir(parents=True)
    with (path / "manifest.toml").open("w") as f:
        f.write(f'name = "{name}"\n')
        f.write(f'version = "{version}"\n')
        f.write("release = 1\n")
        deps = ", ".join(f'"{dep}"' for dep in dependencies or [])
        f.write(f"dependencies = [{deps}]\n")
        f.write(f'source = "{source or ""}"\n')
    with (path / "build.sh").open("w") as f:
        f.write("./configure --prefix=/usr\n")
        f.write("make\n")
        f.write("make install-strip\n")


if __name__ == "__main__":
    main()
