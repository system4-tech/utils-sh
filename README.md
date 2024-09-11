# [`utils.sh`](utils.sh)

This repository contains shell utility programs.

## Usage

## Import

```sh
wget https://raw.githubusercontent.com/system4-tech/utils-sh/main/utils.sh
source utils.sh
```

## Logging

```sh
level=info
command || level=error
log.$level message
```

See [tests](tests/) for more examples.
