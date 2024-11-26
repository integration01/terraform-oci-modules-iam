# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "compartments" {
  value = module.cislz_compartments.compartments.ENG
}

output "identity-domain-dynamic-groups" {
  description = "The identity domain groups."
  value       = module.cislz_identity_domains.identity_domain_dynamic_groups.DG
}
