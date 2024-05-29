build:
  dune build

test:
  dune exec -- test/test.exe

clean:
  dune clean

VERSION := "0.0.3"
NAME := "lzo-" + VERSION

release: clean
        dune-release tag v{{VERSION}} -m ''
        -dune-release lint
        dune-release distrib --skip-lint
        gpg -a -b _build/{{NAME}}.tbz -o {{NAME}}.tbz.asc
        dune-release publish distrib -m ""
        dune-release opam pkg
        dune-release opam submit -m ""
