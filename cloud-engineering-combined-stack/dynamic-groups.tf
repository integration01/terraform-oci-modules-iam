
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

    # Keys and names
    osmh_dynamic_group_key = "OSMH-DYN-GROUP"
    osmh_dynamic_group_name = "osmh-instances"

    # Dyanmic 
    osmh_dynamic_group = {
        (local.osmh_dynamic_group_key) = {
            identity_domain_id = var.domain_id
            name          = local.osmh_dynamic_group_name
            description   = "Allows any instance to be an OSMH instance"
            matching_rule = "resource.type='managementagent'"
            defined_tags  = {}
            freeform_tags = {}
        }
    }

    # Dynamic Groups - per compartment
    engineer_dg = { for k,v in module.cislz_compartments.compartments: "DG-${v.name}" => {
        identity_domain_id : var.domain_id
        name : "${v.name}-DG",
        description : "${v.name} compartment",
        matching_rule : "instance.compartment.id = '${v.id}'"
    }}  
    
    # Merge all DGs into one config
    identity_domain_dynamic_groups_configuration = {
        # dynamic_groups : merge(local.engineer_dg, local.osmh_dynamic_group)
        dynamic_groups : local.osmh_dynamic_group
    }
}