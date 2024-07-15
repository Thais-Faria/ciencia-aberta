# README
Thaís G. P. Faria
2024-07-15

- [Overview](#overview)
  - [What is this project?](#what-is-this-project)
  - [About the data](#about-the-data)
  - [Aims](#aims)
  - [About the code](#about-the-code)
- [About this repo](#about-this-repo)
  - [How is it organized?](#how-is-it-organized)
  - [How can I use it?](#how-can-i-use-it)
- [References](#references)

## Overview

### What is this project?

This is a simple data cleaning project aimed at cleaning mammal
biological classification data. It was done as a conclusion assignment
for the course [“Reproducibility and Open
Science”](https://gabrielnakamura.github.io/USP_reproducibility_BIE5798/index.html "The course's website (written in Brazillian Portuguese)"),
offered by [Melina
Leite](https://github.com/melina-leite "M. Leite's GitHubprofile") and
[Gabriel
Nakamura](https://github.com/GabrielNakamura "G. Nakamura's GitHubprofile")
on July, 2024, at the Department of Ecology, Institute of Biosciences,
University of São Paulo (USP), Brazil.

### About the data

The data used in this project comes from [the
website](https://www.departments.bucknell.edu/biology/resources/msw3/ "Bucknell University's website where users can download the original data")
dedicated to the book Mammal Species of the World (MSW3, Wilson and
Reeder 2005), a slightly outdated (but still useful) reference of Mammal
Taxonomy. It has historical value, but also holds information that’s yet
to be fully processed by the newer [Mammal Diversity
Database](https://www.mammaldiversity.org/ "Link to the Mammal Diversity Database homepage")
(Upham et al. 2024), specially regarding genus or higher level taxonomic
synonyms. As such, it can be used as a source of data for projects that
need this kind of information.

A careful cleaning effort is needed because the available [download
link](https://www.departments.bucknell.edu/biology/resources/msw3/export.asp "Click to download the original Mammal Species of the World data")
offers a badly encoded version of the data displayed at the website.
That means the downloaded .csv file is full of html tags and symbols
scattered among the strings, which renders it impossible to use when one
needs to perform common data wrangling operations, such as joins between
dataframes downloaded from different databases. Although there is
another source for the same data made available by [Jorrit
Poelen](https://github.com/jhpoelen/msw3/tree/main "J. Poelen's Mammal Species of the World GitHubrepository")
as .json files, the data repository describes itself as incomplete.

### Aims

This project aims to provide a synonymy of mammal genera and higher
level taxonomic ranks. Because The Mammal Diversity Database (2024)
already provides better access to original citations, type localities
and updated [IUCN’s Red
List](https://www.iucnredlist.org/ "Link to the Red List website, by IUCN")
threat assessments, this work focuses on cleaning the taxonomic synonyms
from the MSW3.

### About the code

The code is written in R (Ihaka and Gentleman 1996) following the
Tidyverse framework (Wickham et al. 2019). Specifically, it uses the
packages `readr`, `dplyr` and `stringr` for data cleaning and wrangling,
as well as `ggplot` for data visualization. As an effort to keep it’s
reproducibility, it also uses an `.RProj` file along with the `here`
package to ensure compatibility with different operational systems, as
recommended by Jenny Brian
[here](https://github.com/jennybc/here_here "Link to J. Brian's Ode to the Here Package, on GitHub").
Finally, for R package versioning, it uses…(still deciding on it).

## About this repo

### How is it organized?

Under construction.

### How can I use it?

Under construction.

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-ihaka1996r" class="csl-entry">

Ihaka, Ross, and Robert Gentleman. 1996. “R: A Language for Data
Analysis and Graphics.” *Journal of Computational and Graphical
Statistics* 5 (3): 299–314.

</div>

<div id="ref-upham2024mammal" class="csl-entry">

Upham, Nate, Connor Burgin, Jane Widness, S Liphardt, Camilla Parker, M
Becker, Ingrid Rochon, and David Huckaby. 2024. “Mammal Diversity
Database.” Version.

</div>

<div id="ref-wickham_welcome_2019" class="csl-entry">

Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy
McGowan, Romain François, Garrett Grolemund, et al. 2019. “Welcome to
the Tidyverse.” *Journal of Open Source Software* 4 (43): 1686.
<https://doi.org/10.21105/joss.01686>.

</div>

<div id="ref-wilson_mammal_2005" class="csl-entry">

Wilson, Don E., and DeeAnn M. Reeder, eds. 2005. *Mammal Species of the
World: A Taxonomic and Geographic Reference*. 3rd ed. Baltimore: Johns
Hopkins University Press.

</div>

</div>
