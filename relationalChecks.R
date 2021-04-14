# Script to perform checks that we can't code into SQL
# Created by Kaija Gahm on 9 March 2021
options(warning.length = 5000L) # make sure full error/warning messages can be displayed.
# This script should be stored in the same folder where the database updater's "currentDB/" folder lives, i.e. one level above "currentDB/".
# This script relies on relationalChecksDefs.R, which should be stored in the same folder as relationalChecks.R.

# Load packages -----------------------------------------------------------
library(here)
library(tidyverse)

# Source the script where functions and values are defined ----------------
source(here("relationalChecksDefs.R"))

# Load files --------------------------------------------------------------
filenames <- list.files(here("currentDB"), "*.txt")
tableNames <- str_replace(filenames, "\\.txt", "")
tabs <- lapply(filenames, function(x) read.delim(here("currentDB", x), sep = "|", header = F, quote = c("\"", "\'")))
names(tabs) <- tableNames

# Check that all expected tables are present ------------------------------
# Make sure to update this list if you add or remove a database table!
expectedTables <- c("BACTERIAL_PRODUCTION_BENTHIC", 
                    "BACTERIAL_PRODUCTION_PELAGIC",
                    "BENTHIC_INVERT_SAMPLES", 
                    "BENTHIC_INVERTS",
                    "CHLOROPHYLL", 
                    "COLOR", 
                    "CREEL_BOAT_SAMPLES", 
                    "CREEL_BOATS", 
                    "CREEL_FISH", 
                    "CREEL_INFO", 
                    "CREEL_INTERVIEW", 
                    "CREEL_SAMPLES", 
                    "CREEL_TRAILER_SAMPLES", 
                    "CREEL_TRAILERS", 
                    "CREW", 
                    "DRY_MASS_EQUATIONS", 
                    "FISH_DIETS", 
                    "FISH_INFO", 
                    "FISH_MORPHOMETRICS", 
                    "FISH_OTOLITHS", 
                    "FISH_SAMPLES", 
                    "FISH_YOY", 
                    "FLIGHTS", 
                    "FLIGHTS_INFO", 
                    "FLIGHTS_SAMPLES", 
                    "GC", 
                    "ISOTOPE_BATCHES", 
                    "ISOTOPE_RESULTS", 
                    "ISOTOPE_SAMPLES_BENTHIC_INVERTS", 
                    "ISOTOPE_SAMPLES_DIC", 
                    "ISOTOPE_SAMPLES_FISH", 
                    "ISOTOPE_SAMPLES_METHANE", 
                    "ISOTOPE_SAMPLES_PERIPHYTON", 
                    "ISOTOPE_SAMPLES_POC", 
                    "ISOTOPE_SAMPLES_WATER", 
                    "ISOTOPE_SAMPLES_ZOOPS", 
                    "LAB_EXPERIMENTS", 
                    "LAKE_BATHYMETRY", 
                    "LAKES", 
                    "LAKES_GIS", 
                    "LIMNO_PROFILES",
                    "LIPID_EXTRACTIONS", 
                    "LIPID_SAMPLES",
                    "METADATA", 
                    "MOLECULAR_SAMPLE",
                    "OTU", 
                    "PIEZOMETERS_INSTALL", 
                    "PIEZOMETERS_LAKE",
                    "PIEZOMETERS_SENSORS",
                    "PIEZOMETERS_SURVEYING", 
                    "PIEZOMETERS_UPLAND", 
                    "PRIMARY_PRODUCTION_BENTHIC", 
                    "PROJECTS", 
                    "PUBLICATIONS_PRESENTATIONS", 
                    "RHODAMINE", 
                    "RHODAMINE_RELEASE", 
                    "SAMPLES", 
                    "SED_TRAP_DATA", 
                    "SED_TRAP_SAMPLES", 
                    "SEDIMENT", 
                    "SITES", 
                    "STAFF_GAUGES", 
                    "TPOC_DEPOSITION", 
                    "UNITS", 
                    "UPDATE_METADATA", 
                    "VERSION_HISTORY", 
                    "WATER_CHEM", 
                    "ZOOPS_ABUND_BIOMASS", 
                    "ZOOPS_COEFFICIENTS", 
                    "ZOOPS_LENGTHS", 
                    "ZOOPS_PRODUCTION", 
                    "ZOOPS_SUBSAMPLE")

## run the check:
expectedTablesCheck(expectedTables, tableNames)

# Set table names ---------------------------------------------------------
# BACTERIAL_PRODUCTION_BENTHIC --------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "benthicBacterialProductionVolume_ugC_L_h", 
       "benthicBacterialProductionArea_mgC_m2_h", "incubationDuration_h", 
       "metadataID", "comments", "flag", "updateID")
names(tabs[["BACTERIAL_PRODUCTION_BENTHIC"]]) <- tableNamesSet(n, "BACTERIAL_PRODUCTION_BENTHIC")

# BACTERIAL_PRODUCTION_PELAGIC --------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "BacterialProduction_ugC_L_h", 
       "incubationDuration_h", "metadataID", "comments", "updateID")
names(tabs[["BACTERIAL_PRODUCTION_PELAGIC"]]) <- tableNamesSet(n, "BACTERIAL_PRODUCTION_PELAGIC")

# BENTHIC_INVERT_SAMPLES --------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "sampleID", "dateSample", "dateTimeSample", 
       "depthClass", "depthTop", "depthBottom", "crew", "weather", "processed", 
       "comments", "metadataID", "updateID")
names(tabs[["BENTHIC_INVERT_SAMPLES"]]) <- tableNamesSet(n, "BENTHIC_INVERT_SAMPLES")

# BENTHIC_INVERTS ---------------------------------------------------------
n <- c("projectID", "sampleID", "invertID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "supergroup", "orderSample", "family", "subfamily", "tribe", 
       "genus", "otu", "pupa", "scopeID", "geneticProcess", "geneticID", 
       "confidence", "trayNumber", "invertNum", "bodyLength", "headWidth", 
       "dryMass", "picker", "comments", "flag", "metadataID", "updateID")
names(tabs[["BENTHIC_INVERTS"]]) <- tableNamesSet(n, "BENTHIC_INVERTS")

# CHLOROPHYLL --------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "runID", 
       "chl", "replicate", "metadataID", "comments", "flag", "updateID")
names(tabs[["CHLOROPHYLL"]]) <- tableNamesSet(n, "CHLOROPHYLL")

# COLOR -----------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "abs440", 
       "g440", "metadataID", "comments", "flag", "updateID")
names(tabs[["COLOR"]]) <- tableNamesSet(n, "COLOR")

# CREEL_BOAT_SAMPLES ------------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "sampleID", "boatCountID", "dateSample", "dateTimeSample", "gear", "enteredBy", "metadataID", "updateID")
names(tabs[["CREEL_BOAT_SAMPLES"]]) <- tableNamesSet(n, "CREEL_BOAT_SAMPLES")

# CREEL_BOATS ------------------------------------------------------------
n <- c("projectID", "boatCountID", "boatID", "boatNum", "vesselType", 
       "passengerCount", "fishing", "residentRover", "movingStationary", 
       "notes", "enteredBy", "metadataID", "updateID")
names(tabs[["CREEL_BOATS"]]) <- tableNamesSet(n, "CREEL_BOATS")

# CREEL_FISH -------------------------------------------------------------
n <- c("projectID", "creelID", "fishID", "creelNumber", "fishNumber", 
       "species", "speciesCode_wiDNR", "speciesCode", "fishLength", 
       "notes", "enteredBy", "metadataID", "updateID")
names(tabs[["CREEL_FISH"]]) <- tableNamesSet(n, "CREEL_FISH")

# CREEL_INFO -------------------------------------------------------------
n <- c("projectID", "sampleID", "creelID", "creelNumber", "timeOutgoingInterview", 
       "timeReturnInterview", "outgoingInterview", "returnInterview", 
       "declinedInterview", "partyActivity", "numberInParty", "vehicleUsed", 
       "timeLeftLanding", "timeNotFishing", "licenseType", "guidedTrip", 
       "completeTrip", "tournament", "notes", "enteredBy", "expectedLengthTripHours", 
       "outTarget1", "outTarget1Percent", "outTarget1Expect", "outTarget2", 
       "outTarget2Percent", "outTarget2Expect", "outTarget3", "outTarget3Percent", 
       "outTarget3Expect", "walleyePercentEffort", "walleyeNumberCaught", 
       "walleyeNumberKept", "walleyeReleaseCode", "muskellungePercentEffort", 
       "muskellungeNumberCaught", "muskellungeNumberKept", "muskellungeReleaseCode", 
       "northernPikePercentEffort", "northernPikeNumberCaught", "northernPikeNumberKept", 
       "northernPikeReleaseCode", "largemouthBassPercentEffort", "largemouthBassNumberCaught", 
       "largemouthBassNumberKept", "largemouthBassReleaseCode", "smallmouthBassPercentEffort", 
       "smallmouthBassNumberCaught", "smallmouthBassNumberKept", "smallmouthBassReleaseCode", 
       "panfishGeneralEffort", "panfishGeneralNumber", "panfishGeneralNumberKept", 
       "panfishGeneralReleaseCode", "bluegillPercentEffort", "bluegillNumberCaught", 
       "bluegillNumberKept", "bluegillReleaseCode", "yellowPerchPercentEffort", 
       "yellowPerchNumberCaught", "yellowPerchNumberKept", "yellowPerchReleaseCode", 
       "blackCrappiePercentEffort", "blackCrappieNumberCaught", "blackCrappieNumberKept", 
       "blackCrappieReleaseCodes", "additionalSpeciesName", "additionalSpeciesPercentEffort", 
       "additionalSpeciesNumberCaught", "additionalSpeciesNumberKept", 
       "additionalSpeciesReleaseCode", "additionalSpecies2Name", "additionalSpecies2PercentEffort", 
       "additionalSpecies2NumberCaught", "additionalSpecies2NumberKept", 
       "additionalSpecies2ReleaseCode", "metadataID", "updateID")
names(tabs[["CREEL_INFO"]]) <- tableNamesSet(n, "CREEL_INFO")

# CREEL_INTERVIEW -----------------------------------------------------------
n <- c("projectID", "sampleID", "creelID", "creelNumber", "timeInterview", 
       "dataRecorder", "placeStaying", "locLakeAny", "locLakeThis", 
       "travelTime", "homeZip", "sourceFriends", "sourceStore", "sourceDNR", 
       "sourceForums", "sourceApps", "sourcePersonal", "sourceOther", 
       "sourceOtherName", "rankFriends", "rankStore", "rankDNR", "rankForums", 
       "rankApps", "rankPersonal", "rankOther", "tellFriendsLastTime", 
       "tellStoreLastTime", "tellDNRLastTime", "tellForumsLastTime", 
       "tellAppsLastTime", "tellOtherLastTime", "tellOtherNameLastTime", 
       "tellFriends", "tellStore", "tellDNR", "tellForums", "tellApp", 
       "tellOther", "tellOtherName", "fishingDays", "fishingDaysLakeYear", 
       "species1Name", "fishingDaysSpecies1", "species2Name", "fishingDaysSpecies2", 
       "species3Name", "fishingDaysSpecies3", "species4Name", "fishingDaysSpecies4", 
       "lakesPastWeek", "lakesPastMonth", "lakesPastYear", "satisfactionOverall", 
       "satisfactionNumber", "satisfactionSize", "lifeRevolves", "trophySpots", 
       "mostEnjoyable", "significantIncome", "specialGear", "enjoyable", 
       "noTimeHobbies", "maximizeNumbers", "noAlternative", "friendsFish", 
       "releaseFish", "loseFriends", "bigSmall", "otherLeisure", "keepFishing", 
       "stocked", "knowWhenStocked", "whenStocked", "whenDecided", "alternativeLakes", 
       "secondChoice", "whyThisLake", "whyStop", "metadataID", "updateID")
names(tabs[["CREEL_INTERVIEW"]]) <- tableNamesSet(n, "CREEL_INTERVIEW")

# CREEL_SAMPLES -------------------------------------------------------------
n <- c("siteID", "sampleID", "dayOfYear", "dateSet", "dateSample", 
       "dateTimeSet", "dateTimeSample", "crew", "gear", "sampleGroup", 
       "effort", "effortUnits", "useEffort", "weather", "comments", 
       "metadataID", "updateID")
names(tabs[["CREEL_SAMPLES"]]) <- tableNamesSet(n, "CREEL_SAMPLES")

# CREEL_TRAILER_SAMPLES --------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "sampleID", "trailerCountID", "dateSample", "dateTimeSample", "gear", "trailerCount", 
       "vehiclePresent", "heavyWind", "heavyRain", "heavyClouds", "notes", 
       "enteredBy", "metadataID", "updateID")
names(tabs[["CREEL_TRAILER_SAMPLES"]]) <- tableNamesSet(n, "CREEL_TRAILER_SAMPLES")

# CREEL_TRAILERS -------------------------------------------------------------
n <- c("projectID", "trailerCountID", "trailerID", "trailerNum", "wisconsinPlates", 
       "metadataID", "updateID")
names(tabs[["CREEL_TRAILERS"]]) <- tableNamesSet(n, "CREEL_TRAILERS")

# CREW -------------------------------------------------------------
n <- c("ID", "year", "semester", "location", "role", "firstname", 
       "lastname", "nickname", "affiliation", "notes", "updateID")
names(tabs[["CREW"]]) <- tableNamesSet(n, "CREW")

# DRY_MASS_EQUATIONS -------------------------------------------------------------
n <- c("OTU", "headWidth_a", "headWidth_b", "bodyLength_a", "bodyLength_b", 
       "bodyLength_b1", "equation", "reference", "referenceEquation", 
       "comments", "metadataID", "updateID")
names(tabs[["DRY_MASS_EQUATIONS"]]) <- tableNamesSet(n, "DRY_MASS_EQUATIONS")

# FISH_DIETS -------------------------------------------------------------
n <- c("fishID", "entryOrder", "lakeID", "dateSample", "species", 
       "dietItem", "dietItemCount", "dietItemBodyLength", "dietItemHeadWidth", 
       "otherLength", "dietItemRangeLower", "dietItemRangeHigher", "dryMass_bodylength", 
       "dryMass_headwidth", "dryMass_other", "totalDryMass", "dietProcessor", 
       "comments", "metadataID", "updateID")
names(tabs[["FISH_DIETS"]]) <- tableNamesSet(n, "FISH_DIETS")

# FISH_INFO -------------------------------------------------------------
n <- c("projectID", "sampleID", "fishID", "fishNum", "species", "fishLength", 
       "standardLength", "fishWeight", "caughtBy", "jumperDescription", 
       "useTagMarkRecap", "clipApply", "clipRecapture", "floyApply", 
       "floyRecapture", "pitApply", "pitRecapture", "sex", "mortality", 
       "removed", "otolithSampled", "tissueSampled", "dietSampled", 
       "stomachRemoved", "gillArchRemoved", "pectoralFinRemoved", "gonadRemoved", 
       "leftEyeRemoved", "finClipCollected", "photo", "gonadWeight", 
       "rectalTemp", "gonadSqueeze", "sexualStage_MaierScale", "gpsWaypoint", 
       "finClipBox", "spineSample", "scaleSample", "comments", "metadataID", 
       "updateID")
names(tabs[["FISH_INFO"]]) <- tableNamesSet(n, "FISH_INFO")

# FISH_MORPHOMETRICS -------------------------------------------------------------
n <- c("fishID", "imageFile", "parameter", "parameterValue", "parameterUnit",
       "processedBy", "replicate", "metadataID", "updateID")
names(tabs[["FISH_MORPHOMETRICS"]]) <- tableNamesSet(n, "FISH_MORPHOMETRICS")

# FISH_OTOLITHS -------------------------------------------------------------
n <- c("fishID", "wellNumber", "otolith", "parameter", "year", "annulusNumber", 
       "paramValue", "unit", "interpreter", "interpretationNumber", 
       "interpretationDateTime", "metadataID", "confidence", "comments", 
       "updateID")
names(tabs[["FISH_OTOLITHS"]]) <- tableNamesSet(n, "FISH_OTOLITHS")

# FISH_SAMPLES -------------------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "sampleID", "dayOfYear", "dateSet", "dateSample", 
       "dateTimeSet", "dateTimeSample", "crew", "gear", "sampleGroup", 
       "effort", "effortUnits", "distanceShocked", "useCPUE", "useSampleMarkRecap", 
       "comments", "metadataID", "updateID")
names(tabs[["FISH_SAMPLES"]]) <- tableNamesSet(n, "FISH_SAMPLES")

# FISH_YOY -------------------------------------------------------------
n <- c("projectID", "siteID", "sampleID", "fishID", "fishNum", "species", 
       "YOY", "plus1", "fishLengthMin", "fishLengthMax", "comments", 
       "metadataID", "updateID")
names(tabs[["FISH_YOY"]]) <- tableNamesSet(n, "FISH_YOY")

# FLIGHTS_INFO -------------------------------------------------------------
n <- c("projectID", "sampleID", "boatID", "boatNum", "vesselType", 
       "fishing", "moving", "updateID")
names(tabs[["FLIGHTS_INFO"]]) <- tableNamesSet(n, "FLIGHTS_INFO")

# FLIGHTS_SAMPLES -------------------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "flightID", "sampleID", "dateSample", "dateTimeSample", "gear", "boatCount", "metadataID", "updateID")
names(tabs[["FLIGHTS_SAMPLES"]]) <- tableNamesSet(n, "FLIGHTS_SAMPLES")

# FLIGHTS -------------------------------------------------------------
n <- c("projectID", "flightID", "dateSample", "dateTimeSample", "boatCount", 
       "lakeCount", "crew", "comments", "metadataID", "updateID")
names(tabs[["FLIGHTS"]]) <- tableNamesSet(n, "FLIGHTS")

# GC -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "subsampleClass", 
       "subsampleDateTime", "runID", "runDate", "replicate", "metadataID", 
       "runName", "comments", "CH4PeakArea", "CO2PeakArea", "CH4ppm", 
       "CO2ppm", "CH4_uM", "CO2_uM", "updateID")
names(tabs[["GC"]]) <- tableNamesSet(n, "GC")

# ISOTOPE_BATCHES -------------------------------------------------------------
n <- c("batchID", "IsotopeLab", "dateSent", "dateReceived", "sampleDescription", 
       "instrument", "CEST_User", "updateID")
names(tabs[["ISOTOPE_BATCHES"]]) <- tableNamesSet(n, "ISOTOPE_BATCHES")

# ISOTOPE_RESULTS -------------------------------------------------------------
n <- c("isotopeID", "sampleWt", "d13C", "d15N", "d2H", "d18O", "percentC", 
       "percentN", "percentH", "dateRun", "lab", "batchID", "replicate", 
       "metadataID", "comments", "flag", "updateID")
names(tabs[["ISOTOPE_RESULTS"]]) <- tableNamesSet(n, "ISOTOPE_RESULTS")

# ISOTOPE_SAMPLES_BENTHIC_INVERTS -------------------------------------------------------------
n <- c("projectID", "isotopeID", "sampleID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "taxa", "batchID", "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_BENTHIC_INVERTS"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_BENTHIC_INVERTS")

# ISOTOPE_SAMPLES_DIC -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "batchID", "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_DIC"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_DIC")

# ISOTOPE_SAMPLES_FISH -------------------------------------------------------------
n <- c("projectID", "isotopeID", "fishID", "lakeID", "species", "batchID", 
       "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_FISH"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_FISH")

# ISOTOPE_SAMPLES_METHANE -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "dateSample", "dateTimeSample", 
       "lakeID", "siteName", "depthClass", "depthTop", "depthBottom", 
       "batchID", "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_METHANE"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_METHANE")

# ISOTOPE_SAMPLES_PERIPHYTON -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "source", "batchID", "comments", "metadataID", "updateID")
names(tabs[["ISOTOPE_SAMPLES_PERIPHYTON"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_PERIPHYTON")

# ISOTOPE_SAMPLES_POC -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "filterVol", "sampleType", "sampleAmount", "batchID", "comments", 
       "updateID")
names(tabs[["ISOTOPE_SAMPLES_POC"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_POC")

# ISOTOPE_SAMPLES_WATER -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "batchID", "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_WATER"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_WATER")

# ISOTOPE_SAMPLES_ZOOPS -------------------------------------------------------------
n <- c("projectID", "sampleID", "isotopeID", "lakeID", "siteName", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "batchID", "comments", "updateID")
names(tabs[["ISOTOPE_SAMPLES_ZOOPS"]]) <- tableNamesSet(n, "ISOTOPE_SAMPLES_ZOOPS")

# LAB_EXPERIMENTS -------------------------------------------------------------
n <- c("experimentID", "location", "experimentDescription", "dateStart", 
       "dateEnd", "researcher", "result", "files", "parentBoxFolder", 
       "updateID")
names(tabs[["LAB_EXPERIMENTS"]]) <- tableNamesSet(n, "LAB_EXPERIMENTS")

# LAKE_BATHYMETRY -------------------------------------------------------------
n <- c("lakeID", "lakeName", "depth_m", "area_m2", "sedimentArea3D_m2", 
       "layerVolume_m3", "volumeToBottom_m3", "volumeToBottom3D_m3", 
       "source", "metadataID", "updateID")
names(tabs[["LAKE_BATHYMETRY"]]) <- tableNamesSet(n, "LAKE_BATHYMETRY")

# LAKES_GIS -------------------------------------------------------------
n <- c("lakeID", "watershedID", "water", "urban_openSpace", "urban_lowintensity", 
       "urban_mediumintensity", "urban_highintensity", "barrenLand", 
       "deciduousForest", "evergreenForest", "mixedForest", "shrub_scrub", 
       "grassland_herbaceous", "pasture_hay", "cultivatedCrops", "woodyWetlands", 
       "emergentHerbaceousWetlands", "totalArea", "updateID")
names(tabs[["LAKES_GIS"]]) <- tableNamesSet(n, "LAKES_GIS")

# LAKES -------------------------------------------------------------
n <- c("lakeID", "lakeName", "state", "county", "city", "surfaceArea", 
       "maxDepth", "lat", "long", "latLongSource", "WBIC", "comments", 
       "updateID")
names(tabs[["LAKES"]]) <- tableNamesSet(n, "LAKES")

# LIMNO_PROFILES -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "temp", 
       "DOmgL", "DOsat", "SpC", "pH", "ORP", "PAR", "metadataID", "comments", 
       "updateID")
names(tabs[["LIMNO_PROFILES"]]) <- tableNamesSet(n, "LIMNO_PROFILES")

# LIPID_EXTRACTIONS -------------------------------------------------------------
n <- c("extractionID", "extractionDate", "lipidID", "extractionWt_mg", 
       "lipidWt_mg", "metadataID", "totalFilterVol_mL", "comments", 
       "updateID")
names(tabs[["LIPID_EXTRACTIONS"]]) <- tableNamesSet(n, "LIPID_EXTRACTIONS")

# LIPID_SAMPLES -------------------------------------------------------------
n <- c("projectID", "sampleID", "lipidID", "lakeID", "siteName", "dateSample", 
       "depthClass", "depthTop", "depthBottom", "sampleType", "taxa", 
       "filterVolume_mL", "comments", "updateID")
names(tabs[["LIPID_SAMPLES"]]) <- tableNamesSet(n, "LIPID_SAMPLES")

# METADATA -------------------------------------------------------------
n <- c("metadataID", "dateCreated", "metadata", "file", "filePath", 
       "updateID")
names(tabs[["METADATA"]]) <- tableNamesSet(n, "METADATA")

# MOLECULAR_SAMPLE -------------------------------------------------------------
n <- c("projectID", "sampleID", "molecularID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "sampleType", 
       "filterVol", "boxNum", "cellNum", "remainingSample", "metadataID", 
       "comments", "updateID")
names(tabs[["MOLECULAR_SAMPLE"]]) <- tableNamesSet(n, "MOLECULAR_SAMPLE")

# OTU -------------------------------------------------------------
n <- c("habitat", "grouping", "supergroup", "orderTax", "family", 
       "subfamily", "tribe", "genus", "species", "commonName", "abbreviation", 
       "otu", "updateID")
names(tabs[["OTU"]]) <- tableNamesSet(n, "OTU")

# PIEZOMETERS_INSTALL -------------------------------------------------------------
n <- c("siteID", "installDate", "removalDate", "piezLength_m", "piezDiameter_m", 
       "heightAboveSeds_m", "insertionDepth_m", "waterDepth_m", "screenHeight_m", 
       "screenLength_m", "screenInterval_m", "conductivity_m_day", "metadataID", 
       "comments", "updateID")
names(tabs[["PIEZOMETERS_INSTALL"]]) <- tableNamesSet(n, "PIEZOMETERS_INSTALL")

# PIEZOMETERS_LAKE -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "lakeLevel_m", 
       "wellLevel_m", "pumped", "wellLevelCorrected_m", "hydraulicHead_m", 
       "metadataID", "comments", "flag", "updateID")
names(tabs[["PIEZOMETERS_LAKE"]]) <- tableNamesSet(n, "PIEZOMETERS_LAKE")

# PIEZOMETERS_SENSORS -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "wellLevel_m", 
       "wellLevelCorrected_m", "chainLength_m", "eyeBoltBelowTopOfPiez_m", 
       "sensorDepth_m", "metadataID", "comments", "updateID")
names(tabs[["PIEZOMETERS_SENSORS"]]) <- tableNamesSet(n, "PIEZOMETERS_SENSORS")

# PIEZOMETERS_SURVEYING -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "surveyTrackID", 
       "dateSample", "dateTimeSample", "depthClass", "depthTop", "depthBottom", 
       "topOfPiezAboveLakeLevel_m", "metadataID", "comments", "updateID")
names(tabs[["PIEZOMETERS_SURVEYING"]]) <- tableNamesSet(n, "PIEZOMETERS_SURVEYING")

# PIEZOMETERS_UPLAND -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "wellLevel_m", 
       "pumped", "wellLevelCorrected_m", "wellHeightAboveGround_m", 
       "waterTable_m", "metadataID", "comments", "updateID")
names(tabs[["PIEZOMETERS_UPLAND"]]) <- tableNamesSet(n, "PIEZOMETERS_UPLAND")

# PRIMARY_PRODUCTION_BENTHIC -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "benthicRespiration_mgC_m2_h", 
       "benthicNPP_mgC_m2_h", "benthicGPP_mgC_m2_h", "incubationDuration_h", 
       "metadataID", "comments", "updateID")
names(tabs[["PRIMARY_PRODUCTION_BENTHIC"]]) <- tableNamesSet(n, "PRIMARY_PRODUCTION_BENTHIC")

# PROJECTS -------------------------------------------------------------
n <- c("projectID", "projectName", "description", "projectLead", "responsiblePI", 
       "startYear", "updateID")
names(tabs[["PROJECTS"]]) <- tableNamesSet(n, "PROJECTS")

# PUBLICATIONS_PRESENTATIONS -------------------------------------------------------------
n <- c("date", "leadAuthor", "journal_location", "title", "type", 
       "citation", "updateID")
names(tabs[["PUBLICATIONS_PRESENTATIONS"]]) <- tableNamesSet(n, "PUBLICATIONS_PRESENTATIONS")

# RHODAMINE_RELEASE -------------------------------------------------------------
n <- c("projectID", "siteID", "lakeID", "siteName", "rhodID", "rhodReleaseDate", 
       "depthClass", "depthTop", "depthBottom", "crew", "rhodReleaseType", 
       "rhodReleaseVolume", "metadataID", "comments", "updateID")
names(tabs[["RHODAMINE_RELEASE"]]) <- tableNamesSet(n, "RHODAMINE_RELEASE")

# RHODAMINE -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "rhodID", 
       "ppb", "metadataID", "comments", "updateID")
names(tabs[["RHODAMINE"]]) <- tableNamesSet(n, "RHODAMINE")

# SAMPLES -------------------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "sampleID", "dateSample", "dateTimeSample", 
       "depthClass", "depthTop", "depthBottom", "crew", "weather", "comments", 
       "metadataID", "updateID")
names(tabs[["SAMPLES"]]) <- tableNamesSet(n, "SAMPLES")

# SED_TRAP_DATA -------------------------------------------------------------
n <- c("projectID", "sampleID", "totalVolmL", "volFilteredmL", "parameter", 
       "parameterValue", "flag", "comments", "metadataID", "updateID")
names(tabs[["SED_TRAP_DATA"]]) <- tableNamesSet(n, "SED_TRAP_DATA")

# SED_TRAP_SAMPLES -------------------------------------------------------------
n <- c("lakeID", "projectID", "siteName", "sampleID", "dateTimeSet", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "comments", 
       "metadataID", "updateID")
names(tabs[["SED_TRAP_SAMPLES"]]) <- tableNamesSet(n, "SED_TRAP_SAMPLES")

# SEDIMENT -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "wetMass", 
       "dryMass", "ashedMass", "percentOrganic", "metadataID", "comments", 
       "updateID")
names(tabs[["SEDIMENT"]]) <- tableNamesSet(n, "SEDIMENT")

# SITES -------------------------------------------------------------
n <- c("siteID", "lakeID", "siteName", "lat", "long", "UTM", "updateID")
names(tabs[["SITES"]]) <- tableNamesSet(n, "SITES")

# STAFF_GAUGES -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "waterHeight", 
       "waterHeightUnits", "waterHeight_m", "metadataID", "comments", 
       "updateID")
names(tabs[["STAFF_GAUGES"]]) <- tableNamesSet(n, "STAFF_GAUGES")

# TPOC_DEPOSITION -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "tPOCdepGreater35_mgC_m2_d", 
       "tPOCdepLess35_mgC_m2_d", "incubationDuration_h", "metadataID", 
       "comments", "updateID")
names(tabs[["TPOC_DEPOSITION"]]) <- tableNamesSet(n, "TPOC_DEPOSITION")

# UNITS -------------------------------------------------------------
n <- c("tableName", "colName", "units", "description", "updateID")
names(tabs[["UNITS"]]) <- tableNamesSet(n, "UNITS")

# UPDATE_METADATA -------------------------------------------------------------
n <- c("updateID", "updateDate", "verNumber", "rawFile", "parentBoxFolder", 
       "sourceCode", "updaterInitials", "updateMetadata")
names(tabs[["UPDATE_METADATA"]]) <- tableNamesSet(n, "UPDATE_METADATA")

# VERSION_HISTORY -------------------------------------------------------------
n <- c("dbDateCreate", "verNumber", "updater", "dbTitle", "status", 
       "updateInfo")
names(tabs[["VERSION_HISTORY"]]) <- tableNamesSet(n, "VERSION_HISTORY")

# WATER_CHEM -------------------------------------------------------------
n <- c("projectID", "lakeID", "sampleID", "dateSample", "parameter", 
       "parameterValue", "QCcode", "flag", "comments", "metadataID", 
       "updateID")
names(tabs[["WATER_CHEM"]]) <- tableNamesSet(n, "WATER_CHEM")

# ZOOPS_ABUND_BIOMASS -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "taxa", 
       "count", "meanMass_ug", "abundance_num_m3", "biomass_gDryMass_m3", 
       "metadataID", "comments", "updateID")
names(tabs[["ZOOPS_ABUND_BIOMASS"]]) <- tableNamesSet(n, "ZOOPS_ABUND_BIOMASS")

# ZOOPS_COEFFICIENTS -------------------------------------------------------------
n <- c("taxa", "slope", "intercept", "equation", "comments", "updateID")
names(tabs[["ZOOPS_COEFFICIENTS"]]) <- tableNamesSet(n, "ZOOPS_COEFFICIENTS")

# ZOOPS_LENGTHS -------------------------------------------------------------
n <- c("projectID", "sampleID", "zoopID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "taxa", 
       "length", "width", "mass", "eggs", "metadataID", "updateID")
names(tabs[["ZOOPS_LENGTHS"]]) <- tableNamesSet(n, "ZOOPS_LENGTHS")

# ZOOPS_PRODUCTION -------------------------------------------------------------
n <- c("projectID", "lakeID", "siteID", "yearSample", "taxa", "production", 
       "prodSD", "seasonalSD", "production_m3", "prodSD_m3", "seasonalSD_m3", 
       "production_eggRatio", "metadataID", "comments", "updateID")
names(tabs[["ZOOPS_PRODUCTION"]]) <- tableNamesSet(n, "ZOOPS_PRODUCTION")

# ZOOPS_SUBSAMPLE -------------------------------------------------------------
n <- c("projectID", "sampleID", "lakeID", "siteName", "dateSample", 
       "dateTimeSample", "depthClass", "depthTop", "depthBottom", "wtEmpty", 
       "wtFull", "wtSubsample", "metadataID", "comments", "updateID")
names(tabs[["ZOOPS_SUBSAMPLE"]]) <- tableNamesSet(n, "ZOOPS_SUBSAMPLE")

# Check that no metadataID's contain underscores --------------------------
## Pull out all the unique metadataID's for any tables that have a metadataID column
metadataIDs <- tabs %>% 
  lapply(., function(x){if("metadataID" %in% names(x)){
    x %>% 
      pull(metadataID) %>% 
      unique()
  }else{
    return(NULL)
  }}
  )
### determine whether each table contains underscores in its metadataID column
isProblem <- lapply(metadataIDs, function(x) any(str_detect(x, "_"))) %>%
  unlist() %>%
  unname()
### return the names of the problem tables in an error message
problemTables <- names(tabs)[isProblem]
if(length(problemTables) > 0){
  stop("The following tables include metadataID's containing underscores (_): ", paste0(problemTables, collapse = ", "), "\n Because sampleID components must not contain underscores, this is likely to cause problems in the following relational checks. Please remove underscores from all metadataID's.")
}

# Run checks for each table ------------------------------------------------
# BACTERIAL_PRODUCTION_BENTHIC 
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "projectID", "PROJECTS", "projectID")
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "sampleID", "SAMPLES", "sampleID")
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "lakeID", "LAKES", "lakeID")
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "siteName", "SITES", "siteName")
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "metadataID", "METADATA", "metadataID")
fkCheck("BACTERIAL_PRODUCTION_BENTHIC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "lakeID", start = 1, end = 1)
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "siteName", start = 2, end = 2)
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "dateSample", start = 3, end = 3)
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "dateTimeSample", start = 3, end = 4)
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "depthClass", start = 5, end = 5)
sCheck("BACTERIAL_PRODUCTION_BENTHIC", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("BACTERIAL_PRODUCTION_BENTHIC", "depthClass", depthClassValues)

# BACTERIAL_PRODUCTION_PELAGIC
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "projectID", "PROJECTS", "projectID")
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "sampleID", "SAMPLES", "sampleID")
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "lakeID", "LAKES", "lakeID")
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "siteName", "SITES", "siteName")
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "metadataID", "METADATA", "metadataID")
fkCheck("BACTERIAL_PRODUCTION_PELAGIC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "lakeID", start = 1, end = 1)
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "siteName", start = 2, end = 2)
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "dateSample", start = 3, end = 3)
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "dateTimeSample", start = 3, end = 4)
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "depthClass", start = 5, end = 5)
sCheck("BACTERIAL_PRODUCTION_PELAGIC", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("BACTERIAL_PRODUCTION_PELAGIC", "depthClass", depthClassValues)

# BENTHIC_INVERT_SAMPLES 
fkCheck("BENTHIC_INVERT_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("BENTHIC_INVERT_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("BENTHIC_INVERT_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("BENTHIC_INVERT_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("BENTHIC_INVERT_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("BENTHIC_INVERT_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("BENTHIC_INVERT_SAMPLES", "siteID", start = 1, end = 2)
sCheck("BENTHIC_INVERT_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("BENTHIC_INVERT_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("BENTHIC_INVERT_SAMPLES", "depthClass", start = 5, end = 5)
sCheck("BENTHIC_INVERT_SAMPLES", "depthBottom", start = 6, end = 6)
sCheck("BENTHIC_INVERT_SAMPLES", "metadataID", start = 7, end = 7)
## Allowed values checks
avCheck("BENTHIC_INVERT_SAMPLES", "depthClass", depthClassValues)

# BENTHIC_INVERTS
fkCheck("BENTHIC_INVERTS", "projectID", "PROJECTS", "projectID")
# fkCheck("BENTHIC_INVERTS", "sampleID", "BENTHIC_INVERT_SAMPLES", "sampleID") # unverified
fkCheck("BENTHIC_INVERTS", "lakeID", "LAKES", "lakeID")
fkCheck("BENTHIC_INVERTS", "siteName", "SITES", "siteName")
fkCheck("BENTHIC_INVERTS", "otu", "OTU", "otu")
fkCheck("BENTHIC_INVERTS", "metadataID", "METADATA", "metadataID")
fkCheck("BENTHIC_INVERTS", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("BENTHIC_INVERTS", "lakeID", start = 1, end = 1)
sCheck("BENTHIC_INVERTS", "siteName", start = 2, end = 2)
sCheck("BENTHIC_INVERTS", "dateSample", start = 3, end = 3)
sCheck("BENTHIC_INVERTS", "dateTimeSample", start = 3, end = 4)
sCheck("BENTHIC_INVERTS", "depthClass", start = 5, end = 5)
sCheck("BENTHIC_INVERTS", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("BENTHIC_INVERTS", "depthClass", depthClassValues)

# CHLOROPHYLL 
fkCheck("CHLOROPHYLL", "projectID", "PROJECTS", "projectID")
fkCheck("CHLOROPHYLL", "lakeID", "LAKES", "lakeID")
fkCheck("CHLOROPHYLL", "siteName", "SITES", "siteName")
fkCheck("CHLOROPHYLL", "metadataID", "METADATA", "metadataID")
fkCheck("CHLOROPHYLL", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("CHLOROPHYLL", "lakeID", start = 1, end = 1)
sCheck("CHLOROPHYLL", "siteName", start = 2, end = 2)
sCheck("CHLOROPHYLL", "dateSample", start = 3, end = 3)
sCheck("CHLOROPHYLL", "dateTimeSample", start = 3, end = 4)
sCheck("CHLOROPHYLL", "depthClass", start = 5, end = 5)
sCheck("CHLOROPHYLL", "depthBottom", start = 6, end = 6) 
## Allowed values checks
avCheck("CHLOROPHYLL", "depthClass", depthClassValues)

# COLOR 
fkCheck("COLOR", "projectID", "PROJECTS", "projectID")
fkCheck("COLOR", "lakeID", "LAKES", "lakeID")
fkCheck("COLOR", "siteName", "SITES", "siteName")
fkCheck("COLOR", "metadataID", "METADATA", "metadataID")
fkCheck("COLOR", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("COLOR", "lakeID", start = 1, end = 1)
sCheck("COLOR", "siteName", start = 2, end = 2)
sCheck("COLOR", "dateSample", start = 3, end = 3)
sCheck("COLOR", "dateTimeSample", start = 3, end = 4)
sCheck("COLOR", "depthClass", start = 5, end = 5)
sCheck("COLOR", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("COLOR", "depthClass", depthClassValues)

# CREEL_BOAT_SAMPLES 
fkCheck("CREEL_BOAT_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_BOAT_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("CREEL_BOAT_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("CREEL_BOAT_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_BOAT_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("CREEL_BOAT_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("CREEL_BOAT_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("CREEL_BOAT_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("CREEL_BOAT_SAMPLES", "gear", start = 5, end = 5)
sCheck("CREEL_BOAT_SAMPLES", "metadataID", start = 6, end = 6)

# CREEL_BOATS 
fkCheck("CREEL_BOATS", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_BOATS", "boatCountID", "CREEL_BOAT_SAMPLES", "boatCountID")
fkCheck("CREEL_BOATS", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_BOATS", "updateID", "UPDATE_METADATA", "updateID")

# CREEL_FISH 
fkCheck("CREEL_FISH", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_FISH", "creelID", "CREEL_INFO", "creelID")
fkCheck("CREEL_FISH", "species", "OTU", "otu")
fkCheck("CREEL_FISH", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_FISH", "updateID", "UPDATE_METADATA", "updateID") 

# CREEL_INFO 
fkCheck("CREEL_INFO", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_INFO", "sampleID", "CREEL_SAMPLES", "sampleID")
fkCheck("CREEL_INFO", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_INFO", "updateID", "UPDATE_METADATA", "updateID")

# CREEL_INTERVIEW 
fkCheck("CREEL_INTERVIEW", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_INTERVIEW", "sampleID", "CREEL_SAMPLES", "sampleID")
fkCheck("CREEL_INTERVIEW", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_INTERVIEW", "updateID", "UPDATE_METADATA", "updateID")

# CREEL_SAMPLES 
fkCheck("CREEL_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("CREEL_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("CREEL_SAMPLES", "siteID", start = 1, end = 2)
sCheck("CREEL_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("CREEL_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("CREEL_SAMPLES", "gear", start = 5, end = 5)
sCheck("CREEL_SAMPLES", "metadataID", start = 6, end = 6)

# CREEL_TRAILER_SAMPLES 
fkCheck("CREEL_TRAILER_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_TRAILER_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("CREEL_TRAILER_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("CREEL_TRAILER_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_TRAILER_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("CREEL_TRAILER_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("CREEL_TRAILER_SAMPLES", "siteID", start = 1, end = 2)
sCheck("CREEL_TRAILER_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("CREEL_TRAILER_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("CREEL_TRAILER_SAMPLES", "gear", start = 5, end = 5)
sCheck("CREEL_TRAILER_SAMPLES", "metadataID", start = 6, end = 6)

# CREEL_TRAILERS 
fkCheck("CREEL_TRAILERS", "projectID", "PROJECTS", "projectID")
fkCheck("CREEL_TRAILERS", "trailerCountID", "CREEL_TRAILER_SAMPLES", "trailerCountID")
fkCheck("CREEL_TRAILERS", "metadataID", "METADATA", "metadataID")
fkCheck("CREEL_TRAILERS", "updateID", "UPDATE_METADATA", "updateID")

# CREW 
fkCheck("CREW", "updateID", "UPDATE_METADATA", "updateID")

# DRY_MASS_EQUATIONS 
fkCheck("DRY_MASS_EQUATIONS", "OTU", "OTU", "otu")
fkCheck("DRY_MASS_EQUATIONS", "metadataID", "METADATA", "metadataID")
fkCheck("DRY_MASS_EQUATIONS", "updateID", "UPDATE_METADATA", "updateID")

# FISH_DIETS 
fkCheck("FISH_DIETS", "fishID", "FISH_INFO", "fishID")
fkCheck("FISH_DIETS", "lakeID", "LAKES", "lakeID")
fkCheck("FISH_DIETS", "species", "OTU", "otu")
fkCheck("FISH_DIETS", "dietItem", "OTU", "otu")
fkCheck("FISH_DIETS", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_DIETS", "updateID", "UPDATE_METADATA", "updateID")

# FISH_INFO 
fkCheck("FISH_INFO", "projectID", "PROJECTS", "projectID")
#fkCheck("FISH_INFO", "sampleID", "FISH_SAMPLES", "sampleID") # XXX still outstanding. Apparently the assumptions I made about these don't work.
#fkCheck("FISH_INFO", "species", "OTU", "otu") # fails. See script for issue 17: this is one of the big outstanding ones. XXX
fkCheck("FISH_INFO", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_INFO", "updateID", "UPDATE_METADATA", "updateID")
## Allowed values checks
# avCheck("FISH_INFO", "sex", fishSexValues) # XXX fails

# FISH_MORPHOMETRICS 
fkCheck("FISH_MORPHOMETRICS", "fishID", "FISH_INFO", "fishID")
fkCheck("FISH_MORPHOMETRICS", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_MORPHOMETRICS", "updateID", "UPDATE_METADATA", "updateID")
## Allowed value checks
avCheck("FISH_MORPHOMETRICS", "parameter", fishMorphometricsParameterValues)

# FISH_OTOLITHS 
# fkCheck("FISH_OTOLITHS", "fishID", "FISH_INFO", "fishID") # fails: this is still outstanding. It's the fish 12 (vs 1 or 2) issue. Chris is looking into this, and I will follow up at the 3/30 meeting. XXX Edit: because I had issues resolving the fishID's in FISH_INFO, there are some problems with the rest of these too.
fkCheck("FISH_OTOLITHS", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_OTOLITHS", "updateID", "UPDATE_METADATA", "updateID")
## Allowed value checks
avCheck("FISH_OTOLITHS", "parameter", fishOtolithsParameterValues)

# FISH_SAMPLES 
fkCheck("FISH_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("FISH_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("FISH_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("FISH_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("FISH_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("FISH_SAMPLES", "siteID", start = 1, end = 2)
sCheck("FISH_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("FISH_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("FISH_SAMPLES", "gear", start = 5, end = 5)
sCheck("FISH_SAMPLES", "metadataID", start = 6, end = 6)

# FISH_YOY 
fkCheck("FISH_YOY", "projectID", "PROJECTS", "projectID")
fkCheck("FISH_YOY", "siteID", "SITES", "siteID")
fkCheck("FISH_YOY", "sampleID", "FISH_SAMPLES", "sampleID")
fkCheck("FISH_YOY", "species", "OTU", "otu")
fkCheck("FISH_YOY", "metadataID", "METADATA", "metadataID")
fkCheck("FISH_YOY", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("FISH_YOY", "siteID", start = 1, end = 2)

# FLIGHTS 
fkCheck("FLIGHTS", "projectID", "PROJECTS", "projectID")
fkCheck("FLIGHTS", "metadataID", "METADATA", "metadataID")
fkCheck("FLIGHTS", "updateID", "UPDATE_METADATA", "updateID")

# FLIGHTS_INFO 
fkCheck("FLIGHTS_INFO", "projectID", "PROJECTS", "projectID")
fkCheck("FLIGHTS_INFO", "sampleID", "FLIGHTS_SAMPLES", "sampleID")
fkCheck("FLIGHTS_INFO", "updateID", "UPDATE_METADATA", "updateID")

# FLIGHTS_SAMPLES 
fkCheck("FLIGHTS_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("FLIGHTS_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("FLIGHTS_SAMPLES", "siteID", "SITES", "siteID")
fkCheck("FLIGHTS_SAMPLES", "flightID", "FLIGHTS", "flightID")
fkCheck("FLIGHTS_SAMPLES", "sampleID", "FLIGHTS_SAMPLES", "sampleID")
fkCheck("FLIGHTS_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("FLIGHTS_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("FLIGHTS_SAMPLES", "siteID", start = 1, end = 2)
sCheck("FLIGHTS_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("FLIGHTS_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("FLIGHTS_SAMPLES", "gear", start = 5, end = 5)
sCheck("FLIGHTS_SAMPLES", "metadataID", start = 6, end = 6)

# GC 
fkCheck("GC", "projectID", "PROJECTS", "projectID")
fkCheck("GC", "sampleID", "SAMPLES", "sampleID")
fkCheck("GC", "lakeID", "LAKES", "lakeID")
fkCheck("GC", "siteName", "SITES", "siteName")
fkCheck("GC", "metadataID", "METADATA", "metadataID")
fkCheck("GC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("GC", "lakeID", start = 1, end = 1)
sCheck("GC", "siteName", start = 2, end = 2)
sCheck("GC", "dateSample", start = 3, end = 3)
sCheck("GC", "dateTimeSample", start = 3, end = 4)
sCheck("GC", "depthClass", start = 5, end = 5) 
## Allowed values checks
avCheck("GC", "depthClass", depthClassValues)

# ISOTOPE_BATCHES 
fkCheck("ISOTOPE_BATCHES", "updateID", "UPDATE_METADATA", "updateID")

# ISOTOPE_RESULTS
#fkCheck("ISOTOPE_RESULTS", "batchID", "ISOTOPE_BATCHES", "batchID") XXX
fkCheck("ISOTOPE_RESULTS", "metadataID", "METADATA", "metadataID")
fkCheck("ISOTOPE_RESULTS", "updateID", "UPDATE_METADATA", "updateID")
# checks to tie ISOTOPE_RESULTS back to the individual ISOTOPE_SAMPLES tables.
if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("A", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_PERIPHYTON"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_PERIPHYTON$isotopeID.")
}

if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("B", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_BENTHIC_INVERTS"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_BENTHIC_INVERTS$isotopeID.")
}

if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("F", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_FISH"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_FISH$isotopeID.")
}

if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("I", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_DIC"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_DIC$isotopeID.")
}

if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("M", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_METHANE"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_METHANE$isotopeID.")
}

# if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
#         filter(grepl("P", isotopeID)) %>%
#         pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_POC"]]$isotopeID)
# ){
#   stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_POC$isotopeID.")
# } # fails! XXX see issue: still outstanding.

if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
        filter(grepl("W", isotopeID)) %>%
        pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_WATER"]]$isotopeID)
){
  stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_WATER$isotopeID.")
}

# if(!all(tabs[["ISOTOPE_RESULTS"]] %>%
#         filter(grepl("Z", isotopeID)) %>%
#         pull(isotopeID) %in% tabs[["ISOTOPE_SAMPLES_ZOOPS"]]$isotopeID)
# ){
#   stop("Some elements of ISOTOPE_RESULTS$isotopeID not found in ISOTOPE_SAMPLES_ZOOPS$isotopeID.")
# } # fails! XXX see issue: still outstanding.

# ISOTOPE_SAMPLES_BENTHIC_INVERTS 
# fkCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "updateID", "UPDATE_METADATA", "updateID")
# can't check batchID because of formatting  XXX
## sampleID checks
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ISOTOPE_SAMPLES_BENTHIC_INVERTS", "depthClass", depthClassValues)

# ISOTOPE_SAMPLES_DIC 
# fkCheck("ISOTOPE_SAMPLES_DIC", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_DIC", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_DIC", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_DIC", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_DIC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_DIC", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_DIC", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_DIC", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_DIC", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_DIC", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_DIC", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ISOTOPE_SAMPLES_DIC", "depthClass", depthClassValues)

# ISOTOPE_SAMPLES_FISH 
fkCheck("ISOTOPE_SAMPLES_FISH", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_FISH", "fishID", "FISH_INFO", "fishID")
fkCheck("ISOTOPE_SAMPLES_FISH", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_FISH", "species", "OTU", "otu")
# Can't match up batchID because of the way the table is formatted. XXX
fkCheck("ISOTOPE_SAMPLES_FISH", "updateID", "UPDATE_METADATA", "updateID")

# ISOTOPE_SAMPLES_METHANE 
# fkCheck("ISOTOPE_SAMPLES_METHANE", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_METHANE", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_METHANE", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_METHANE", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_METHANE", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_METHANE", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_METHANE", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_METHANE", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_METHANE", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_METHANE", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_METHANE", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ISOTOPE_SAMPLES_METHANE", "depthClass", depthClassValues)

# ISOTOPE_SAMPLES_PERIPHYTON
# fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "metadataID", "METADATA", "metadataID")
fkCheck("ISOTOPE_SAMPLES_PERIPHYTON", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_PERIPHYTON", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ISOTOPE_SAMPLES_PERIPHYTON", "depthClass", depthClassValues)

# ISOTOPE_SAMPLES_POC 
# fkCheck("ISOTOPE_SAMPLES_POC", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_POC", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_POC", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_POC", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_POC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_POC", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_POC", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_POC", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_POC", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_POC", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_POC", "depthBottom", start = 6, end = 6)
## Allowed values checks
# avCheck("ISOTOPE_SAMPLES_POC", "depthClass", depthClassValues) # XXX fails

# ISOTOPE_SAMPLES_WATER 
# fkCheck("ISOTOPE_SAMPLES_WATER", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_WATER", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_WATER", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_WATER", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_WATER", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_WATER", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_WATER", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_WATER", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_WATER", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_WATER", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_WATER", "depthBottom", start = 6, end = 6)
## Allowed values checks
# avCheck("ISOTOPE_SAMPLES_WATER", "depthClass", depthClassValues) # XXX fails

# ISOTOPE_SAMPLES_ZOOPS 
# fkCheck("ISOTOPE_SAMPLES_ZOOPS", "sampleID", "SAMPLES", "sampleID") # un-checked
fkCheck("ISOTOPE_SAMPLES_ZOOPS", "projectID", "PROJECTS", "projectID")
fkCheck("ISOTOPE_SAMPLES_ZOOPS", "lakeID", "LAKES", "lakeID")
fkCheck("ISOTOPE_SAMPLES_ZOOPS", "siteName", "SITES", "siteName")
fkCheck("ISOTOPE_SAMPLES_ZOOPS", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ISOTOPE_SAMPLES_ZOOPS", "lakeID", start = 1, end = 1)
sCheck("ISOTOPE_SAMPLES_ZOOPS", "siteName", start = 2, end = 2)
sCheck("ISOTOPE_SAMPLES_ZOOPS", "dateSample", start = 3, end = 3)
sCheck("ISOTOPE_SAMPLES_ZOOPS", "dateTimeSample", start = 3, end = 4)
sCheck("ISOTOPE_SAMPLES_ZOOPS", "depthClass", start = 5, end = 5)
sCheck("ISOTOPE_SAMPLES_ZOOPS", "depthBottom", start = 6, end = 6)
## Allowed values checks
#avCheck("ISOTOPE_SAMPLES_ZOOPS", "depthClass", depthClassValues) # XXX fails

# LAB_EXPERIMENTS 
fkCheck("LAB_EXPERIMENTS", "updateID", "UPDATE_METADATA", "updateID")

# LAKE_BATHYMETRY 
fkCheck("LAKE_BATHYMETRY", "lakeID", "LAKES", "lakeID")
fkCheck("LAKE_BATHYMETRY", "lakeName", "LAKES", "lakeName")
fkCheck("LAKE_BATHYMETRY", "metadataID", "METADATA", "metadataID")
fkCheck("LAKE_BATHYMETRY", "updateID", "UPDATE_METADATA", "updateID")

# LAKES 
fkCheck("LAKES", "updateID", "UPDATE_METADATA", "updateID")

# LAKES_GIS 
fkCheck("LAKES", "lakeID", "LAKES", "lakeID")
fkCheck("LAKES", "updateID", "UPDATE_METADATA", "updateID")

# LIMNO_PROFILES
fkCheck("LIMNO_PROFILES", "projectID", "PROJECTS", "projectID")
fkCheck("LIMNO_PROFILES", "sampleID", "SAMPLES", "sampleID")
fkCheck("LIMNO_PROFILES", "lakeID", "LAKES", "lakeID")
fkCheck("LIMNO_PROFILES", "siteName", "SITES", "siteName")
fkCheck("LIMNO_PROFILES", "metadataID", "METADATA", "metadataID")
fkCheck("LIMNO_PROFILES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("LIMNO_PROFILES", "lakeID", start = 1, end = 1)
sCheck("LIMNO_PROFILES", "siteName", start = 2, end = 2)
sCheck("LIMNO_PROFILES", "dateSample", start = 3, end = 3)
sCheck("LIMNO_PROFILES", "dateTimeSample", start = 3, end = 4)
sCheck("LIMNO_PROFILES", "depthClass", start = 5, end = 5)
sCheck("LIMNO_PROFILES", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("LIMNO_PROFILES", "depthClass", depthClassValues)

# LIPID_EXTRACTIONS 
fkCheck("LIPID_EXTRACTIONS", "lipidID", "LIPID_SAMPLES", "lipidID")
fkCheck("LIPID_EXTRACTIONS", "updateID", "UPDATE_METADATA", "updateID")

# LIPID_SAMPLES
# fkCheck("LIPID_SAMPLES", "sampleID", "SAMPLES", "sampleID") # not checked
fkCheck("LIPID_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("LIPID_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("LIPID_SAMPLES", "siteName", "SITES", "siteName")
# fkCheck("LIPID_SAMPLES", "taxa", "OTU", "otu") # not checked
fkCheck("LIPID_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("LIPID_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("LIPID_SAMPLES", "siteName", start = 2, end = 2)
sCheck("LIPID_SAMPLES", "dateSample", start = 3, end = 3)
sCheck("LIPID_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("LIPID_SAMPLES", "depthClass", start = 5, end = 5)
sCheck("LIPID_SAMPLES", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("LIPID_SAMPLES", "depthClass", depthClassValues)

# METADATA 
fkCheck("METADATA", "updateID", "UPDATE_METADATA", "updateID")

# MOLECULAR_SAMPLE
fkCheck("MOLECULAR_SAMPLE", "projectID", "PROJECTS", "projectID")
fkCheck("MOLECULAR_SAMPLE", "sampleID", "SAMPLES", "sampleID")
fkCheck("MOLECULAR_SAMPLE", "siteName", "SITES", "siteName")
fkCheck("MOLECULAR_SAMPLE", "metadataID", "METADATA", "metadataID")
fkCheck("MOLECULAR_SAMPLE", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("MOLECULAR_SAMPLE", "siteName", start = 2, end = 2)
sCheck("MOLECULAR_SAMPLE", "dateSample", start = 3, end = 3) 
sCheck("MOLECULAR_SAMPLE", "dateTimeSample", start = 3, end = 4)
sCheck("MOLECULAR_SAMPLE", "depthClass", start = 5, end = 5)
sCheck("MOLECULAR_SAMPLE", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("MOLECULAR_SAMPLE", "depthClass", depthClassValues)

# OTU 
fkCheck("OTU", "updateID", "UPDATE_METADATA", "updateID")
## Allowed values checks
avCheck("OTU", "habitat", otuHabitatValues) # XXX re-evaluate these allowed values
avCheck("OTU", "grouping", otuGroupingValues) # XXX re-evaluate these allowed values

# PIEZOMETERS_INSTALL 
fkCheck("PIEZOMETERS_INSTALL", "siteID", "SITES", "siteID")
fkCheck("PIEZOMETERS_INSTALL", "metadataID", "METADATA", "metadataID")
fkCheck("PIEZOMETERS_INSTALL", "updateID", "UPDATE_METADATA", "updateID")

# PIEZOMETERS_LAKE
fkCheck("PIEZOMETERS_LAKE", "projectID", "PROJECTS", "projectID")
fkCheck("PIEZOMETERS_LAKE", "sampleID", "SAMPLES", "sampleID")
fkCheck("PIEZOMETERS_LAKE", "lakeID", "LAKES", "lakeID")
fkCheck("PIEZOMETERS_LAKE", "siteName", "SITES", "siteName")
fkCheck("PIEZOMETERS_LAKE", "metadataID", "METADATA", "metadataID")
fkCheck("PIEZOMETERS_LAKE", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("PIEZOMETERS_LAKE", "lakeID", start = 1, end = 1)
sCheck("PIEZOMETERS_LAKE", "siteName", start = 2, end = 2)
sCheck("PIEZOMETERS_LAKE", "dateSample", start = 3, end = 3)
sCheck("PIEZOMETERS_LAKE", "dateTimeSample", start = 3, end = 4)
sCheck("PIEZOMETERS_LAKE", "depthClass", start = 5, end = 5)
sCheck("PIEZOMETERS_LAKE", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("PIEZOMETERS_LAKE", "depthClass", depthClassValues)

# PIEZOMETERS_SENSORS
fkCheck("PIEZOMETERS_SENSORS", "projectID", "PROJECTS", "projectID")
fkCheck("PIEZOMETERS_SENSORS", "sampleID", "SAMPLES", "sampleID")
fkCheck("PIEZOMETERS_SENSORS", "lakeID", "LAKES", "lakeID")
fkCheck("PIEZOMETERS_SENSORS", "siteName", "SITES", "siteName")
fkCheck("PIEZOMETERS_SENSORS", "metadataID", "METADATA", "metadataID")
fkCheck("PIEZOMETERS_SENSORS", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("PIEZOMETERS_SENSORS", "lakeID", start = 1, end = 1)
sCheck("PIEZOMETERS_SENSORS", "siteName", start = 2, end = 2)
sCheck("PIEZOMETERS_SENSORS", "dateSample", start = 3, end = 3)
sCheck("PIEZOMETERS_SENSORS", "dateTimeSample", start = 3, end = 4)
sCheck("PIEZOMETERS_SENSORS", "depthClass", start = 5, end = 5)
sCheck("PIEZOMETERS_SENSORS", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("PIEZOMETERS_SENSORS", "depthClass", depthClassValues)

# PIEZOMETERS_SURVEYING 
fkCheck("PIEZOMETERS_SURVEYING", "projectID", "PROJECTS", "projectID")
fkCheck("PIEZOMETERS_SURVEYING", "sampleID", "SAMPLES", "sampleID")
fkCheck("PIEZOMETERS_SURVEYING", "lakeID", "LAKES", "lakeID")
fkCheck("PIEZOMETERS_SURVEYING", "siteName", "SITES", "siteName")
fkCheck("PIEZOMETERS_SURVEYING", "metadataID", "METADATA", "metadataID")
fkCheck("PIEZOMETERS_SURVEYING", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("PIEZOMETERS_SURVEYING", "lakeID", start = 1, end = 1)
sCheck("PIEZOMETERS_SURVEYING", "siteName", start = 2, end = 2)
sCheck("PIEZOMETERS_SURVEYING", "dateSample", start = 3, end = 3)
sCheck("PIEZOMETERS_SURVEYING", "dateTimeSample", start = 3, end = 4)
sCheck("PIEZOMETERS_SURVEYING", "depthClass", start = 5, end = 5)
sCheck("PIEZOMETERS_SURVEYING", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("PIEZOMETERS_SURVEYING", "depthClass", depthClassValues)

# PIEZOMETERS_UPLAND 
fkCheck("PIEZOMETERS_UPLAND", "projectID", "PROJECTS", "projectID")
fkCheck("PIEZOMETERS_UPLAND", "sampleID", "SAMPLES", "sampleID")
fkCheck("PIEZOMETERS_UPLAND", "lakeID", "LAKES", "lakeID")
fkCheck("PIEZOMETERS_UPLAND", "siteName", "SITES", "siteName")
fkCheck("PIEZOMETERS_UPLAND", "metadataID", "METADATA", "metadataID")
fkCheck("PIEZOMETERS_UPLAND", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("PIEZOMETERS_UPLAND", "lakeID", start = 1, end = 1)
sCheck("PIEZOMETERS_UPLAND", "siteName", start = 2, end = 2)
sCheck("PIEZOMETERS_UPLAND", "dateSample", start = 3, end = 3)
sCheck("PIEZOMETERS_UPLAND", "dateTimeSample", start = 3, end = 4)
sCheck("PIEZOMETERS_UPLAND", "depthClass", start = 5, end = 5)
sCheck("PIEZOMETERS_UPLAND", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("PIEZOMETERS_UPLAND", "depthClass", depthClassValues)

# PRIMARY_PRODUCTION_BENTHIC 
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "projectID", "PROJECTS", "projectID")
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "sampleID", "SAMPLES", "sampleID")
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "lakeID", "LAKES", "lakeID")
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "siteName", "SITES", "siteName")
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "metadataID", "METADATA", "metadataID")
fkCheck("PRIMARY_PRODUCTION_BENTHIC", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("PRIMARY_PRODUCTION_BENTHIC", "lakeID", start = 1, end = 1)
sCheck("PRIMARY_PRODUCTION_BENTHIC", "siteName", start = 2, end = 2)
sCheck("PRIMARY_PRODUCTION_BENTHIC", "dateSample", start = 3, end = 3)
sCheck("PRIMARY_PRODUCTION_BENTHIC", "dateTimeSample", start = 3, end = 4)
sCheck("PRIMARY_PRODUCTION_BENTHIC", "depthClass", start = 5, end = 5)
sCheck("PRIMARY_PRODUCTION_BENTHIC", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("PRIMARY_PRODUCTION_BENTHIC", "depthClass", depthClassValues)

# PROJECTS 
fkCheck("PROJECTS", "updateID", "UPDATE_METADATA", "updateID")

# PUBLICATIONS_PRESENTATIONS 
fkCheck("PUBLICATIONS_PRESENTATIONS", "updateID", "UPDATE_METADATA", "updateID")

# RHODAMINE 
fkCheck("RHODAMINE", "projectID", "PROJECTS", "projectID")
fkCheck("RHODAMINE", "sampleID", "SAMPLES", "sampleID")
fkCheck("RHODAMINE", "lakeID", "LAKES", "lakeID")
fkCheck("RHODAMINE", "siteName", "SITES", "siteName")
fkCheck("RHODAMINE", "rhodID", "RHODAMINE_RELEASE", "rhodID")
fkCheck("RHODAMINE", "metadataID", "METADATA", "metadataID")
fkCheck("RHODAMINE", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("RHODAMINE", "lakeID", start = 1, end = 1)
sCheck("RHODAMINE", "siteName", start = 2, end = 2)
sCheck("RHODAMINE", "dateSample", start = 3, end = 3)
sCheck("RHODAMINE", "dateTimeSample", start = 3, end = 4)
sCheck("RHODAMINE", "depthClass", start = 5, end = 5)
sCheck("RHODAMINE", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("RHODAMINE", "depthClass", depthClassValues)

# RHODAMINE_RELEASE 
fkCheck("RHODAMINE_RELEASE", "projectID", "PROJECTS", "projectID")
fkCheck("RHODAMINE_RELEASE", "siteID", "SITES", "siteID")
fkCheck("RHODAMINE_RELEASE", "lakeID", "LAKES", "lakeID")
fkCheck("RHODAMINE_RELEASE", "siteName", "SITES", "siteName")
fkCheck("RHODAMINE_RELEASE", "metadataID", "METADATA", "metadataID")
fkCheck("RHODAMINE_RELEASE", "updateID", "UPDATE_METADATA", "updateID")
## Allowed values checks
avCheck("RHODAMINE_RELEASE", "depthClass", depthClassValues)

# SAMPLES 
fkCheck("SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("SAMPLES", "siteID", "SITES", "siteID")
fkCheck("SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("SAMPLES", "lakeID", start = 1, end = 1)
sCheck("SAMPLES", "siteID", start = 1, end = 2)
sCheck("SAMPLES", "dateSample", start = 3, end = 3)
sCheck("SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("SAMPLES", "depthClass", start = 5, end = 5)
sCheck("SAMPLES", "depthBottom", start = 6, end = 6) 
sCheck("SAMPLES", "metadataID", start = 7, end = 7)
## Allowed values checks
avCheck("SAMPLES", "depthClass", depthClassValues)
 
# SED_TRAP_DATA 
fkCheck("SED_TRAP_DATA", "projectID", "PROJECTS", "projectID")
fkCheck("SED_TRAP_DATA", "sampleID", "SED_TRAP_SAMPLES", "sampleID")
fkCheck("SED_TRAP_DATA", "metadataID", "METADATA", "metadataID")
fkCheck("SED_TRAP_DATA", "updateID", "UPDATE_METADATA", "updateID")
## Allowed value checks
avCheck("SED_TRAP_DATA", "parameter", sedTrapDataParameterValues)

# SED_TRAP_SAMPLES 
fkCheck("SED_TRAP_SAMPLES", "lakeID", "LAKES", "lakeID")
fkCheck("SED_TRAP_SAMPLES", "projectID", "PROJECTS", "projectID")
fkCheck("SED_TRAP_SAMPLES", "siteName", "SITES", "siteName")
fkCheck("SED_TRAP_SAMPLES", "metadataID", "METADATA", "metadataID")
fkCheck("SED_TRAP_SAMPLES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("SED_TRAP_SAMPLES", "lakeID", start = 1, end = 1)
sCheck("SED_TRAP_SAMPLES", "siteName", start = 2, end = 2)
sCheck("SED_TRAP_SAMPLES", "dateTimeSample", start = 3, end = 4)
sCheck("SED_TRAP_SAMPLES", "depthClass", start = 5, end = 5)
sCheck("SED_TRAP_SAMPLES", "depthBottom", start = 6, end = 6)
sCheck("SED_TRAP_SAMPLES", "metadataID", start = 7, end = 7)
## Allowed values checks
avCheck("SED_TRAP_SAMPLES", "depthClass", depthClassValues)

# SEDIMENT 
fkCheck("SEDIMENT", "projectID", "PROJECTS", "projectID")
fkCheck("SEDIMENT", "sampleID", "SAMPLES", "sampleID")
fkCheck("SEDIMENT", "lakeID", "LAKES", "lakeID")
fkCheck("SEDIMENT", "siteName", "SITES", "siteName")
fkCheck("SEDIMENT", "metadataID", "METADATA", "metadataID")
fkCheck("SEDIMENT", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("SEDIMENT", "lakeID", start = 1, end = 1)
sCheck("SEDIMENT", "siteName", start = 2, end = 2)
sCheck("SEDIMENT", "dateSample", start = 3, end = 3)
sCheck("SEDIMENT", "dateTimeSample", start = 3, end = 4)
sCheck("SEDIMENT", "depthClass", start = 5, end = 5)
sCheck("SEDIMENT", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("SEDIMENT", "depthClass", depthClassValues)

# SITES 
fkCheck("SITES", "lakeID", "LAKES", "lakeID")
fkCheck("SITES", "updateID", "UPDATE_METADATA", "updateID")

# STAFF_GAUGES 
fkCheck("STAFF_GAUGES", "projectID", "PROJECTS", "projectID")
fkCheck("STAFF_GAUGES", "sampleID", "SAMPLES", "sampleID")
fkCheck("STAFF_GAUGES", "lakeID", "LAKES", "lakeID")
fkCheck("STAFF_GAUGES", "siteName", "SITES", "siteName")
fkCheck("STAFF_GAUGES", "metadataID", "METADATA", "metadataID")
fkCheck("STAFF_GAUGES", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("STAFF_GAUGES", "lakeID", start = 1, end = 1)
sCheck("STAFF_GAUGES", "siteName", start = 2, end = 2)
sCheck("STAFF_GAUGES", "dateSample", start = 3, end = 3)
sCheck("STAFF_GAUGES", "dateTimeSample", start = 3, end = 4)
sCheck("STAFF_GAUGES", "depthClass", start = 5, end = 5)
sCheck("STAFF_GAUGES", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("STAFF_GAUGES", "depthClass", depthClassValues)

# TPOC_DEPOSITION 
fkCheck("TPOC_DEPOSITION", "projectID", "PROJECTS", "projectID")
fkCheck("TPOC_DEPOSITION", "sampleID", "SAMPLES", "sampleID")
fkCheck("TPOC_DEPOSITION", "lakeID", "LAKES", "lakeID")
fkCheck("TPOC_DEPOSITION", "siteName", "SITES", "siteName")
fkCheck("TPOC_DEPOSITION", "metadataID", "METADATA", "metadataID")
fkCheck("TPOC_DEPOSITION", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("TPOC_DEPOSITION", "lakeID", start = 1, end = 1)
sCheck("TPOC_DEPOSITION", "siteName", start = 2, end = 2)
sCheck("TPOC_DEPOSITION", "dateSample", start = 3, end = 3)
sCheck("TPOC_DEPOSITION", "dateTimeSample", start = 3, end = 4)
sCheck("TPOC_DEPOSITION", "depthClass", start = 5, end = 5)
sCheck("TPOC_DEPOSITION", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("TPOC_DEPOSITION", "depthClass", depthClassValues)

# UNITS 
fkCheck("UNITS", "updateID", "UPDATE_METADATA", "updateID")

# UPDATE_METADATA 
fkCheck("UPDATE_METADATA", "verNumber", "VERSION_HISTORY", "verNumber")

# VERSION_HISTORY 
## no relational checks here.

# WATER_CHEM 
fkCheck("WATER_CHEM", "projectID", "PROJECTS", "projectID")
fkCheck("WATER_CHEM", "lakeID", "LAKES", "lakeID")
fkCheck("WATER_CHEM", "sampleID", "SAMPLES", "sampleID")
fkCheck("WATER_CHEM", "metadataID", "METADATA", "metadataID")
fkCheck("WATER_CHEM", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("WATER_CHEM", "lakeID", start = 1, end = 1)
sCheck("WATER_CHEM", "dateSample", start = 3, end = 3)
## Allowed value checks
avCheck("WATER_CHEM", "QCcode", docQCCodeValues)
avCheck("WATER_CHEM", "parameter", waterChemParameterValues)

# ZOOPS_ABUND_BIOMASS 
fkCheck("ZOOPS_ABUND_BIOMASS", "projectID", "PROJECTS", "projectID")
fkCheck("ZOOPS_ABUND_BIOMASS", "sampleID", "SAMPLES", "sampleID")
fkCheck("ZOOPS_ABUND_BIOMASS", "lakeID", "LAKES", "lakeID")
fkCheck("ZOOPS_ABUND_BIOMASS", "siteName", "SITES", "siteName")
fkCheck("ZOOPS_ABUND_BIOMASS", "metadataID", "METADATA", "metadataID")
fkCheck("ZOOPS_ABUND_BIOMASS", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ZOOPS_ABUND_BIOMASS", "lakeID", start = 1, end = 1)
sCheck("ZOOPS_ABUND_BIOMASS", "siteName", start = 2, end = 2)
sCheck("ZOOPS_ABUND_BIOMASS", "dateSample", start = 3, end = 3)
sCheck("ZOOPS_ABUND_BIOMASS", "dateTimeSample", start = 3, end = 4)
sCheck("ZOOPS_ABUND_BIOMASS", "depthClass", start = 5, end = 5)
sCheck("ZOOPS_ABUND_BIOMASS", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ZOOPS_ABUND_BIOMASS", "depthClass", depthClassValues)

# ZOOPS_COEFFICIENTS 
fkCheck("ZOOPS_COEFFICIENTS", "taxa", "OTU", "otu")
fkCheck("ZOOPS_COEFFICIENTS", "updateID", "UPDATE_METADATA", "updateID")

# ZOOPS_LENGTHS 
fkCheck("ZOOPS_LENGTHS", "projectID", "PROJECTS", "projectID")
fkCheck("ZOOPS_LENGTHS", "sampleID", "SAMPLES", "sampleID")
fkCheck("ZOOPS_LENGTHS", "lakeID", "LAKES", "lakeID")
fkCheck("ZOOPS_LENGTHS", "siteName", "SITES", "siteName")
fkCheck("ZOOPS_LENGTHS", "metadataID", "METADATA", "metadataID")
fkCheck("ZOOPS_LENGTHS", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ZOOPS_LENGTHS", "lakeID", start = 1, end = 1)
sCheck("ZOOPS_LENGTHS", "siteName", start = 2, end = 2)
sCheck("ZOOPS_LENGTHS", "dateSample", start = 3, end = 3)
sCheck("ZOOPS_LENGTHS", "dateTimeSample", start = 3, end = 4)
sCheck("ZOOPS_LENGTHS", "depthClass", start = 5, end = 5)
sCheck("ZOOPS_LENGTHS", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ZOOPS_LENGTHS", "depthClass", depthClassValues)

# ZOOPS_PRODUCTION 
fkCheck("ZOOPS_PRODUCTION", "projectID", "PROJECTS", "projectID")
fkCheck("ZOOPS_PRODUCTION", "lakeID", "LAKES", "lakeID")
fkCheck("ZOOPS_PRODUCTION", "siteID", "SITES", "siteID")
fkCheck("ZOOPS_PRODUCTION", "taxa", "OTU", "otu")
fkCheck("ZOOPS_PRODUCTION", "metadataID", "METADATA", "metadataID")
fkCheck("ZOOPS_PRODUCTION", "updateID", "UPDATE_METADATA", "updateID")

# ZOOPS_SUBSAMPLE
fkCheck("ZOOPS_SUBSAMPLE", "projectID", "PROJECTS", "projectID")
fkCheck("ZOOPS_SUBSAMPLE", "sampleID", "SAMPLES", "sampleID")
fkCheck("ZOOPS_SUBSAMPLE", "lakeID", "LAKES", "lakeID")
fkCheck("ZOOPS_SUBSAMPLE", "siteName", "SITES", "siteName")
fkCheck("ZOOPS_SUBSAMPLE", "metadataID", "METADATA", "metadataID")
fkCheck("ZOOPS_SUBSAMPLE", "updateID", "UPDATE_METADATA", "updateID")
## sampleID checks
sCheck("ZOOPS_SUBSAMPLE", "lakeID", start = 1, end = 1)
sCheck("ZOOPS_SUBSAMPLE", "siteName", start = 2, end = 2)
sCheck("ZOOPS_SUBSAMPLE", "dateSample", start = 3, end = 3)
sCheck("ZOOPS_SUBSAMPLE", "dateTimeSample", start = 3, end = 4)
sCheck("ZOOPS_SUBSAMPLE", "depthClass", start = 5, end = 5)
sCheck("ZOOPS_SUBSAMPLE", "depthBottom", start = 6, end = 6)
## Allowed values checks
avCheck("ZOOPS_SUBSAMPLE", "depthClass", depthClassValues)

# Final success message
message("SUCCESS! Passed checks.")
