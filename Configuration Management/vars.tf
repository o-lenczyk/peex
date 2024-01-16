variable "ssh_user" {
    type = string
    default = "mpiase"
}

variable "public_key_path" {
    type = string
    default = ".ssh/id_rsa.pub"
}

variable "private_key_path" {
    type = string
    default = ".ssh/id_rsa"
}