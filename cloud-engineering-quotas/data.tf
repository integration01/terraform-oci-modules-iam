data "oci_identity_compartments" "engineer_compartments" {
    #Required
    compartment_id = var.engineer_compartment_ocid
    state = "ACTIVE"
}

output "compartments" {
    description = "compartments"
    value = data.oci_identity_compartments.engineer_compartments.compartments
}