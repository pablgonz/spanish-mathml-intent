## spanish-mathml-intent — Spanish MathML intent for accessible (tagged) PDF with LuaLaTeX

Release v1.2 \[2026-10-24\]

## Description

The <code>&langle;spanish-mathml-intent&rangle;</code> package adds MathML _intent_ to
mathematics written in Spanish with LuaLaTeX. The _intent_ attribute tells a
screen reader which concept an expression is and how to speak it, so that
NVDA with MathCAT reads the formulas correctly in accessible \(_tagged_\)
PDF documents. Its commands typeset and tag numbers, units, money, dates and
times, geometry, algebra and statistics, each with the Spanish reading it
should have. It is aimed at primary and secondary school teachers.

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

The <code>&langle;spanish-mathml-intent&rangle;</code> package is present in TeX Live, use
the package manager to install it (`tlmgr install spanish-mathml-intent`).

To try the development version, which may contain changes not yet released,
clone the repository and run `l3build install`:

```
$ git clone https://github.com/pablgonz/spanish-mathml-intent.git
$ cd spanish-mathml-intent
$ l3build install
```

## Examples

The file <code>&langle;spanish-mathml-intent.pdf&rangle;</code> contains attached examples,
which can be extracted from the PDF viewer or from the command line by
running:

```
$ pdfdetach -saveall spanish-mathml-intent.pdf
```

and then compile them with `lualatex-dev`.

## Other languages

The _intent_ attribute is not tied to Spanish. What belongs to this package is
the Spanish reading of each concept, written in the names of the intents, such
as `_valor-absoluto($x)`, and the set of commands for the school curriculum it
targets. A package for another language would keep the same idea, a command
that typesets an expression and annotates it with an intent, but would choose
its own intent names and its own commands.

The implementation in the manual follows the same order for every command:
variables, error messages, keys and internal functions, with the public command
at the end. The code written in Lua only parses the argument and sets variables
that expl3 reads. That order is meant to be reused, under the terms of the
LPPL. Anyone who wants to start a package for another language is welcome to
do so, as a separate package with its own name.

## AI-assisted development

Parts of this package were developed with the assistance of Anthropic's
Claude (large language model): code in the `.dtx` source, regression tests
and documentation drafts. The author reviewed every line of code and
documentation, and tested the package's functionality, including listening
to the output with NVDA and MathCAT, before release. The author is
responsible for all of its content. To the author's knowledge, no
third-party material was copied; the package is distributed under the LPPL.

## License

The <code>&langle;spanish-mathml-intent&rangle;</code> package may be modified and
distributed under the terms and conditions of the [LaTeX Project Public
License](https://www.latex-project.org/lppl/), version 1.3c or greater.

## Contents

- README.md \(this file\)
- spanish-mathml-intent.pdf \(documentation\)
- spanish-mathml-intent.dtx \(master file that produced all files\)
- spanish-mathml-intent.ins \(installer to extract all files\)

## Author and copyright

Copyright &#169; 2026 by Pablo González L <pablgonz@educarchile.cl>
