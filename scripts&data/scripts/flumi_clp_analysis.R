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


#explore

allobs[ , .N, site]

allobs[ , .N , lake_name]

allobs[ , .N , .(site, survey_purpose)][order(survey_purpose, site)]

allobs[ , .N , .(site, lake_name, survey_date)][order(lake_name, survey_date)]









# clp response ------------------------------------------------------------















