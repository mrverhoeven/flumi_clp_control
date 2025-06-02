#'---
#' title: "Analyzing plant responses from Flumioxazin control pilot projects"
#' author: "Mike Verhoeven"
#' output: 
#'    html_document:
#'       toc: true
#'       theme: default
#'       toc_depth: 3
#'       toc_float:
#'           collapsed: false
#'---

#' This script will pull in the flumioxazin data and evaluate the following quesitons: 
#' What is the effect of management on CLP?
#'   1. Density (rake toss records at each point at each site on each lake)
#'   2. Distribution (Y/N at each point at each site on each lake)
#'      Hypothesis: reduction
#' What is the effect on native species?
#'   1. Density (rake toss records at each point at each site on each lake)
#'   2. Distribution (Y/N at each point at each site on each lake)
#'      Hypothesis: nothing
#' What is the effect of CLP on native species?
#'      Hypothesis: local scale control will not change population-level effects on native communities; so, nothing
#' 
#' 
# Outstanding Work:

# EVerything!





#' # Document Preamble
knitr::opts_chunk$set(warning = FALSE, message = FALSE) 

strttime <- Sys.time()
getwd()


# load libraries ------------------------------------------------------------------

#' ## Libraries

library(data.table) 
# update_dev_pkg()# remotes::install_github("Rdatatable/data.table")
library(sf)
library(gridExtra)
library(tidyr)
library(esri2sf)
library(utils)
library(dplyr)
library(stringr)
library(ggplot2)
library(tigris)
library(ggrepel)
library(janitor)

# load in functions -------------------------------------------------------
#' ## Functions

# load in data -------------------------------------------------

#' ## Data

# Master list: 
allobs <- fread(file = "scripts&data/data/input/Export_ObsLevel.csv")

#clean up column names
allobs <- clean_names(allobs)

#date formats
allobs[ , .N ,  survey_date]
allobs[ , .N , treatment_date]

allobs[ , survey_date := as.IDate(survey_date, format = "%m/%d/%Y") ,  ]
allobs[ , treatment_date := as.IDate(treatment_date, format = "%m/%d/%Y") ,  ]

#explore

allobs[ , .N, site]

allobs[ , .N , lake_name]

allobs[ , .N , .(site, survey_purpose)][order(survey_purpose, site)]

allobs[ , .N , .(site,survey_purpose, lake_name, survey_date, k_survey_id)][order(lake_name, survey_date)]

allobs[ , .N, sample_type_descr]

allobs[ , .N , .(species_code, genus, species, lower_level_tax) ]



# clp response ------------------------------------------------------------

# compile 2 metrics for clp in ech of these surveys: rake abund where present AND foc in plot

# do for each survey
#survey table
surveydat <- allobs[ sample_type_descr == "sampled" , .("n_samp" = length(unique(sta_nbr))) , .(site,survey_purpose, lake_name, survey_date, k_survey_id) ]
# curlyleaf metrics
allobs[ sample_type_descr == "sampled" & species_code == "PC", .N , abundance ]

# foc
clp_stats <- 
allobs[sample_type_descr == "sampled" & species_code == "PC" & abundance > 0,
       .("n_clp" = length(unique(sta_nbr)),
         "mean_ra_clp" = mean(abundance)) ,
       .(site,survey_purpose, lake_name, survey_date, k_survey_id) ]

#combine
surveydat[clp_stats, on = .(k_survey_id) , c("n_clp", "mean_ra_clp")   := .(n_clp, mean_ra_clp) ]

#calc clp frequency
surveydat[ , freq := n_clp/n_samp , ]

#set factor order
surveydat[ , survey_purpose := factor(survey_purpose, levels = c("Pre", "Post", "1YAT")) , ]


#why are we getting NA values? (because these survey data )
allobs[k_survey_id %in% c(1,2) , .N , .(lake_name, survey_date, species, abundance) ]


ggplot(surveydat, aes(site, freq))+
  geom_violin()+
  geom_boxplot()+
  facet_wrap(~survey_purpose, nrow=1)


ggplot(surveydat, aes(survey_purpose, freq))+
  geom_violin()+
  geom_boxplot()+
  facet_wrap(~site, ncol=1)


ggplot(surveydat, aes(survey_purpose, freq))+
  geom_path( aes(group = lake_name))+
  facet_wrap(~site, ncol=1)















































