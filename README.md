# Vórtex Typst Template

A Typst template for articles submitted to the **Revista Vórtex** (Universidade Estadual do Paraná – UNESPAR).

This project reproduces the journal's official layout and formatting requirements while providing a modern, reproducible workflow based on Typst.

> **Status:** Work in progress. The template is under active development and may change before the first stable release.

---

## Features

- Complete article template for Revista Vórtex
- ABNT-compatible citation workflow using CSL and BibLaTeX
- Configurable title page
- Automatic running headers and footers
- First-page metadata
- Long quotation environment
- Footnotes
- Figure, table and musical example support
- Typography based on the official journal guidelines
- HTML and PDF compilation support (experimental for HTML)

---

## Installation

Clone this repository:

```bash
git clone https://github.com/<user>/vortex.git
```

or install it as a local Typst package.

---

## Requirements

- Typst ≥ 0.14
- EB Garamond
- Cambria (optional, used in journal headers)

Fonts can be supplied locally:

```bash
typst compile main.typ \
    --font-path ./fonts
```

or

```bash
typst watch main.typ main.pdf \
    --font-path ./fonts
```

---

## Basic Usage

```typst
#import "vortex.typ": *

#show: doc => vortex(
  title: [My Article],
  blind-review: true,
  authors: (
    (
      name: "John Doe",
      affiliation: "University",
      orcid: "0000-0000-0000-0000",
      email: "john@example.com",
    ),
  ),
)

= Introduction

Your article starts here.
```

---

## Bibliography

Use a BibTeX file together with a CSL style.

```typst
#bibliography(
  "references.bib",
  style: "abnt.csl",
)
```

Example citation:

```typst
@liskov_programming_1974
```

or

```typst
#cite(<liskov_programming_1974>)
```

---

## Figures

```typst
#figure(
  image("figure.png"),
  caption: [Figure 1 – Caption. Source: Author.]
)
```

The template formats captions according to the journal guidelines.

---

## Long Quotations

```typst
#vortex-long-citation[
Lorem ipsum dolor sit amet...
]
```

The environment automatically uses:

- 10 pt font
- single line spacing
- left indentation

---

## Journal Requirements

The template follows the official author guidelines whenever possible.

### General

- A4 paper
- 2 cm top/bottom margins
- 2.5 cm left/right margins
- 1.5 line spacing
- justified text
- 1 cm first-line indentation

### Title

- maximum 90 characters

### Abstract

- maximum 150 words

### Keywords

- maximum 5 keywords

### Articles

- up to 10,000 words

### Citations

- ABNT NBR 10520:2023

### References

- ABNT NBR 6023:2018/2020

---

## Current Status

Implemented:

- page layout
- typography
- title page
- running headers
- footers
- bibliography
- long quotations
- figures
- footnotes

Planned:

- complete accessibility support
- automatic metadata generation
- additional article types
- package publication in Typst Universe

---

## Repository Structure

```
.
├── examples/
├── fonts/
├── images/
├── vortex.typ
├── abnt.csl
└── README.md
```

---

## How to Compile Example?

```
typst compile examples/article.typ --root .
```

## License

This project is distributed under the MIT License.

The journal layout and branding remain the property of **Revista Vórtex** and **Universidade Estadual do Paraná (UNESPAR)**.

---

## Disclaimer

This is an independent Typst implementation of the Revista Vórtex author template.

It is **not** an official project of Revista Vórtex or UNESPAR. Authors remain responsible for ensuring that submitted manuscripts comply with the journal's current author guidelines.
