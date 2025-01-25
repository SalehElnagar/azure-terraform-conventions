provider "random" {}

provider "azurerm" {
  features {}
}

provider "azuread" {}

// The load_config_file attribute has been removed.
// Support for the KUBECONFIG environment variable has been dropped and replaced with KUBE_CONFIG_PATH.
// The config_path attribute will no longer default to ~/.kube/config and must be set explicitly.