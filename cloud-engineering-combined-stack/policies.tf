locals {
    # Policies
    core_policy_group_name = "'${local.cloud_engineering_domain_name}'/'${local.cloud_engineering_group_name}'"
    core_policy_engineer_compartment = module.cislz_compartments.compartments.CLOUD-ENG.name

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
        "CE-SERVICES-POLICY" : {
            name : "cloud-engineering-SERVICE-policy"
            description : "Cloud Engineers Service Enablement permissions"
            compartment_id : module.cislz_compartments.compartments.CLOUD-ENG.id
            statements : [
                "allow group ${local.core_policy_group_name} to manage loganalytics-resources-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to work Logging Analytics",
                "allow group ${local.core_policy_group_name} to manage loganalytics-features-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to work Logging Analytics",
                "allow group ${local.core_policy_group_name} to manage logging-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to use OCI Logging",
                "allow group ${local.core_policy_group_name} to manage email-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to use email",
                "allow group ${local.core_policy_group_name} to manage cloud-guard-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to use Cloud Guard",
                "allow group ${local.core_policy_group_name} to manage orm-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to use Cloud Guard",
            ]            
        },
        "CE-CORE-POLICY" : {
            name : "cloud-engineering-CORE-policy"
            description : "Cloud Engineers Core Service permissions"
            compartment_id : module.cislz_compartments.compartments.CLOUD-ENG.id
            statements : [
                "allow group ${local.core_policy_group_name} to read all-resources in compartment ${local.core_policy_engineer_compartment} //Allow CE to read everything main CE compartment",
                "allow group ${local.core_policy_group_name} to manage instance-family in compartment ${local.core_policy_engineer_compartment} //Allow CE to work with all compute within main CE compartment",
                "allow group ${local.core_policy_group_name} to manage volume-family in compartment ${local.core_policy_engineer_compartment} //Allow CE to work with all block storage within main CE compartment",
                "allow group ${local.core_policy_group_name} to use virtual-network-family in compartment ${local.core_policy_engineer_compartment} //Allow CE to use networking within main CE compartment",
                "allow group ${local.core_policy_group_name} to manage network-security-groups in compartment ${local.core_policy_engineer_compartment} //Allow CE to work manage NSG within main CE compartment",
                "allow group ${local.core_policy_group_name} to manage object-family in compartment ${local.core_policy_engineer_compartment} //Allows Cloud Engineers to work with all object storage within main CE compartment",
            ]            
        },
        "CE-DYN-GROUP-POLICY" : {
            name : "cloud-engineering-DYNAMIC-GROUP-policy"
            description : "Cloud Engineers Dynamic Group permissions"
            compartment_id : module.cislz_compartments.compartments.CLOUD-ENG.id
            statements : [ 
                for dg in local.engineer_compartments: "allow dynamic-group ${dg.name}-DG to inspect all-resources in compartment ${local.core_policy_engineer_compartment}"
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
            compartment_id : module.cislz_compartments.compartments.CLOUD-ENG.id
            statements : [
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {OSMH_MANAGED_INSTANCE_ACCESS} in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name} where request.principal.id = target.managed-instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to use metrics in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name} where target.metrics.namespace = 'oracle_appmgmt'",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {MGMT_AGENT_DEPLOY_PLUGIN_CREATE, MGMT_AGENT_INSPECT, MGMT_AGENT_READ} in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name} where target.metrics.namespace = 'oracle_appmgmt'",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {APPMGMT_MONITORED_INSTANCE_READ, APPMGMT_MONITORED_INSTANCE_ACTIVATE} in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name} where request.instance.id = target.monitored-instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {INSTANCE_READ, INSTANCE_UPDATE} in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name} where request.instance.id = target.instance.id",
                "allow dynamic-group '${local.cloud_engineering_domain_name}'/'${local.osmh_dynamic_group_name}' to {APPMGMT_WORK_REQUEST_READ, INSTANCE_AGENT_PLUGIN_INSPECT} in compartment ${module.cislz_compartments.compartments.CLOUD-ENG.name}",
            ]            
        },
    }

    # Merge all policies
    policies_configuration = {
        enable_cis_benchmark_checks : true
        supplied_policies: merge(local.policies)
    }
}
