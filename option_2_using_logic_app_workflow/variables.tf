variable "prefix" {
  type    = string
  default = "logic-app-demo"
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "function1_app_code" {
  type    = string
  default = "../build/function1_app_code.zip"
}

variable "function2_app_code" {
  type    = string
  default = "../build/function2_app_code.zip"
}