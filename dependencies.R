# Implicit dependencies: packages required by Quarto at render time but never
# directly loaded in .qmd files. renv scans this file so they stay in the
# lockfile. If renv flags a package here as "recorded but not used", it likely
# means Quarto dropped the dependency — investigate and remove the line.
library(downlit) # code-link: true uses downlit to hyperlink R functions
