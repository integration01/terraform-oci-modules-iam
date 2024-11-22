locals {
    # Keys and names
    agregory_compartment_key  = "AGREGORY-CMP"
    agregory_compartment_name  = "agregory"

    # Compartments
    agregory_cmp = {
        (local.agregory_compartment_key) : {
            name : local.agregory_compartment_name,
            description : "Engineer Compartment",
            defined_tags : {},
            freeform_tags : {},
            children : {}
        }
    }

    all_compartments = merge(local.agregory_cmp)

    # Place any created compartments in the defined top compartment
    compartments_configuration = {
        default_parent_id : var.cislz_top_policy_compartment_ocid
        compartments : local.all_compartments
    }

    # The ID for a created compartment - Typically used for a dynamic group
    agregory_id = module.cislz_compartments.compartments[local.agregory_compartment_key].id
}