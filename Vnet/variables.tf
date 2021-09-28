variable namespace {
    description = "The namespace in which the resources are deployed such as dev, qa, prod"
}

variable location {
    description = "The location in which the resources are deployed such as east US, west Europe"
}

variable address_space {
    description = "Address space for the Virtual network"
}

variable rg_name {
    description = "Resource group name where the resources are residing"
}

variable address_prefixes {
    description = "Address prefixes for the subnet"
}

variable environment {
    description = "The environment in which the resources are deployed such as dev, qa, prod"
}
