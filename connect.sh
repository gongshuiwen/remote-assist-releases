#!/usr/bin/env bash
# Interactive, temporary Agent launcher. Never installs a service or approves commands.
set -euo pipefail

tag='v0.2.1-m1'
base_url='https://github.com/gongshuiwen/remote-assist-releases/releases/download'
invite=''
usage() {
  cat <<'HELP'
Usage: bash connect.sh [--tag vX.Y.Z] [--base-url https://host/releases/download] [--invite URL]
Download and SHA-256-check the Agent before launching it in the foreground.
The customer approves the session locally. Each command needs local approval by
default; full access can only be selected locally for this temporary session.
--base-url is the parent path for <tag>/<asset>; use an authorized public mirror
when the source repository is private. The server URL comes from the invitation.
HELP
}
die() { echo "Remote Assist: $*" >&2; exit 1; }
while (( $# )); do
  case "$1" in
    --tag|--base-url|--invite)
      (( $# >= 2 )) || die "Missing value for $1"
      case "$1" in
        --tag) tag="$2" ;;
        --base-url) base_url="$2" ;;
        --invite) invite="$2" ;;
      esac
      shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done
[[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]] || die 'Specify a published version with --tag.'
[[ "$base_url" == https://* && "$base_url" != *'?'* && "$base_url" != *'#'* && "$base_url" != *'@'* ]] || die 'Download base must be a trusted HTTPS URL without credentials, query, or fragment.'
command -v curl >/dev/null || die 'curl is required.'
case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) die 'Only Linux and macOS are supported by this launcher.' ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=amd64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) die 'Unsupported CPU architecture.' ;;
esac
asset="assist-agent_${tag}_${os}_${arch}"
dir="$(mktemp -d "${TMPDIR:-/tmp}/remote-assist.XXXXXXXX")" || die 'Cannot create temporary directory.'
trap 'rm -rf "$dir"' EXIT
url="${base_url%/}/${tag}"
# curl fails closed on HTTP errors, including inaccessible private releases.
curl --proto '=https' --tlsv1.2 --fail --location --silent --show-error --retry 2 --output "$dir/SHA256SUMS" "$url/SHA256SUMS"
curl --proto '=https' --tlsv1.2 --fail --location --silent --show-error --retry 2 --output "$dir/$asset" "$url/$asset"
expected="$(awk -v f="$asset" '$2 == f { print $1 }' "$dir/SHA256SUMS")"
[[ "$expected" =~ ^[0-9a-f]{64}$ ]] || die 'Missing or invalid checksum entry.'
if command -v sha256sum >/dev/null; then
  actual="$(sha256sum "$dir/$asset" | awk '{ print $1 }')"
elif command -v shasum >/dev/null; then
  actual="$(shasum -a 256 "$dir/$asset" | awk '{ print $1 }')"
else
  die 'sha256sum or shasum is required.'
fi
[[ "$actual" == "$expected" ]] || die 'SHA-256 mismatch; refusing to run.'
chmod 700 "$dir/$asset"
echo 'Checksum verified. Please review the local authorization window.'
if [[ -n "$invite" ]]; then
  "$dir/$asset" --invite "$invite"
else
  "$dir/$asset"
fi
