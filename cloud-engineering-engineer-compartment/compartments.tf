locals {

    # Compartment

    engineer_compartment = {
        ENG = {
            name : var.compartment_name,
            description : "${var.compartment_name} compartment"
        }
    }

    # Place any created compartments in the defined top compartment
    compartments_configuration = {
        default_parent_id : var.cloud_engineering_root_compartment_ocid
        enable_delete : true
        compartments : local.engineer_compartment
    }
}