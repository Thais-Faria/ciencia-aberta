#### Loading packages ####
# -> Add installation option

library(groundhog)
groundhog.day <- "2024-08-01"
groundhog.packages <- c("here",
                        "readr",
                        "tidyr",
                        "dplyr",
                        "stringr")
groundhog.library(groundhog.packages, 
                  groundhog.day)
rm(groundhog.day,
   groundhog.packages)

#### Reading data ####

dtf_msw3_full_clean <- read_csv(here("01_data",
                                     "02_clean-data",
                                     "msw3_full_partially-clean.csv"))

#### Specific data cleaning and wrangling ####
### Genus synonymy ###

dtf_msw3_genus_synonyms <- dtf_msw3_full_clean %>% 
  filter(msw3_accepted_taxon_rank == "GENUS") %>%
  select(msw3_number_ID,
         msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
         msw3_accepted_author_name,
         msw3_accepted_author_year,
         msw3_synonymy) %>%
  # The following are steps to clean several specific string formatting problems.             # 
  # they basically consist of replacing messy punctuation with standardized punctuation in    #
  # order to enable the creation of new columns later. The cases consisting of addition       #
  # of information are followed by specific comments, as well as other special cases          #
  mutate(msw3_synonymy = na_if(msw3_synonymy, 
                               "<i>                                       </i>"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "<i>|</i>|<b>|</b>|\\.$",
                                         replacement = " "),
         msw3_synonymy = str_squish(msw3_synonymy),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = " \\.",
                                         replacement = "."),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\.$",
                                         replacement = ""),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ";\\.$",
                                         replacement = ""),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ";\\.",
                                         replacement = ";"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = " ,",
                                         replacement = ","),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\[ ",
                                         replacement = "\\["),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = " \\]",
                                         replacement = "\\]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = " \\[sic\\]",
                                         replacement = ""),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; see",
                                         replacement = ", see"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; not",
                                         replacement = ", not"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; and",
                                         replacement = ", and"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; the",
                                         replacement = ", the"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; later",
                                         replacement = ", later"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; valid",
                                         replacement = ", valid"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; 1",
                                         replacement = ", 1"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; Ellerman",
                                         replacement = ", Ellerman"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; McKenna",
                                         replacement = ", McKenna"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; Rosevear",
                                         replacement = ", Rosevear"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; Rossolimo",
                                         replacement = ", Rossolimo"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; and footnote",
                                         replacement = ", and footnote in"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "; ICZN",
                                         replacement = ", ICZN"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", Pardus",
                                         replacement = "; Pardus"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(unavailable\\)",
                                         replacement = "[unavailable]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(preoccupied\\)",
                                         replacement = "[preoccupied]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\( nomen oblitum \\)",
                                         replacement = "[nomen oblitum]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\( nomen nudum \\)",
                                         replacement = "[nomen nudum]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(part\\)",
                                         replacement = "[part]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(6 October\\)",
                                         replacement = "[on 6 October]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\( in Gray 1865\\)",
                                         replacement = "[in Gray, 1865]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\( in Gray, 1865\\)",
                                         replacement = "[in Gray, 1865]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(not Storr, 1780\\)",
                                         replacement = "[not Storr, 1780]"),  
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(not Thomas, 1910\\)",
                                         replacement = "[not Thomas, 1910]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(preoccupied by Canis Linneaus, 1758\\)",
                                         replacement = "[preoccupied by Canis Linneaus, 1758]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(see Rosevear, 1969:487\\)",
                                         replacement = "[see Rosevear, 1969:487]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(see Genest and Petter, 1975\\)",
                                         replacement = "[see Genest and Petter, 1975]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\(see Ellerman et al\\., 1953\\)",
                                         replacement = "[see Ellerman et al., 1953]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", see Ellerman and Morrison-Scott \\(1951\\)",
                                         replacement = " [see Ellerman and Morrison-Scott (1951)"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", see Pavlinov and Rossolimo \\(1987\\) and Shenbrot et al\\. \\(1995\\)",
                                         replacement = " [see Pavlinov and Rossolimo (1987) and Shenbrot et al. (1995)]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", see McKenna and Bell \\(1997\\) and Zazhigin and Lopatin \\(2000 c \\)",
                                         replacement = " [see McKenna and Bell (1997) and Zazhigin and Lopatin (2000c)]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", see Daams and",
                                         replacement = " [see Daams and"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = ", is an unjustified",
                                         replacement = " [it is an unjustified"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "in Van Beneden and Gervais, 1880",
                                         replacement = "[in Van Beneden and Gervais, 1880]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,       
                                         pattern = "\\? Tribonophorus Burnett, 1829",
                                         replacement = "Tribonophorus Burnett, 1829 [?]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Blainville in Desmarest, 1817",
                                         replacement = "Blainville, 1817 [in Desmarest, 1817]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Anonymous in Harlan, 1828",
                                         replacement = "Anonymous, 1828 [in Harlan, 1828]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Anon\\. \\[?de Blainville\\], 1846",
                                         replacement = "Anonymous, 1846 [? de Blainville]"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Prodelphinus Gervais",
                                         replacement = "Prodelphinus Gervais, 1880"), # Info available on notes column. #
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Sminthus",
                                         replacement = "Sminthus Nordmann, 1840"), # Info available on source website: https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?s=y&id=12900063 #
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Fischer \\[von Waldheim\\]|Fischer de Waldheim|Fischer \\(von Waldheim\\)",
                                         replacement = "Fischer von Waldheim"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "Anon,|Anon\\.,",
                                         replacement = "Anonymous"),
         msw3_synonymy = str_replace_all(msw3_synonymy, # The three following replacements are related to the genus Callithrix. Its synonyms were originally listed by subgenus, but they were aggregate here under Callithrix. #
                                         pattern = "Listed for the four subgenera separately, because they are ranked as full genera by some: \\(1\\) Subgenus Callithrix Erxleben, 1777: ",
                                         replacement = ""),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\. \\(2\\) Subgenus Mico Lesson, 1840: Liocephalus Wagner, 1840",
                                         replacement = "; Liocephalus Wagner, 1840"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "\\. \\(3\\) Subgenus Cebuella Gray, 1866: no synonyms. \\(4\\) Subgenus Calibella van Roosmalen and van Roosmalen, 2003: no synonyms",
                                         replacement = ""),
         msw3_synonymy = str_replace_all(msw3_synonymy, # The original database lists the earlier year as the correct one for almost all cases. This is 1 of 2 cases were the publication year is a time range, and was kept like this to match the other case and avoid loss of information. #
                                         pattern = "1834-36",
                                         replacement = "1834-1836"),
         # Creating new columns #
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = " \\[",
                                         replacement = "_\\[")) %>%
  separate_rows(msw3_synonymy, sep = "; ") %>%
  separate_wider_delim(msw3_synonymy, 
                       delim = "_",
                       names = c("msw3_synonym", 
                                 "msw3_synonym_note"),
                       too_few = "align_start") %>%
  mutate(msw3_synonym = str_replace(msw3_synonym, # The str_replace function only replaces the first match for each row, an ideal behavior for separating the genus name (the first word) from the authority information #
                                    pattern = "[:space:]",
                                    replacement = "_")) %>%
  separate_wider_delim(msw3_synonym,
                       delim = "_",
                       names = c("msw3_synonym_name",
                                 "msw3_synonym_authority"),
                       too_few = "align_start") %>%
  mutate(msw3_synonym_authority = str_replace_all(msw3_synonym_authority,
                                                  pattern = "^\\(|\\)$",
                                                  replacement = ""),
         msw3_synonym_authority = str_replace(msw3_synonym_authority,
                                              pattern = " 1",
                                              replacement = "_1"),
         msw3_synonym_authority = str_replace(msw3_synonym_authority,
                                              pattern = " 2",
                                              replacement = "_2")) %>%
  separate_wider_delim(msw3_synonym_authority,
                       delim = "_",
                       names = c("msw3_synonym_author_name",
                                 "msw3_synonym_author_year"),
                       too_few = "align_start") %>%
  mutate(msw3_synonym_author_name = str_squish(msw3_synonym_author_name),
         msw3_synonym_author_name = str_replace(msw3_synonym_author_name,
                                                pattern = "\\.$|,$",
                                                replacement = ""))

#### Saving clean databases ####
### Genus synonymy ###
write_csv(dtf_msw3_genus_synonyms,
          here("01_data",
               "02_clean-data",
               "msw3_genus_synonymy.csv"))