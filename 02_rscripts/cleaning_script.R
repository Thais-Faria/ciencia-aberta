#### Loading packages ####
# Add installation option

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
# The following vector will be used to standardize column names. The syntax is
# "new_column_name" = "original_column_name"

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
  "msw3_synonymy" = "Synonyms",
  "msw3_accepted_notes" = "Comments",                     #Ignored
  "msw3_accepted_sort_file" = "File",                     #Ignored
  "msw3_accepted_sort_sortorder" = "SortOrder",           #Ignored
  "msw3_accepted_sort_displayorder" = "DisplayOrder"      #Ignored
)

### Character fixing vector ###
# The following vector will be used to clean character encoding problems from the
# original data file. The syntax is "old string" = "corrected character"

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
  rename(all_of(vct_colnames)) %>% # Renaming columns
  mutate(across(1:34, ~ str_replace_all(., vct_char_fix))) %>% # Fixing characters
  mutate(# Cleaning html tags, small typos and NAs on specific columns
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
                                                     replacement = "yes"), #There's a single NA (ID: 12100705), and it is considered valid on the website (https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?id=12100705)
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<i>|</i>|<u>|</u>|<b>|</b>|\\.", 
                                                       replacement = ""),
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<sup>o</sup>", 
                                                       replacement = "°"),
    msw3_accepted_distribution_notes = str_replace_all(msw3_accepted_distribution_notes, 
                                                       pattern = "<sup>|</sup>", 
                                                       replacement = ""),
    ## Creating new basic columns
    msw3_original_name_comments = case_when(
      msw3_original_name == "? Orig descr as full species" ~ "Original description as full species"),
    .after = "msw3_original_name",
    ## Deleting weird values from specific cells
    msw3_original_name = na_if(msw3_original_name,
                               "? Orig descr as full species"),
    msw3_synonymy = na_if(msw3_synonymy,
                          "IUCN – Lower Risk (nt)."),
    msw3_accepted_sist_tribe = na_if(msw3_accepted_sist_tribe,
                                     "Gray"),
    ## Fixing column problems
    msw3_accepted_status_valid_name = str_to_lower(msw3_accepted_status_valid_name))

#### Data wrangling ####
### Genus synonymy ###

dtf_msw3_genus_synonyms <- dtf_msw3_full_clean %>% 
  filter(msw3_accepted_taxon_rank == "GENUS") %>%
  select(msw3_number_ID,
         msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
         msw3_synonymy) %>%
  mutate(msw3_synonymy = na_if(msw3_synonymy,
                               "<i>                                       </i>"),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "<i>|</i>|<b>|</b>|\\.$",
                                         replacement = " "),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "   ",
                                         replacement = " "),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "  ",
                                         replacement = " "),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "  ",
                                         replacement = " "),
         msw3_synonymy = str_replace_all(msw3_synonymy,
                                         pattern = "^ | $",
                                         replacement = ""),
         msw3_synonymy = str_replace(msw3_synonymy,
                                     pattern = "Kretzoi, 1929, Pardus Fitzinger, 1868",
                                     replacement = "Kretzoi, 1929; Pardus Fitzinger, 1868")) %>%
  separate_rows(msw3_synonymy, sep = "; ")





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

dtf_msw3_genus_specificProblems <- dtf_msw3_genus_synonyms %>%
  filter(str_detect(msw3_synonymy, pattern = "^[:upper:]", negate = TRUE))


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




