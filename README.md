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
level=notice
command || level=error
log.$level message
```

## HTTP

```sh
http.get "https://httpbin.org/get"
http.post "https://httpbin.org/post" "data=example"
```

## Download

```sh
download "https://example.com/file[1-4].txt" "file#1.txt"
download "ftp://ftp.example.com/archive[2020-2024]/file[1-100].txt" "file#1_#2.txt"
```

See [tests](tests/) for more examples.
