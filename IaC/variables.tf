variable "db_password" {
  description = "The Postgres DB password"
  type = string
  sensitive = true
}

variable "api_key" {
	description = "finance api key"
	type = string
	sensitive = true
}
