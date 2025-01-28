build:
	dune build
exec: build
	dune exec bin/producer_consumer_problem.exe
install:
	opam install . --deps-only --working-dir
test:
	dune runtest

.PHONY: build exec install test
