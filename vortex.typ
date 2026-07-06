#import "@preview/droplet:0.3.1": dropcap

//╭─────────────────────────────────────╮
//│               DROPCAP               │
//╰─────────────────────────────────────╯
#let vortex-dropcap(body) = {
  block(width: 100%)[
    #set par(
      justify: true,
      leading: 1.5em,
      spacing: 0cm,
      first-line-indent: 0pt,
    )
    #dropcap(
      height: 3,
      gap: 0.25em,
      hanging-indent: 0pt,
    )[#body]
  ]
  v(1.5em)
}

//╭─────────────────────────────────────╮
//│         Vortex Bibliography         │
//╰─────────────────────────────────────╯
#let vortex-bibliography(
  bib,
  style: "./assets/bibliography/abnt.csl",
) = {
  set par(
    leading: 1em,
    spacing: 2em,
    first-line-indent: 0pt,
  )

  bibliography(
    bib,
    style: style,
    title: "REFERENCES",
  )
}

//╭─────────────────────────────────────╮
//│            Long Citation            │
//╰─────────────────────────────────────╯
#let vortex-long-citation(body) = {
  block(
    inset: (left: 12em),
  )[
    #set text(
      font: "EB Garamond",
      size: 10pt,
    )
    #set par(
      leading: 0.5em,
      first-line-indent: 0pt,
      justify: true,
    )

    #v(1em)
    #body
    #v(1em)
  ]
}

#let vortex-cite-text(author, key) = [#author (#cite(key, form: "year"))]

//╭─────────────────────────────────────╮
//│             Vortex Image            │
//╰─────────────────────────────────────╯
#let vortex-document-lang = state("vortex-document-lang", "pt")
#let vortex-image-counter = counter("vortex-image")
#let vortex-table-counter = counter("vortex-table")

#let vortex-has-content(value) = value != []

#let vortex-labels(lang) = {
  let is-portuguese = lang == "pt" or lang == "pt-br"
  let is-spanish = lang == "es" or lang.starts-with("es-")
  if is-portuguese {
    (
      figure-caption: "FIGURA",
      figure-reference: "Figura",
      table-caption: "TABELA",
      table-reference: "Tabela",
      source: "Fonte",
    )
  } else {
    (
      figure-caption: "FIGURE",
      figure-reference: "Figure",
      table-caption: "TABLE",
      table-reference: "Table",
      source: if is-spanish { "Fuente" } else { "Source" },
    )
  }
}

#let vortex-image(
  body,
  caption: [],
  source: [],
  width: 100%,
  ref: none,
  frame: false,
) = {
  let image-body = if type(body) == str {
    image(body, width: 100%)
  } else {
    body
  }

  context {
    let lang = vortex-document-lang.get()
    let labels = vortex-labels(lang)
    let number = vortex-image-counter.get().first() + 1
    let caption-reference = labels.figure-caption + " " + str(number)
    let inline-reference = labels.figure-reference + " " + str(number)

    v(1em)

    block(width: 100%, breakable: false)[
      #set par(
        first-line-indent: 0pt,
        justify: false,
        leading: 0.6em,
      )

      #set text(size: 10pt)

      #if ref != none {
        [
          #metadata((
            kind: "vortex-image",
            reference: inline-reference,
          )) #ref
        ]
      }

      #vortex-image-counter.step()
      #align(center)[
        #caption-reference – #caption
      ]

      #v(0.5em)

      #align(center)[
        #box(width: width)[
          #if frame {
            box(width: 100%, stroke: rgb("#c8c8c8"), inset: 0pt)[#image-body]
          } else {
            image-body
          }
        ]
      ]

      #v(0.5em)

      #align(center)[
        #labels.source: #source
      ]
    ]

    v(1em)
  }
}

//╭─────────────────────────────────────╮
//│             Vortex Table            │
//╰─────────────────────────────────────╯
#let vortex-table(
  body,
  caption: [],
  source: [],
  width: 100%,
  ref: none,
  frame: false,
) = {
  context {
    let lang = vortex-document-lang.get()
    let labels = vortex-labels(lang)
    let number = vortex-table-counter.get().first() + 1
    let caption-reference = labels.table-caption + " " + str(number)
    let inline-reference = labels.table-reference + " " + str(number)

    v(1em)

    block(width: 100%, breakable: false)[
      #set par(
        first-line-indent: 0pt,
        justify: false,
        leading: 0.6em,
      )

      #set text(size: 10pt)

      #let table-body = if body.func() == table {
        let strong-rule = 1.2pt + black
        let light-rule = 0.4pt + rgb("#ffffff")
        let fields = body.fields()
        let children = fields.remove("children")
        let columns = fields.at("columns")
        if columns.all(column => column == auto) {
          fields.insert("columns", columns.map(column => 1fr))
        }
        children.push(table.hline(stroke: .5pt + black))

        [
          #set table(
            align: center,
            inset: (x: 4pt, y: 2pt),
            stroke: (x, y) => (
              left: light-rule,
              right: light-rule,
              top: if y == 0 { strong-rule } else { none },
              bottom: if y == 0 { strong-rule } else { light-rule },
            ),
          )
          #table(..fields, ..children)
        ]
      } else {
        body
      }

      #if ref != none {
        [
          #metadata((
            kind: "vortex-table",
            reference: inline-reference,
          )) #ref
        ]
      }

      #vortex-table-counter.step()
      #align(center)[
        #caption-reference – #caption
      ]

      #v(0.5em)

      #align(center)[
        #box(width: width)[
          #if frame {
            box(width: 100%, stroke: rgb("#c8c8c8"), inset: 0pt)[#table-body]
          } else {
            table-body
          }
        ]
      ]

      #v(0.5em)

      #align(center)[
        #labels.source: #source
      ]
    ]

    v(1em)
  }
}

//╭─────────────────────────────────────╮
//│      Main Paper Configuration       │
//╰─────────────────────────────────────╯
#let vortex(
  title: [],
  authors: (),
  doi: "00000.0000",
  name: "NAME",
  lastname: "LAST NAME",
  article-type: [ORIGINAL ARTICLE],
  lang: "pt",
  region: "br",
  vortex-number: "#",
  article-first-page-number: "#",
  article-last-page-number: "#",
  received: "00/00/2026",
  accepted: "00/00/2026",
  available-online: "00/00/2026",
  editor: "Dr Fabio Guilherme Poletto. Dr Felipe de Almeida Ribeiro",
  license-url: "https://creativecommons.org/licenses/by/4.0/",
  resumo: [],
  palavras-chave: [],
  abstract: [],
  keywords: [],
  resumen: [],
  palabras-clave: [],
  body,
) = {
  let has-portuguese-abstract = vortex-has-content(resumo)
  let has-english-abstract = vortex-has-content(abstract)
  let has-spanish-abstract = vortex-has-content(resumen)
  let abstract-count = (
    (
      if has-portuguese-abstract { 1 } else { 0 }
    )
      + (
        if has-english-abstract { 1 } else { 0 }
      )
      + (
        if has-spanish-abstract { 1 } else { 0 }
      )
  )

  if abstract-count > 2 {
    panic(
      "Vortex template error: provide at most two abstracts. Use English only, Portuguese + English, or Spanish + English.",
    )
  }
  if not has-english-abstract {
    panic(
      "Vortex template error: an English abstract is required. Portuguese-only or Spanish-only abstracts are not accepted.",
    )
  }
  if has-portuguese-abstract and has-spanish-abstract {
    panic(
      "Vortex template error: choose either Portuguese + English or Spanish + English, not Portuguese + Spanish together.",
    )
  }

  set page(paper: "a4", margin: (
    top: 2cm,
    bottom: 2cm,
    left: 2.5cm,
    right: 2.5cm,
  ))
  set heading(numbering: "1.")
  set text(
    lang: lang,
    region: region,
    font: "EB Garamond",
    size: 12pt,
  )
  show heading: set text(size: 12pt)
  show heading: it => [
    #v(2em)
    #it
    #v(2em)
  ]
  show ref: it => {
    let el = it.element
    if el != none and el.func() == metadata {
      let value = el.value
      if (
        type(value) == dictionary
          and "kind" in value
          and (
            value.kind == "vortex-image" or value.kind == "vortex-table"
          )
      ) {
        value.reference
      } else {
        it
      }
    } else {
      it
    }
  }

  set par(
    justify: true,
    leading: 0.75em,
    spacing: 0cm,
    first-line-indent: (
      amount: 1cm,
      all: true,
    ),
  )
  set footnote.entry(indent: 0pt)

  // header
  set page(
    header: context {
      if counter(page).get().first() == 1 {
        block(width: 100%)[
          #set text(size: 8pt)

          #set par(
            justify: true,
            leading: 0.5em,
            first-line-indent: 0pt,
          )

          Revista Vórtex | Vortex Music Journal | ISSN 2317–9937 |
          http://vortex.unespar.edu.br/ \
          #("https://doi.org/" + doi)
        ]
      } else {
        align(right)[
          #set text(size: 8pt)
          #set par(first-line-indent: 0pt)
          #upper(lastname), #name. #title
        ]
      }
    },
  )

  let first-page-note = [
    *#title.* Received on: #received.
    Accepted on: #accepted.
    Available online: #available-online.
    Editor: #editor.
    Creative Commons CC-BY:
    #underline(link(license-url)[#license-url]).
  ]

  //────────────────────────────────────
  // footer
  //────────────────────────────────────
  set page(
    footer: context {
      if counter(page).get().first() == 1 {
        block(width: 100%)[
          #set text(size: 8pt, font: "Cambria")
          #set par(
            first-line-indent: 0pt,
            leading: .5em,
            spacing: .5em,
            justify: true,
          )

          #first-page-note
        ]
      } else {
        block(width: 100%)[

          #set text(size: 8pt)

          #set par(
            first-line-indent: 0pt,
            leading: 0.5em,
          )

          *Rev Vórtex*, Curitiba, #("v." + str(vortex-number)), #("p." + str(article-first-page-number) + "-" + str(article-last-page-number)), e0000, 2026.
          issn 2317–9937. \
          https://creativecommons.org/licenses/by/4.0/ |
          #str("https://doi.org/" + doi)

          #v(0.5em)

          #align(center)[
            #counter(page).display()
          ]
        ]
      }
    },
  )

  //────────────────────────────────────
  // first page
  //────────────────────────────────────

  text(size: 8pt, fill: rgb("#B71C1C"))[
    \
    \
    #article-type
  ]

  v(0.6em)

  text(size: 18pt)[
    #set par(first-line-indent: 0pt)
    *#title*
  ]

  v(2em)

  for author in authors {
    par(first-line-indent: 0pt)[
      #author.name
      #h(0.5em)
      #if "orcid" in author {
        link("https://orcid.org/" + author.orcid)[
          #box(
            height: 0.7em,
            baseline: 0em,
            image("./assets/images/orcid.svg", height: 0.7em),
          )
        ]
      }
      \
      #text(size: 10pt)[
        #author.affiliation
      ]
    ]

    v(1em)
  }

  let english-abstract-block = [
    #set text(size: 10pt)
    #set par(
      justify: true,
      first-line-indent: 0pt,
    )
    *Abstract:* #abstract
    \
    \
    *Keywords:* #keywords
  ]

  v(1.5em)

  let portuguese-abstract-block = [
    #set text(size: 10pt)
    #set par(
      justify: true,
      first-line-indent: 0pt,
    )
    *Resumo:* #resumo
    \
    \
    *Palavras-chave:* #palavras-chave
  ]

  let spanish-abstract-block = [
    #set text(size: 10pt)
    #set par(
      justify: true,
      first-line-indent: 0pt,
    )
    *Resumen:* #resumen
    \
    \
    *Palabras clave:* #palabras-clave
  ]

  if abstract-count == 1 {
    align(center)[
      #block(width: 65%)[
        #english-abstract-block
      ]
    ]
  } else {
    columns(2, gutter: 8mm)[
      #if has-portuguese-abstract {
        portuguese-abstract-block
      } else {
        spanish-abstract-block
      }

      #colbreak()
      #english-abstract-block
    ]
  }

  pagebreak()

  set par(
    leading: 1.5em,
  )

  vortex-document-lang.update(lang)

  body
}
