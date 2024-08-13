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

dtf_msw3_full_raw <- read_csv(here("01_data",
                                   "01_raw-data",
                                   "msw3_all_UTF-8.csv"))

#### Setting up cleaning vectors ####

### Colnames vector ###
# The following vector will be used to standardize column names. The syntax is #
# "new_column_name" = "original_column_name"                                   #

vct_colnames <- c(
  "msw3_number_ID" = "ID",
  "msw3_accepted_sist_order" = "Order",                   #Clean
  "msw3_accepted_sist_suborder" = "Suborder",             #Clean
  "msw3_accepted_sist_infraorder" = "Infraorder",         #Clean
  "msw3_accepted_sist_superfamily" = "Superfamily",       #Clean
  "msw3_accepted_sist_family" = "Family",                 #Clean
  "msw3_accepted_sist_subfamily" = "Subfamily",           #Clean
  "msw3_accepted_sist_tribe" = "Tribe",                   #Clean
  "msw3_accepted_sist_genus" = "Genus",                   #Clean
  "msw3_accepted_sist_subgenus" = "Subgenus",             #Checked - Needs cleaning
  "msw3_accepted_sist_epithet" = "Species",               #Clean
  "msw3_accepted_sist_subspecies" = "Subspecies",         #Unchecked
  "msw3_accepted_taxon_rank" = "TaxonLevel",              #Clean
  "msw3_accepted_status_extinct" = "Extinct?",            #Unchecked
  "msw3_original_name" = "OriginalName",                  #Clean
  "msw3_accepted_status_valid_name" = "ValidName",        #Clean
  "msw3_accepted_author_name" = "Author",                 #Clean
  "msw3_accepted_author_year" = "Date",                   #Checked - Missing info
  "msw3_accepted_author_year_corrected" = "ActualDate",   #Clean
  "msw3_accepted_citation_journal" = "CitationName",      #Ignored
  "msw3_accepted_citation_volume" = "CitationVolume",     #Ignored
  "msw3_accepted_citation_issue" = "CitationIssue",       #Ignored
  "msw3_accepted_citation_pages" = "CitationPages",       #Ignored
  "msw3_accepted_citation_notes" = "CitationType",        #Ignored
  "msw3_type_name" = "TypeSpecies",                       #Clean
  "msw3_common_name" = "CommonName",                      #Clean - might have other undetected problems
  "msw3_type_locality" = "TypeLocality",                  #Clean - might have other undetected problems
  "msw3_accepted_distribution_notes" = "Distribution",    #Clean - might have other undetected problems
  "msw3_accepted_status_iucn" = "Status",                 #Ignored
  "msw3_synonymy" = "Synonyms",                           #Clean - partially (Genus = ok)
  "msw3_accepted_notes" = "Comments",                     #Ignored
  "msw3_accepted_sort_file" = "File",                     #Ignored
  "msw3_accepted_sort_sortorder" = "SortOrder",           #Ignored
  "msw3_accepted_sort_displayorder" = "DisplayOrder"      #Ignored
)

### Character fixing vector ###
# The following vector will be used to clean character encoding problems from the #
# original data file. The syntax is "old string" = "corrected character"          #

vct_char_fix <- c(
  "&#131;" = "ć",
  "&#132;" = "Č",
  "&#133;" = "č",
  "&#151;" = "ğ",
  "&#153;" = "ğ",
  "&#263;" = "ć",
  "&#268;" = "Č",
  "&#269;" = "č",
  "&#277;" = "ĕ",
  "&#287;" = "ğ",
  "&#328;" = "ň",
  "&#337;" = "ö",
  "&#351;" = "ş",
  "&#369;" = "ü",
  "&#730;" = "˚",
  "&#8209;" = "-",
  "&#8242;" = "′",
  "&#8243;" = "″",
  "################" = "",
  "&nbsp;" = "",
  "&amp;" = "",
  "&quot" = "",
  "¥" = "i",
  " " = " ",
  " " = " ",
  "`" = "",
  " ," = ", ",
  ",," = ",",
  "’" = "'",
  "‘" = "'",
  "“" = '"',
  "”" = '"', 
  "Pi±os" = "Piños",
  "Iba±ez" = "Ibañez",
  "Ibß±ez" = "Ibañez",
  "Tar~bulus" = "Tar'bulus"
)

#### Basic data cleaning ####

dtf_msw3_full_clean <- dtf_msw3_full_raw %>%
  rename(all_of(vct_colnames)) %>% # Renaming columns #
  mutate(across(1:34, ~ str_replace_all(., vct_char_fix))) %>% # Fixing characters #
  mutate(# Cleaning html tags, small typos and NAs on specific columns #
    msw3_accepted_author_name = str_replace_all(msw3_accepted_author_name, 
                                                pattern = "<i>In</i>|<i>in</i>",
                                                replacement = "in"),
    msw3_accepted_author_name = str_replace_all(msw3_accepted_author_name,
                                                pattern = "<i>In </i>|<i>in </i>",
                                                replacement = "in "),
    msw3_accepted_author_name = str_replace_all(msw3_accepted_author_name,
                                                pattern = ", and|,",
                                                replacement = " and"),
    msw3_accepted_author_name = str_replace_all(msw3_accepted_author_name,
                                                pattern = "and Jr\\.",
                                                replacement = "Jr."),
    msw3_accepted_author_name = str_replace_all(msw3_accepted_author_name,
                                                pattern = "\\[Baron\\]",
                                                replacement = "'Baron'"),
    msw3_original_name = str_replace_all(msw3_original_name, 
                                         pattern = "<i>|</i>",
                                         replacement = ""),
    msw3_common_name = str_replace(msw3_common_name,
                                   pattern = "\\.$",
                                   replacement = ""),
    msw3_common_name = str_replace(msw3_common_name,
                                   pattern = "<b> </b>",
                                   replacement = " "),
    msw3_type_name = str_replace_all(msw3_type_name, 
                                     pattern = "<i>|</i>|<u>|</u>|<b>|</b>|<sup>|</sup>|\\.$", 
                                     replacement = ""),
    msw3_type_locality = str_replace_all(msw3_type_locality, 
                                         pattern = "<i>|</i>|<u>|</u>|<b>|</b>|\\.$", 
                                         replacement = ""),
    msw3_type_locality = str_replace_all(msw3_type_locality, 
                                         pattern = "<sup>o</sup>", 
                                         replacement = "°"),
    msw3_type_locality = str_replace_all(msw3_type_locality, 
                                         pattern = "<sup>|</sup>", 
                                         replacement = ""),
    msw3_accepted_status_valid_name = str_replace_na(msw3_accepted_status_valid_name,
                                                     replacement = "yes"), # There's a single NA (ID: 12100705), and it is considered valid on the website (https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?id=12100705) #
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<i>|</i>|<u>|</u>|<b>|</b>|\\.", 
                                                       replacement = ""),
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<sup>o</sup>", 
                                                       replacement = "°"),
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<sup>|</sup>", 
                                                       replacement = ""),
    # Creating new basic columns #
    msw3_original_name_comments = case_when(
      msw3_original_name == "? Orig descr as full species" ~ "Original description as full species"),
    .after = "msw3_original_name",
    # Deleting weird values from specific cells #
    msw3_original_name = na_if(msw3_original_name,
                               "? Orig descr as full species"),
    msw3_synonymy = na_if(msw3_synonymy,
                          "IUCN – Lower Risk (nt)."),
    msw3_accepted_sist_tribe = na_if(msw3_accepted_sist_tribe,
                                     "Gray"),
    # Fixing column problems #
    msw3_accepted_status_valid_name = str_to_lower(msw3_accepted_status_valid_name))

#### Specific data cleaning and wrangling ####
### Genus synonymy ###

dtf_msw3_genus_synonyms <- dtf_msw3_full_clean %>% 
  filter(msw3_accepted_taxon_rank == "GENUS") %>%
  select(msw3_number_ID,
         msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
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
               "msw3_genus-synonymy.csv"))


#### Notes to self ####

## Taking note of problems
dtf_msw3_full_specificProblems <- dtf_msw3_full_clean %>% 
  filter(msw3_accepted_author_name == "new subfamily.") %>% # Check how more recent authors cite this
  bind_rows((
    dtf_msw3_full_clean %>% # Comments and other notations
      filter(str_detect(msw3_accepted_sist_subgenus,
                        pattern = "\\.|\\?|\\[|\\]| |Comment|comment"))
  ),(
    dtf_msw3_full_clean %>% # Authority year as NA
      filter(is.na(msw3_accepted_author_year))
  ))

## Checking for anomalous values in each column. All columns from order to valid name
## status were thoroughly checked, but subspecies and extinction status. All errors found in checked
## columns were fixed so far, but the errors in the subgenus column. Bellow there's
## an example of the code used to check the larger taxonomic columns, like genus
## and epithet. The idea is to incrementally exclude names based on their endings, 
## which were checked by removing the "!" before each "str_detect".

#a <- dtf_msw3_clean %>%
#filter(!str_detect(string = msw3_accepted_sist_genus,
#                   pattern = "mys$")) %>% 
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "don$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ops$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "x$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "dorcas$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "tragus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "dontia$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "dontes$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ceros$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ictis$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "cyon$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "gale$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "is$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "es$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "lus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "cus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "pus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "urus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ura$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "bus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ia$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ius$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "rus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "mus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "nus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "tus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "eus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "sus$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "us$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "oma$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "oda$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "on$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ola$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ta$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "na$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ra$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "la$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "ma$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "as$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "s$")) %>%
#  filter(!str_detect(string = msw3_accepted_sist_genus,
#                     pattern = "a$")) %>%
#  group_by(msw3_accepted_sist_genus) %>%
#  summarise(n = n())