variable "application" {
  type = string
}
variable "cost-center" {
  type = string
}
variable "deployed-by" {
  type = string
}
variable "environment" {
  type = string
}
variable "server_side_encrypt" {
  type = bool
  default = true
}
variable "domain" {
  type = string
  default = "*"
}