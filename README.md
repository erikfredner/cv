# CV
I use this to generate and update my CV on macOS.

You can see the typeset CV on my [website](https://fredner.org/files/cv.pdf).

## Typesetting
Requires both [pandoc](https://pandoc.org) and a full [MacTeX](https://www.tug.org/mactex/) installation:

```bash
pandoc cv.md -o cv.pdf -V geometry:margin=1in
```