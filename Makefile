TEX := Cheyan Resume.tex
OUT := Cheyan_Setayesh_Resume.pdf

.PHONY: pdf publish clean setup

pdf:
	tectonic --synctex --keep-logs --outdir build "$(TEX)"

publish: pdf
	cp "build/Cheyan Resume.pdf" "$(OUT)"

clean:
	rm -rf build

setup:
	./scripts/setup-macos.sh
