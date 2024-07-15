# README
Thaís G. P. Faria

## Overview

This is a simple data cleaning project aimed at cleaning mammal
biological classification data. It was done as a conclusion assignment
for the course [“Reproducibility and Open
Science”](https://gabrielnakamura.github.io/USP_reproducibility_BIE5798/index.html "The course's website (written in Brazillian Portuguese)"),
offered by [Melina
Leite](https://github.com/melina-leite "M. Leite's github profile") and
[Gabriel
Nakamura](https://github.com/GabrielNakamura "G. Nakamura's github profile")
on July, 2024, at the Department of Ecology, Institute of Biosciences,
University of São Paulo (USP), Brazil.

## About the data

The data used in this project comes from [the
website](https://www.departments.bucknell.edu/biology/resources/msw3/ "Bucknell University's website where users can download the original data")
dedicated to the book Mammal Species of the World (2005), a slightly
outdated (but still useful) reference of Mammal Taxonomy. It has
historical value, but also holds information that’s yet to be fully
processed by the newer Mammal Diversity Database, specially when it
comes to genus or higher level taxonomic synonyms. As such, it can be
used as a source of clean data for projects that need this kind of
information.

A throughout effort of cleaning is needed because the original download
source offers a badly encoded version of the data displayed at the
website. That means the downloaded .csv file is full of html tags and
symbols scattered among the strings, which renders it impossible to use
when one needs to perform common data wrangling operations, such as
joins between dataframes downloaded from different databases. Although
the team behind the Mammal Diversity Database also offers a clean
version of this database, my efforts focus on correcting not only the
larger encoding problems from the original data, but also the smaller
typos, standardized factors, and bits of information in wrong columns.

## About the code

Under construction
