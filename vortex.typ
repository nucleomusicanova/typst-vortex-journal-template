#import "@preview/droplet:0.3.1": dropcap

//╭─────────────────────────────────────╮
//│               DROPCAP               │
//╰─────────────────────────────────────╯
#let vortex-dropcap(body) = {
  dropcap(height: 3)[#body]
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
    let is-portuguese = lang == "pt" or lang == "pt-br"
    let caption-name = if is-portuguese { "FIGURA" } else { "FIGURE" }
    let source-name = if is-portuguese { "Fonte" } else { "Source" }
    let number = vortex-image-counter.get().first() + 1
    let reference = caption-name + " " + str(number)

    block(width: 100%, breakable: false)[
      #set par(
        first-line-indent: 0pt,
        justify: false,
        leading: 0.5em,
      )

      #set text(size: 10pt)

      #if ref != none {
        [
          #metadata((
            kind: "vortex-image",
            reference: reference,
          )) #ref
        ]
      }

      #vortex-image-counter.step()
      #align(center)[
        #reference – #caption
      ]

      #v(0em)

      #align(center)[
        #box(width: width)[
          #if frame {
            box(width: 100%, stroke: rgb("#c8c8c8"), inset: 0pt)[#image-body]
          } else {
            image-body
          }
        ]
      ]

      #v(0em)

      #align(center)[
        #source-name: #source
      ]
    ]
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
    let is-portuguese = lang == "pt" or lang == "pt-br"
    let caption-name = if is-portuguese { "TABELA" } else { "TABLE" }
    let source-name = if is-portuguese { "Fonte" } else { "Source" }
    let number = vortex-table-counter.get().first() + 1
    let reference = caption-name + " " + str(number)
    let inline-reference = if is-portuguese {
      "Tabela " + str(number)
    } else {
      "Table " + str(number)
    }

    block(width: 100%, breakable: false)[
      #set par(
        first-line-indent: 0pt,
        justify: false,
        leading: 1em,
      )

      #let table-body = if body.func() == table {
        let strong-rule = 1.2pt + black
        let light-rule = 0.4pt + rgb("#c8c8c8")
        let fields = body.fields()
        let children = fields.remove("children")
        let columns = fields.at("columns")
        if columns.all(column => column == auto) {
          fields.insert("columns", columns.map(column => 1fr))
        }
        children.push(table.hline(stroke: strong-rule))

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
          #show table.cell: it => {
            if it.y == 0 {
              strong(it)
            } else if it.x == 0 {
              emph(it)
            } else {
              it
            }
          }
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
        #reference – #caption
      ]

      #v(0em)

      #align(center)[
        #box(width: width)[
          #if frame {
            box(width: 100%, stroke: rgb("#c8c8c8"), inset: 0pt)[#table-body]
          } else {
            table-body
          }
        ]
      ]

      #v(0em)

      #align(center)[
        #source-name: #source
      ]
    ]
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
  body,
) = {
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
    first-line-indent: (
      amount: 2em,
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

  v(0em)

  text(size: 18pt)[
    #set par(first-line-indent: 0pt)
    *#title*
  ]

  v(1em)

  for author in authors {
    par(first-line-indent: 0pt)[
      #author.name
      #h(0.3em)
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

  columns(2, gutter: 8mm)[
    #set text(size: 10pt)
    #set par(
      justify: true,
      first-line-indent: 0pt,
    )
    *Resumo:* #resumo
    \
    \
    *Palavras-chave:* #palavras-chave

    #colbreak()
    *Abstract:* #abstract
    \
    \
    *Keywords:* #keywords
  ]

  pagebreak()

  set par(
    leading: 1.5em,
  )

  vortex-document-lang.update(lang)

  body
}
