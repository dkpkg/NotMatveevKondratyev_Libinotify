# NotMatveevKondratyev_Libinotify

`NotMatveevKondratyev_Libinotify` packages the `libinotify-kqueue`
implementation for Darwin and a native Linux shim that preserves the
`NotMatveevKondratyev_Libinotify.Kqueue@0.20240724.0` package interface in split
repos.

The core package targets in this repository are:

- `NotMatveevKondratyev_Libinotify.Kqueue.Bundle@0.20240724.0`
- `NotMatveevKondratyev_Libinotify.Kqueue@0.20240724.0`

This repository was bootstrapped from the legacy package definitions copied into
`etc\dk\v`.

Local validation of the Darwin build recipe expects sibling checkouts of
`CommonsBase_GNU` and `CommonsBase_Std`.

## Testing and updating distribution scripts

```sh
./dk0 update

# Darwin
./dk0 -nosysinc --verbose distribute NotMatveevKondratyev_Libinotify-dist-Darwin_arm64 --library 'NotMatveevKondratyev_Libinotify@2.5.999911122233' --actual-in-place dist-Darwin_arm64.u
./dk0 -nosysinc --verbose distribute NotMatveevKondratyev_Libinotify-dist-Darwin_x86_64 --library 'NotMatveevKondratyev_Libinotify@2.5.999911122233' --actual-in-place dist-Darwin_x86_64.u

# Linux
./dk0 -nosysinc --verbose distribute NotMatveevKondratyev_Libinotify-dist-Linux_x86 --library 'NotMatveevKondratyev_Libinotify@2.5.999911122233' --actual-in-place dist-Linux_x86.u
./dk0 -nosysinc --verbose distribute NotMatveevKondratyev_Libinotify-dist-Linux_x86_64 --library 'NotMatveevKondratyev_Libinotify@2.5.999911122233' --actual-in-place dist-Linux_x86_64.u
./dk0 -nosysinc --verbose distribute NotMatveevKondratyev_Libinotify-dist-Linux_arm64 --library 'NotMatveevKondratyev_Libinotify@2.5.999911122233' --actual-in-place dist-Linux_arm64.u
```

For tag-driven GitHub Actions validation, push package-native tags like
`0.20240724.0-<timestamp>`.

## Linux shim notes

Linux outputs intentionally ship a tiny `libinotify` compatibility library built
from this repository's workspace assets. The shim exposes the expected
`libinotify` package surface while delegating filesystem notification syscalls to
native Linux inotify.

## Updating dk0 and dk0.cmd scripts

On Windows PowerShell (from the root of this repository):

```powershell
$ErrorActionPreference = "Stop"

$tmp = Join-Path $env:TEMP ("dk-" + [guid]::NewGuid().ToString())
git clone --depth 1 https://github.com/diskuv/dk.git $tmp

Copy-Item (Join-Path $tmp "dk0") -Destination ".\dk0" -Force
Copy-Item (Join-Path $tmp "dk0.cmd") -Destination ".\dk0.cmd" -Force

$dkVer = (Select-String -Path (Join-Path $tmp "dk0.cmd") -Pattern 'SET DK_VER=(.+)').Matches[0].Groups[1].Value.Trim()

Remove-Item $tmp -Recurse -Force

git commit -m "dk0 $dkVer" -- .\dk0 .\dk0.cmd
```
