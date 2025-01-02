locals {
  canonical_location_map = {
    "australia central"        = "AUC"
    "australia central 2"      = "AUC2"
    "australia east"           = "AUE"
    "australia southeast"      = "AUS"
    "brazil south"             = "BRS"
    "brazil southeast"         = "BRSE"
    "canada central"           = "CAC"
    "canada east"              = "CAE"
    "central india"            = "CIN"
    "central us"               = "CUS"
    "central us euap"          = "CUSE"
    "china east"               = "CHE"
    "china east 2"             = "CHE2"
    "china north"              = "CHN"
    "china north 2"            = "CHN2"
    "east asia"                = "EAS"
    "east us"                  = "EUS"
    "east us 2"                = "EUS2"
    "east us 2 euap"           = "EUS2E"
    "france central"           = "FRC"
    "france south"             = "FRS"
    "germany north"            = "GEN"
    "germany west central"     = "GEW"
    "germany central"          = "GEC"
    "germany northeast"        = "GENE"
    "israel central"           = "ISC"
    "italy north"              = "ITN"
    "japan east"               = "JPE"
    "japan west"               = "JPW"
    "jio india central"        = "JIC"
    "jio india west"           = "JIW"
    "korea central"            = "KOC"
    "korea south"              = "KOS"
    "north central us"         = "NCU"
    "north europe"             = "NEU"
    "norway east"              = "NOE"
    "norway west"              = "NOW"
    "poland central"           = "PLC"
    "qatar central"            = "QTC"
    "south africa north"       = "SAN"
    "south africa west"        = "SAW"
    "south central us"         = "SCU"
    "south india"              = "SIN"
    "south korea central"      = "SKC"
    "sweden central"           = "SWC"
    "sweden south"             = "SWS"
    "switzerland north"        = "SWN"
    "switzerland west"         = "SWW"
    "uae central"              = "UAC"
    "uae north"                = "UAN"
    "uk south"                 = "UKS"
    "uk west"                  = "UKW"
    "west central us"          = "WCU"
    "west europe"              = "WEU"
    "west india"               = "WIN"
    "west us"                  = "WUS"
    "west us 2"                = "WUS2"
    "west us 3"                = "WUS3"
    "global"                   = "GLO"
  }

  azure_location_map = merge(
    local.canonical_location_map,
    { for k, v in local.canonical_location_map : replace(k, " ", "") => v },
    { for k, v in local.canonical_location_map : replace(k, " ", "-") => v }
  )

  vm_environment_map = {
    "development"     = "D"
    "quality"         = "Q"
    "production"      = "P"
    "test"            = "T"
    "sandbox"         = "S"
    "nonproduction"   = "N"
    "preproduction"   = "R"
    "stage"           = "ST"
    "disasterrecovery" = "DR"
    "training"        = "TR"
  }

  environment_map = {
    "development"     = "Dev"
    "quality"         = "QA"
    "production"      = "Prod"
    "test"            = "Test"
    "sandbox"         = "SB"
    "nonproduction"   = "NP"
    "preproduction"   = "Prep"
    "stage"           = "Stg"
    "disasterrecovery" = "DR"
    "training"        = "Train"
  }

  short_environment_map = {
    "development"     = "DEV"
    "quality"         = "QA"
    "production"      = "PRD"
    "test"            = "TST"
    "sandbox"         = "SB"
    "nonproduction"   = "NP"
    "preproduction"   = "PR"
    "stage"           = "STG"
    "disasterrecovery" = "DR"
    "training"        = "TRN"
  }

  tag_map = {
    "Provisioner" = "Terraform"
    "ManagedBy"   = "Terraform"
  }
}

