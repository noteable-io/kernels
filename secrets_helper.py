"""
This script helps inject Secrets into the Kernel environment.
The Vault Agent will volume mount files into the Kernel container
at /vault/secrets.  Noteable Secrets will be in .env suffix files.
We want to parse all those files and export them as environment variables
in the bash script that kicks off the Kernel (ipykernel_launcher etc).
Doing that scripting in bash is a pain, so we do it in Python here and
bash just does an `eval` on the output.
Some defensive programming to highlight:
 - Env vars in the output are all uppercased
 - If an env var is already set, we don't overwrite it
 - We use shlex to quote the output so bash eval does not cause nasty side effects
"""
import os
import pathlib
import shlex

output = []

secrets_directory = os.environ.get("VAULT_SECRETS_PATH", "/vault/secrets")

directory = pathlib.Path(secrets_directory)
if directory.exists():
    for file in directory.glob("*.env"):
        name = file.stem.upper()
        if name not in os.environ:
            content = file.read_text()
            output.append(f"export {name}={shlex.quote(content)}")

print("\n".join(output))