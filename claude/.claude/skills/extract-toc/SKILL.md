---
name: extract-toc
description: Extract the table of contents from a PDF and output it as YAML. Use this skill when the user wants to extract, parse, or structure a PDF's table of contents.
argument-hint: "<pdf-path> [style]"
---

# Extract PDF Table of Contents

Extract the table of contents (TOC) from the specified PDF and output it as YAML.

## Arguments

The skill accepts two positional arguments:

1. `pdf-path` — Path to the PDF file. Required.
2. `style` — Output style. Optional.
   - `nested`: hierarchical tree structure. This is the default.
   - `flat`: flat list.

Examples:

```text
/extract-toc book.pdf
/extract-toc book.pdf nested
/extract-toc book.pdf flat
```

If `style` is omitted, use `nested`.

## Core Requirement

The TOC must be identified by the model from the PDF itself.

Do NOT write or execute local code to detect the TOC.

Do NOT implement PDF parsing, OCR, font analysis, indentation analysis, or layout analysis in Python, JavaScript, shell, or any other programming language.

Use the model's ability to inspect and understand the PDF's text, typography, layout, indentation, and visual structure.

## Procedure

### 1. Inspect the PDF

Read the PDF and locate its table of contents.

The TOC may span multiple pages.

Do not assume that the first page containing the word "Contents" is the entire TOC. Continue inspecting subsequent pages until the TOC clearly ends.

Ignore:

- the book title
- copyright pages
- prefaces unless they are explicitly listed as TOC entries
- indexes
- lists of figures
- lists of tables
- unrelated navigation elements

Only extract actual TOC entries.

### 2. Identify each TOC item

For every TOC entry, extract:

- `title`
- `level`
- `page`

Each item must correspond to one actual TOC entry in the PDF.

Preserve the title as it appears in the TOC as closely as possible.

Do not invent missing titles or pages.

### 3. Determine hierarchy

Determine each item's `level` using the visual structure of the TOC.

Use both:

- typography, especially font size, weight, and style
- indentation / horizontal position

The hierarchy should normally follow:

```text
Chapter      → level 1
Section      → level 2
Subsection   → level 3
...
```

For example:

```text
Chapter 1        → level 1
  1.1            → level 2
    1.1.1        → level 3
```

Do not determine the level solely from numbering.

For example, if a visually indented item has numbering that does not follow the expected numeric pattern, use its actual visual hierarchy.

Conversely, do not treat an item as a child merely because its numbering looks like a subsection if its typography and indentation indicate otherwise.

Use the surrounding TOC entries to infer the hierarchy consistently.

### 4. Extract page numbers

Extract the page number associated with each TOC item.

If an item has no page number, use:

```yaml
page: null
```

Do not infer a page number from the following or preceding entry.

Page numbers should be represented as numbers when they are numeric.

If the TOC uses non-numeric page identifiers such as:

```text
ix
xii
A-3
```

preserve them as strings.

### 5. Validate the hierarchy

Before producing the final output, check:

- every TOC item has `title`, `level`, and `page`
- levels are positive integers
- child items have a greater level than their parent
- hierarchy is consistent with typography and indentation
- no TOC entries were skipped
- no non-TOC text was accidentally included
- missing page numbers are represented as `null`

## Output

Output YAML only.

Do not add explanatory prose before or after the YAML.

The output file must be saved beside the input PDF with the same name but `.yaml` extension. For example, if the input is `book.pdf`, save the output as `book.yaml` in the same directory.

### Nested style

When `style` is `nested`, convert the flat hierarchy into a tree.

Each top-level item must have:

```yaml
- title: ...
  level: 1
  page: ...
  children:
    - title: ...
      level: 2
      page: ...
      children:
        - title: ...
          level: 3
          page: ...
```

Items without children must NOT have a `children` property.

Example:

```yaml
- title: Introduction
  level: 1
  page: 1
  children:
    - title: Background
      level: 2
      page: 3
    - title: Scope
      level: 2
      page: 7

- title: Methods
  level: 1
  page: 10
  children:
    - title: Data Collection
      level: 2
      page: 11
      children:
        - title: Sampling
          level: 3
          page: 12
```

### Flat style

When `style` is `flat`, output every TOC item as a single list.

Do not add `children`.

Example:

```yaml
- title: Introduction
  level: 1
  page: 1

- title: Background
  level: 2
  page: 3

- title: Scope
  level: 2
  page: 7

- title: Methods
  level: 1
  page: 10
```

## Important Constraints

The purpose of this skill is semantic extraction by the model.

Chapters must have level 1. Do not include parent items of chapters (e.g., "Part I", "Volume 1") in the output. Only include chapters (level 1) and their descendants.

Do not create a program that:

- extracts PDF text and analyzes indentation
- calculates font sizes
- detects TOC entries using regular expressions
- detects hierarchy using coordinates
- performs OCR locally
- uses PDF libraries to infer the hierarchy

Local tools may only be used when necessary to open or inspect the PDF itself. They must not be used to implement the TOC recognition logic.

The final YAML must be generated from the model's interpretation of the PDF's visual and textual structure.
