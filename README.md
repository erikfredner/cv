# CV

I use this markdown file to generate my [CV](https://fredner.org/files/cv.pdf).

## Requirements

- [pandoc](https://pandoc.org)
- [MacTeX](https://www.tug.org/mactex/)

## Typesetting

```zsh
pandoc cv.md -o cv.pdf -V geometry:margin=1in
```