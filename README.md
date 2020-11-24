# CV
Documents for updating and generating my CV.

[`cv.pdf`](https://github.com/erikfredner/cv/blob/master/cv.pdf) shows what the full typeset cv looks like.

## Typesetting

Requires both [pandoc](https://pandoc.org) and a full [MacTeX](https://www.tug.org/mactex/) installation:

```bash
pandoc cv.md -o cv.pdf -V geometry:margin=1in
```