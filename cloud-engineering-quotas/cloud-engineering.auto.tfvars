# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#---------------------------------------
# Tenancy Connectivity Variables
#---------------------------------------

tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaaonqlfuxbai2t677fopst4vowm5axun74bmowkxtcqvbx6liagciq"             # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
user_ocid            = "ocid1.user.oc1..aaaaaaaa7b2pxru5zijcmtgrmfg5xmf7to5tkgjtdo64it56kwao32pl6f3a"                # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
fingerprint          = "5b:0a:43:58:38:3c:47:e7:77:e9:9e:4b:78:46:cb:54"      # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side).
private_key_path     = "/Users/agregory/.oci/oci_api_key.pem"  # This is the full path on your local system to the API signing private key.
private_key_password = ""                           # This is the password that protects the private key, if any.
region               = "us-phoenix-1" # This is your tenancy home region.


#---------------------------------------
# Input variables
#---------------------------------------

# The comaprtment OICD
engineer_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaarq6m3fqvw6bfg5sychftsq5ovkhzfijrpfmch6hvgdlbmaqgceba"


