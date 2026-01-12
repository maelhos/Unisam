build:
	@dune build --profile release
	@ln -s _build/install/default/bin/unisam unisam

clean:
	@dune clean
	
fmt:
	@dune fmt
.PHONY: build
