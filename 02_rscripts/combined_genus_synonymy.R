#### Loading packages ####
# -> Add installation option

library(groundhog)
groundhog.day <- "2024-08-01"
groundhog.packages <- c("here",
                        "readr",
                        #"tidyr",
                        "dplyr",
                        "stringr")
groundhog.library(groundhog.packages, 
                  groundhog.day)
rm(groundhog.day,
   groundhog.packages)

#### Reading data ####
## Mammal Species of The World 2005
dtf_msw3_gensyn_0 <- read_csv(here("01_data",
                                   "02_clean-data",
                                   "msw3_genus_synonymy.csv")) %>%
  select(msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
         msw3_accepted_author_name,
         msw3_accepted_author_year,
         msw3_synonym_name,
         msw3_synonym_author_name,
         msw3_synonym_author_year,
         msw3_synonym_note) %>%
  mutate(msw3_synonym_author_year = as.numeric(str_replace(msw3_synonym_author_year,
                                                           pattern = "-.",
                                                           replacement = "")))

## Mammal Diversity Database v1.13
dtf_mdd_genera <- read_csv(here("01_data",
                                "01_raw-data",
                                "MDD_v1.13_6753species.csv")) %>%   
  select(order,
         family,
         genus) %>%
  distinct() %>%
  rename(mdd_accepted_sist_order = order,
         mdd_accepted_sist_family = family,
         mdd_accepted_sist_genus = genus)

#### Preparing Mammal Species of The World 2005 data ####

# Adding all accepted genera names to synonyms column to have a full list of all 
# proposed names for each genera on the same place
dtf_msw3_gensyn_1 <- dtf_msw3_gensyn_0 %>% 
  select(msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
         msw3_accepted_author_name,
         msw3_accepted_author_year) %>%
  distinct() %>% 
  mutate(msw3_synonym_name = msw3_accepted_sist_genus,
         msw3_synonym_author_name = msw3_accepted_author_name,
         msw3_synonym_author_year = msw3_accepted_author_year,
         msw3_synonym_note = "MSW3 Accepted name") %>%
  select(msw3_accepted_sist_order,
         msw3_accepted_sist_family,
         msw3_accepted_sist_genus,
         msw3_accepted_author_name,
         msw3_accepted_author_year,
         msw3_synonym_name,
         msw3_synonym_author_name,
         msw3_synonym_author_year,
         msw3_synonym_note)

# Combining accepted genera on synonyms column with the other synonyms.
# Genera that had no prior synonyms had NA on their synonym column. These had to 
# be removed before combining tables to avoid cases where a genus had "NA" and itself
# on its synonym column.

dtf_msw3_gensyn_2 <- dtf_msw3_gensyn_0 %>%
  filter(!is.na(msw3_synonym_name)) %>%
  bind_rows(., dtf_msw3_gensyn_1)
















mdd <- dtf_mdd_genera %>%
  select(#mdd_accepted_sist_order,
         mdd_accepted_sist_genus) %>%
  distinct()

msw3 <- dtf_msw3_gensyn_2 %>%
  select(#msw3_accepted_sist_order,
         msw3_accepted_sist_genus,
         msw3_synonym_name) %>%
  distinct()

joins <- full_join(mdd, 
                   msw3, 
                   by = c("mdd_accepted_sist_genus" = "msw3_accepted_sist_genus"),
                   keep = TRUE) %>%
  filter(is.na(msw3_accepted_sist_genus) |
         is.na(mdd_accepted_sist_genus))




dtf_msw3_gensyn_1 <- dtf_msw3_gensyn_0 %>%
  mutate(msw3_accepted_sist_order = str_to_sentence(msw3_accepted_sist_order),
         msw3_accepted_sist_order = str_replace_all(msw3_accepted_sist_order, # The orders Erinaceomorpha and Soricomorpha were united under "Eulipotyphla" after 2005
                                                    pattern = "Erinaceomorpha|Soricomorpha",
                                                    replacement = "Eulipotyphla"),
         msw3_accepted_sist_order = str_replace_all(msw3_accepted_sist_order,
                                                    pattern = "Cetacea", # The order "Cetacea" was found to be nested in "Artiodactyla" after 2005
                                                    replacement = "Artiodactyla"),
         msw3_accepted_sist_family = str_replace_all(msw3_accepted_sist_family,
                                                     pattern = "Indridae", 
                                                     replacement = "Indriidae"),
         msw3_accepted_sist_family = str_replace_all(msw3_accepted_sist_family,
                                                     pattern = "Megalonychidae", 
                                                     replacement = "Choloepodidae"),
         msw3_accepted_sist_family = str_replace_all(msw3_accepted_sist_family,
                                                     pattern = "Myocastoridae|Capromyidae", 
                                                     replacement = "Echimyidae"),
         msw3_accepted_sist_family = str_replace_all(msw3_accepted_sist_family,
                                                     pattern = "Eschrichtiidae", 
                                                     replacement = "Balaenopteridae"),
         msw3_accepted_sist_family = str_replace_all(msw3_accepted_sist_family,
                                                     pattern = "Neobalaenidae", 
                                                     replacement = "Cetotheriidae"))


