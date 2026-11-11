import argparse
from pathlib import Path
import subprocess


def run(*args):
    subprocess.run(args, check=True)


def sign_bundle(bundle):
    bundle = bundle.resolve()
    magics = {bytes.fromhex(value) for value in ["feedface", "cefaedfe", "feedfacf", "cffaedfe", "cafebabe", "bebafeca", "cafebabf", "bfbafeca"]}
    files = []
    for path in bundle.rglob("*"):
        if path.is_symlink() or not path.is_file():
            continue
        with path.open("rb") as stream:
            if stream.read(4) in magics or path.parent == bundle / "Contents/MacOS":
                if path != bundle / "Contents/MacOS/AmneziaVPN":
                    files.append(path)
    for path in sorted(files, key=lambda item: len(item.parts), reverse=True):
        run("codesign", "--force", "--sign", "-", "--timestamp=none", str(path))
    containers = [path for path in bundle.rglob("*") if path.is_dir() and not path.is_symlink() and path.suffix in {".framework", ".app", ".xpc"}]
    for path in sorted(containers, key=lambda item: len(item.parts), reverse=True):
        run("codesign", "--force", "--sign", "-", "--timestamp=none", str(path))
    run("codesign", "--force", "--sign", "-", "--timestamp=none", str(bundle))
    run("codesign", "--verify", "--all-architectures", "--deep", "--strict", "--verbose=2", str(bundle))
    print("Ad-hoc signature verified:", bundle.name, len(files), "Mach-O files", flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("bundle", type=Path)
    args = parser.parse_args()
    sign_bundle(args.bundle)
