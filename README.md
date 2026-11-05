# Cheyans.github.io

My personal site and resume. The resume source is `Cheyan Resume.tex`, built from the Deedy template with XeLaTeX.

## Set up a Mac

Run this once on a new Mac, from the repo folder:

```
./scripts/setup-macos.sh
```

It installs each of these, or skips it if it is already there:

- Homebrew
- Tectonic, the LaTeX engine
- Visual Studio Code and the `code` command
- The VS Code extensions in `.vscode/extensions.json` (LaTeX Workshop and Code Spell Checker)

Then it builds the resume once, so the LaTeX packages are downloaded and cached. You can run it again at any time.

## Edit the resume

1. Run `code .` to open the repo in VS Code.
2. Open `Cheyan Resume.tex` and save with Cmd+S. VS Code builds `build/Cheyan Resume.pdf`.
3. Press Cmd+Option+V to open the PDF next to the source. Cmd+click in the PDF jumps to that line in the source.

## Build from the terminal

- `make` builds `build/Cheyan Resume.pdf`.
- `make publish` copies the PDF to `Cheyan_Setayesh_Resume.pdf`, the file the site shows.
- `make clean` removes the `build` folder.
- `make setup` runs the setup script.

## Template files

`deedy-resume-openfont.cls` and the `fonts` folder come from the Overleaf project. The build needs them, so keep them in the repo.
