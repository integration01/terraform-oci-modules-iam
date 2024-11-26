
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

    # Dynamic Groups - per compartment
    engineer_dg = {
        DG = {
            identity_domain_id : var.domain_id
            name : "${var.compartment_name}-DG",
            description : "${var.compartment_name} compartment",
            matching_rule : "instance.compartment.id = '${module.cislz_compartments.compartments.ENG.id}'"
        }
    } 
    
    # Merge all DGs into one config
    identity_domain_dynamic_groups_configuration = {
        dynamic_groups : local.engineer_dg
    }
}