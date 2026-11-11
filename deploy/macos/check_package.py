import argparse
import os
from pathlib import Path
import subprocess
import tempfile
import time


def check_package(package, output, launch):
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="bee-package-") as temporary:
        expanded = Path(temporary) / "expanded"
        subprocess.run(["pkgutil", "--expand-full", str(package.resolve()), str(expanded)], check=True)
        apps = [path for path in expanded.rglob("AmneziaVPN.app") if path.is_dir() and not path.is_symlink()]
        if len(apps) != 1:
            raise RuntimeError("Expected one Bee Lazy application")
        bundle = apps[0]
        subprocess.run(["codesign", "--verify", "--all-architectures", "--deep", "--strict", "--verbose=2", str(bundle)], check=True)
        if not launch:
            return
        environment = dict(os.environ)
        environment["QT_LOGGING_RULES"] = "qt.qml.*=true"
        log = output / "startup.log"
        with log.open("wb") as stream:
            process = subprocess.Popen([str(bundle / "Contents/MacOS/AmneziaVPN")], stdout=stream, stderr=subprocess.STDOUT, env=environment)
            try:
                for _ in range(15):
                    time.sleep(1)
                    if process.poll() is not None:
                        raise RuntimeError(f"Application exited during startup: {process.returncode}")
                result = subprocess.run(["screencapture", "-x", str(output / "startup.png")])
                print("Screenshot result:", result.returncode)
            finally:
                process.terminate()
                try:
                    process.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()
        text = log.read_text(errors="replace")
        for marker in ["QQmlApplicationEngine failed to load", "TypeError:", "ReferenceError:", "is not a type"]:
            if marker in text:
                raise RuntimeError("QML startup error: " + marker)
        print("Final package signature verified; native application remained running for15seconds.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("package", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--launch", action="store_true")
    args = parser.parse_args()
    check_package(args.package, args.output, args.launch)
