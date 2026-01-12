build:
	@dune build --profile release
	@rm -f unisam
	@cp _build/install/default/bin/unisam .

clean:
	@dune clean
	
fmt:
	@dune fmt
.PHONY: build