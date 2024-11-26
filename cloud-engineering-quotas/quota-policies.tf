
# resource "oci_limits_quota" "global-super-restrict" {
#     #Required
#     compartment_id = var.tenancy_ocid
#     description = "Global Restrictions"
#     name = "global-super-restrict-regions-quota"
#     statements = [
#         "zero analytics quota in tenancy where all {request.region = us-sanjose-1, request.region = sa-saopaulo-1,request.region = ca-toronto-1,request.region = eu-frankfurt-1,request.region = ap-mumbai-1,request.region = me-dubai-1,request.region = uk-london-1}",
#         "zero big-data quota in tenancy where all {request.region = us-sanjose-1, request.region = sa-saopaulo-1,request.region = ca-toronto-1,request.region = eu-frankfurt-1,request.region = ap-mumbai-1,request.region = me-dubai-1,request.region = uk-london-1}"
#     ] 
# }

locals {
    db_quota_statements = concat(
        [
            for comp in data.oci_identity_compartments.engineer_compartments.compartments: "zero database quota /*-ocpu-count/ in compartment cloud-engineering:${comp.name}"
        ]
    )
    compute_quota_statements = concat(
        [
            for comp in data.oci_identity_compartments.engineer_compartments.compartments: "set compute-memory quota /standard-*/ to 120 in compartment cloud-engineering:${comp.name}"
        ]
    )
    storage_quota_statements = concat(
        [
            for comp in data.oci_identity_compartments.engineer_compartments.compartments: "set block-storage quota total-storage-gb to 1024 in compartment cloud-engineering:${comp.name}"
        ]
    )
}

# resource "oci_limits_quota" "engineer-database" {
#     #Required
#     compartment_id = var.tenancy_ocid
#     description = "Engineer quota"
#     name = "cloud-engineering-DATABASE-quota"
#     statements = local.db_quota_statements
#     depends_on = [ module.cislz_compartments ]
# }

# resource "oci_limits_quota" "engineer-compute" {
#     #Required
#     compartment_id = var.tenancy_ocid
#     description = "Engineer quota"
#     name = "cloud-engineering-COMPUTE-quota"
#     statements = local.compute_quota_statements 
#     depends_on = [ module.cislz_compartments ]
# }

resource "oci_limits_quota" "engineer-storage" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "Engineer quota"
    name = "cloud-engineering-STORAGE-quota"
    statements = local.compute_quota_statements 
}