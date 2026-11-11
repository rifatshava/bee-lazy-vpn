import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from sign_bundle import sign_bundle


def repair_package(package, destination):
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="bee-repair-") as temporary:
        root = Path(temporary)
        expanded = root / "expanded"
        packages = root / "packages"
        packages.mkdir()
        subprocess.run(["pkgutil", "--expand-full", str(package.resolve()), str(expanded)], check=True)
        apps = [path for path in expanded.rglob("AmneziaVPN.app") if path.is_dir() and not path.is_symlink()]
        if len(apps) != 1:
            raise RuntimeError("Expected one Bee Lazy application")
        before = subprocess.run(["codesign", "--verify", "--all-architectures", "--deep", "--strict", str(apps[0])], capture_output=True, text=True)
        print("Original signature verification:", before.returncode, before.stderr, flush=True)
        sign_bundle(apps[0])
        for info in expanded.rglob("PackageInfo"):
            component = info.parent
            metadata = ET.parse(info).getroot()
            payload = component / "Payload"
            if not payload.exists():
                payload.mkdir()
            command = ["pkgbuild", "--root", str(payload), "--identifier", metadata.attrib["identifier"], "--version", metadata.get("version", "0"), "--install-location", metadata.get("install-location", "/")]
            scripts = component / "Scripts"
            if scripts.is_dir():
                command.extend(["--scripts", str(scripts)])
            command.append(str(packages / component.name))
            subprocess.run(command, check=True)
        command = ["productbuild", "--distribution", str(expanded / "Distribution"), "--package-path", str(packages)]
        resources = expanded / "Resources"
        if resources.is_dir():
            command.extend(["--resources", str(resources)])
        command.append(str(destination.resolve()))
        subprocess.run(command, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("package", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    repair_package(args.package, args.destination)
