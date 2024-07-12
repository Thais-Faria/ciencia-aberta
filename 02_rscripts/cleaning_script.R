library(here)
library(readr)

#### Reading data ####

dtf_msw3_full <- read_csv(here("01_data",
                               "01_raw-data",
                               "msw3_all_UTF-8.csv"))

#### Setting up cleaning vectors ####
### Colnames vector ###
vct_colnames <- c(
  "msw3_number_ID" = "ID",
  "msw3_accepted_sist_order" = "Order",
  "msw3_accepted_sist_suborder" = "Suborder",
  "msw3_accepted_sist_infraorder" = "Infraorder",
  "msw3_accepted_sist_superfamily" = "Superfamily",
  "msw3_accepted_sist_family" = "Family",
  "msw3_accepted_sist_subfamily" = "Subfamily",
  "msw3_accepted_sist_tribe" = "Tribe",
  "msw3_accepted_sist_genus" = "Genus",
  "msw3_accepted_sist_subgenus" = "Subgenus",
  "msw3_accepted_sist_epithet" = "Species",
  "msw3_accepted_sist_subspecies" = "Subspecies",
  "msw3_accepted_taxon_level" = "TaxonLevel",
  "msw3_accepted_status_extinct" = "Extinct?",
  "msw3_original_name" = "OriginalName",
  "msw3_accepted_status_valid_name" = "ValidName",
  "msw3_accepted_author" = "Author",
  "msw3_accepted_author_year" = "Date",
  "msw3_accepted_author_year_corrected" = "ActualDate",
  "msw3_accepted_citation_journal" = "CitationName",
  "msw3_accepted_citation_volume" = "CitationVolume",
  "msw3_accepted_citation_issue" = "CitationIssue",
  "msw3_accepted_citation_pages" = "CitationPages",
  "msw3_accepted_citation_notes" = "CitationType",
  "msw3_type_name" = "TypeSpecies",
  "msw3_common_name" = "CommonName",
  "msw3_type_locality" = "TypeLocality",
  "msw3_accepted_distribution_notes" = "Distribution",
  "msw3_accepted_status_iucn" = "Status",
  "msw3_synonymy" = "Synonyms",
  "msw3_accepted_notes" = "Comments",
  "msw3_accepted_sort_file" = "File",
  "msw3_accepted_sort_sortorder" = "SortOrder",
  "msw3_accepted_sort_displayorder" = "DisplayOrder"
)

### Character fixing vector ###

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
  "Pi±os" = "Pinos",
  "Iba±ez" = "Ibañez",
  "Ibß±ez" = "Ibañez",
  "Tar~bulus" = "Tar'bulus"
)
