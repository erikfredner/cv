# this script generates and opens pdf output of current version of cv
# it also generates a current version of the html of the cv
# should be executed from the root directory containing cv.md
# requires pandoc
pandoc -o cv.html cv.md
pandoc cv.md -s -o cv.pdf
open cv.pdf
