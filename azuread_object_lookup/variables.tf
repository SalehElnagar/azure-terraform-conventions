variable "azuread_objects" {
  type        = list(object({
    id    = string
    type  = string
  }))
}
