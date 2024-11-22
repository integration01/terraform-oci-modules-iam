
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

    # Keys and names
    agregory_dynamic_group_name = "agregory-dg"
    agregory_dynamic_group_key = "AGREGORY-DYN-GROUP"
    osmh_dynamic_group_key = "OSMH-DYN-GROUP"
    osmh_dynamic_group_name = "osmh-instances"


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

    agregory_dynamic_group = {
        (local.agregory_dynamic_group_key) = {
            identity_domain_id = var.domain_id
            name          = "agregory-dg"
            description   = "Engineer-specific Dynamic Group"
            matching_rule = "instance.compartment.id = '${local.agregory_id}'}"
            defined_tags  = {}
            freeform_tags = {}
        }
    }

    # Merge all DGs into one config
    identity_domain_dynamic_groups_configuration = {
        dynamic_groups : merge(local.agregory_dynamic_group, local.osmh_dynamic_group)
    }
}