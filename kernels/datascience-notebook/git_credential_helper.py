#!/usr/bin/env python3
"""
This script is used as a Git credential helper https://git-scm.com/docs/git-credential.
We iterate through all the git credential secrets on the file system and return the first one that matches the requested URL. 
If no match is found, we return an empty response.
An empty response will cause Git to use the next credential helper in the list, or prompt the user for credentials.

To test this script:

$ cat > /tmp/demo.git-cred <<EOF
{
    "meta": {
        "type": "USERNAME_PASSWORD",
        "host": "github.com",
        "protocol": "https",
        "path": "foo/bar"
    },
    "data": {
        "username": "demo",
        "password": "demo_password"
    }
}
EOF
$ export NTBL_SECRETS_DIR=/tmp
$ echo -e "host=github.com\nprotocol=https\npath=foo/bar" | ./git_credential_helper.py 
username=demo
password=demo_password
"""

import json
from pathlib import Path
import sys
import os
from typing import Optional


def parse_input(input_: str) -> dict:
    """Parse the input from Git into a dictionary."""
    return dict(line.split("=", 1) for line in input_.splitlines())


def format_output(data: dict) -> str:
    """Format the output to Git."""
    return "\n".join(f"{key}={value}" for key, value in data.items())


def find_secret(input_data: dict) -> Optional[dict]:
    """Find the secret that matches the input data."""
    secrets_dir = Path(os.environ.get("NTBL_SECRETS_DIR", "/vault/secrets"))
    if not secrets_dir.exists():
        return None

    keys_to_match = ["host", "protocol", "path"]
    for secret_path in secrets_dir.glob("*.git-cred"):
        secret_data = json.loads(secret_path.read_text())
        meta = secret_data["meta"]
        if all(meta[key] == input_data.get(key) for key in keys_to_match):
            return secret_data["data"]

    return None


def main(stdin=sys.stdin, stdout=sys.stdout):
    """Main entrypoint."""
    parsed_input = parse_input(stdin.read())
    if (secret := find_secret(parsed_input)) is not None:
        print(format_output(secret), file=stdout)


if __name__ == "__main__":
    main()
