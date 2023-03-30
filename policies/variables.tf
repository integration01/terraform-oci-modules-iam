# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type = string
}
variable "policies_configuration" {
  description = "Policies configuration"
  type = object({
    enable_cis_benchmark_checks = optional(bool) # Whether to check policies for CIS Foundations Benchmark recommendations. Default is true.
    enable_tenancy_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the root compartment) (a.k.a tenancy) level. Attribute groups_with_tenancy_level_roles only applies if this is set to true. Default is false.
    groups_with_tenancy_level_roles = optional(list(object({ # A list of group names and their roles at the root compartment (a.k.a tenancy) level. Pre-configured policies are assigned to each group in the root compartment. Only applicable if attribute enable_tenancy_level_template_policies is set to true.
      name = string
      roles = string
    })))
    enable_compartment_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the compartment level (compartments other than root). Default is true.
    cislz_tag_lookup_value = optional(string) # The tag value used for looking up compartments. This module searches for compartments that are freeform tagged with cislz = <cislz_tag_lookup_value>. The selected compartments are eligible for template (pre-configured) policies. If the lookup fails, no template policies are applied.
    policy_name_prefix = optional(string) # A prefix to be prepended to all policy names
    policy_name_suffix = optional(string) # A suffix to be appended to all policy names
    supplied_compartments = optional(list(object({ # List of compartments that are policy targets. This is a workaround to Terraform behavior. Please see note below.
      name = string
      ocid = string
      freeform_tags = map(string)
    })))
    defined_tags = optional(map(string)) # Any defined tags to apply on the template (pre-configured) policies.
    freeform_tags = optional(map(string)) # Any freeform tags to apply on the template (pre-configured) policies.
    supplied_policies = optional(map(object({ # A map of directly supplied policies. Use this to suplement the template (pre-configured) policies. For completely overriding the template policies, set attributes enable_compartment_level_template_policies and enable_tenancy_level_template_policies to false.
      name             = string
      description      = string
      compartment_ocid = string
      statements       = list(string)
      defined_tags     = map(string)
      freeform_tags    = map(string)
    })))
    enable_output = optional(bool) # Whether the module generates output. Default is false.
    enable_debug = optional(bool) # # Whether the module generates debug output. Default is false.
  })
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-- Note about supplied_compartments attribute:
#-- TL;DR
#-- When using this module in the same Terraform configuration that is used to manage compartments, provide compartments via target_compartments variable.
#-- When using this module in stand alone mode, you don't need to use target_compartments variable. The module will obtain compartments from a data source.
#--
#-- Rationale:
#-- The original ideia was having the module reading compartments from a data source only. But that introduces an issue to the processing logic, as
#-- Terraform requires compartments to be known at plan time, because compartment names are used as map keys by the module. 
#-- The error is:
#--
#-- Error: Invalid for_each argument
#--│
#--│   on .terraform\modules\cislz_policies\main.tf line 23, in resource "oci_identity_policy" "these":
#--│   23:   for_each = {for k, v in local.policies : k => v if length(v.statements) > 0}
#--│     ├────────────────
#--││     │ local.policies will be known only after apply
#--││
#--││ The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, 
#--|| and so Terraform cannot determine the full set of keys that will identify the instances of this resource.
#--││
#--││ When working with unknown values in for_each, it's better to define the map keys statically in your configuration and place apply-time results only in the map values.
#--││
#--││ Alternatively, you could use the -target planning option to first apply only the resources that the for_each value depends on, and then apply a second time to fully converge.
#--
#-- This problem only happens when this module is used in the same Terraform configuration (hence single state) as compartments, i.e., the same Terraform configuration
#-- manages compartments and policies. **Not a problem when used standalone**.
#-- To workaround this limitation, the module also takes the target compartments as an input. By doing this, Terraform has the map keys at plan time and does not error out.