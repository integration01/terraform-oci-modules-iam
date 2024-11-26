locals {

    # # Compartment List (add )
    cmp_list = ["nhorner", "agregory", "rkab"]

    # # Compartments

    engineer_compartments = { for cmp in local.cmp_list: "CMP-${cmp}" => { 
        name : cmp,
        description : "${cmp} compartment"
    }}

    all_comp = {
        CLOUD-ENG = {
            name = "cloud-engineering",
            description = "Top level compartment for all cloud engineers",
            children = local.engineer_compartments
        },
        SPECIAL-CMP = {
            name = "cloud-engineering-projects", 
            description = "Special project compartments", 
        },
        SHARED-CMP = {
            name = "cloud-engineering-shared",
            description = "Shared compartment for all cloud engineers - limited access",
            children = {
                OAC-CMP = {
                    name = "OAC",
                    description = "Oracle Analytics Cloud"
                },
                OIC-CMP = {
                    name = "OIC",
                    description = "Oracle Integration Cloud"
                },
                EXACS-CMP = {
                    name = "ExaCS",
                    description = "Oracle Exadata Cloud Service"
                },
            }
        }
    }

    # Place any created compartments in the defined top compartment
    compartments_configuration = {
        default_parent_id : var.tenancy_ocid
        enable_delete : false
        compartments : local.all_comp
    }

}