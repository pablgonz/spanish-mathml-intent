## spintent — Spanish parse intent

Release v1.0 \[2026-10-16\]

## Description

The <code>&langle;spintent&rangle;</code> package provides a series of
utilities for primary and secondary school teachers who need to create
_accessible_ PDF documents \(_tagged_ PDF\) in Spanish using LuaLaTeX.

## Requirements

The minimum requirement is LaTeX release 2026-11-01. It loads and depends
on an updated version of [unicode-math](https://ctan.org/pkg/unicode-math).

The package [newcomputermodern](https://ctan.org/pkg/newcomputermodern) (font
`NewCMMath-Regular.otf`) is recommended: it is used for `\mathcal` and for the
right-angle symbol. If it is not found, a warning is issued and the loaded
math font is used.

## Further reading

For tagging (`\DocumentMetadata`, `tagging`, `tagging-setup`), see the
[documentation of the Tagging
Project](https://latex3.github.io/tagging-project/documentation/) (in
English). If you are new to LaTeX, [Learn
LaTeX](https://www.learnlatex.org/es/) (also available in Spanish) offers
short lessons with examples you can try online.

## Installation

The <code>&langle;spintent&rangle;</code> package is present in TeX Live, use
the package manager to install it (`tlmgr install spintent`).

To try the development version, which may contain changes not yet released,
clone the repository and run `l3build install`:

```
$ git clone https://github.com/pablgonz/spintent.git
$ cd spintent
$ l3build install
```

## Examples

The file <code>&langle;spintent.pdf&rangle;</code> contains attached examples,
which can be extracted from the PDF viewer or from the command line by
running:

```
$ pdfdetach -saveall spintent.pdf
```

and then compile them with `lualatex-dev`.

## AI-assisted development

Parts of this package were developed with the assistance of Anthropic's
Claude (large language model): code in the `.dtx` source, regression tests
and documentation drafts. The author reviewed every line of code and
documentation, and tested the package's functionality, including listening
to the output with NVDA and MathCAT, before release. The author is
responsible for all of its content. To the author's knowledge, no
third-party material was copied; the package is distributed under the LPPL.

## License

The <code>&langle;spintent&rangle;</code> package may be modified and
distributed under the terms and conditions of the [LaTeX Project Public
License](https://www.latex-project.org/lppl/), version 1.3c or greater.

## Contents

- README.md \(this file\)
- spintent.pdf \(documentation\)
- spintent.dtx \(master file that produced all files\)
- spintent.ins \(installer to extract all files\)

## Author and copyright

Copyright &#169; 2026 by Pablo González L <pablgonz@educarchile.cl>
