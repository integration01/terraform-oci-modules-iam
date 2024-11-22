locals {
    # Policies
    policies = {
        "CE-IAM-ROOT-POLICY" : {
            name : "cloud-engineering-IAM-policy"
            description : "Cloud Engineers IAM permissions"
            compartment_id : "TENANCY-ROOT" # Instead of an OCID, you can replace it with the string "TENANCY-ROOT" for attaching the policy to the Root compartment.
            statements : [
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to manage dynamic-groups in tenancy where target.resource.domain.name='cloud-engineer-domain' //Allows Cloud Engineers only to modify DG within their domain",
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to inspect compartments in tenancy //Allows Cloud Engineers only to list compartments"
            ]
        },
        "CE-OSS-POLICY" : {
            name : "cloud-engineering-OSS-policy"
            description : "Cloud Engineers IAM permissions"
            compartment_id : "${var.cislz_top_policy_compartment_ocid}"
            statements : [
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to manage object-family in compartment ${var.cislz_top_policy_compartment_name} //Allows Cloud Engineers to work with all object storage within main CE compartment",
            ]            
        },
        "CE-CORE-POLICY" : {
            name : "cloud-engineering-core-policy"
            description : "Cloud Engineers Core Service permissions"
            compartment_id : "${var.cislz_top_policy_compartment_ocid}"
            statements : [
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to read all-resources in compartment ${var.cislz_top_policy_compartment_name} //Allow CE to read everything main CE compartment",
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to manage instance-family in compartment ${var.cislz_top_policy_compartment_name} //Allow CE to work with all compute within main CE compartment",
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to manage volume-family in compartment ${var.cislz_top_policy_compartment_name} //Allow CE to work with all block storage within main CE compartment",
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to use virtual-network-family in compartment ${var.cislz_top_policy_compartment_name} //Allow CE to use networking within main CE compartment",
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to manage network-security-groups in compartment ${var.cislz_top_policy_compartment_name} //Allow CE to work manage NSG within main CE compartment",
            ]            
        },
        "CE-OSMH-POLICY" : {
            name : "cloud-engineering-OSMH-root-policy"
            description : "Cloud Engineers OS Management Hub permissions"
            compartment_id : "TENANCY-ROOT"
            statements : [
                "allow group '${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}' to read osmh-family in tenancy //Allow CE to load OSMH data",
            ]            
        },
        "CE-OSMH-INST-POLICY" : {
            name : "cloud-engineering-OSMH-instance-policy"
            description : "Cloud Engineers OS Management Hub permissions"
            compartment_id : "${var.cislz_top_policy_compartment_ocid}"
            statements : [
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {OSMH_MANAGED_INSTANCE_ACCESS} in compartment ${var.cislz_top_policy_compartment_name} where request.principal.id = target.managed-instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to use metrics in compartment ${var.cislz_top_policy_compartment_name} where target.metrics.namespace = 'oracle_appmgmt'",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {MGMT_AGENT_DEPLOY_PLUGIN_CREATE, MGMT_AGENT_INSPECT, MGMT_AGENT_READ} in compartment ${var.cislz_top_policy_compartment_name} where target.metrics.namespace = 'oracle_appmgmt'",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {APPMGMT_MONITORED_INSTANCE_READ, APPMGMT_MONITORED_INSTANCE_ACTIVATE} in compartment ${var.cislz_top_policy_compartment_name} where request.instance.id = target.monitored-instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {INSTANCE_READ, INSTANCE_UPDATE} in compartment ${var.cislz_top_policy_compartment_name} where request.instance.id = target.instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {APPMGMT_WORK_REQUEST_READ, INSTANCE_AGENT_PLUGIN_INSPECT} in compartment ${var.cislz_top_policy_compartment_name}",
            ]            
        },
    }

    # Merge all policies
    policies_configuration = {
        enable_cis_benchmark_checks : true
        supplied_policies: merge(local.policies)
    }
}
