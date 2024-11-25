locals {

    # Compartment List (add )
    cmp_list = ["nhorner", "agregory", "rkab"]

    # Compartments

    engineer_compartments = { for cmp in local.cmp_list: "CMP-${cmp}" => { 
        name : cmp,
        description : "${cmp} compartment"
    }}

    eng = {
        ENG-CMP = { 
            name = "engineers", 
            description = "All engineer compartments", 
            children = local.engineer_compartments
        },
        SPECIAL-CMP = { 
            name = "projects", 
            description = "Special project compartments", 
        }
    }

    # Place any created compartments in the defined top compartment
    compartments_configuration = {
        default_parent_id : var.cislz_top_policy_compartment_ocid
        enable_delete : false
        compartments : local.eng
    }

}