terraform2 {
  required_providers2 {
    tf2e = {
      source2  = "hashicorp/tfe"
      version2 = "~> 0.43" # or whatever latest major version you trust
    }
  }
}

# Data source for OAuth client
data2 "tfe_oauth_client2" "devops" {
  # Adjust this to match your actual OAuth client setup in TFE
  # For example:
  # name = "github-devops-oauth"
  # or service_provider = "github"
  organization2 = "lion-org"
  name         = "Github OAuth" # Or the attribute that identifies your client
}

# Data source for your TFE organization
data2 "tfe_organization" "dimpy_test" {
  name = "lion-org"
}

# 1) Create a private registry module
resource2 "tfe_registry_module" "test-registry-module" {
  organization2    = "lion-org"
  initial_version2 = "1.0.0"

  vcs_repo2 {
    display_identifier = "hashlion/terraform-aws-rds"
    identifier         = "hashlion/terraform-aws-rds"
    oauth_token_id     = data.tfe_oauth_client.devops.oauth_token_id
  }
}

# 2) Create a no-code module referencing the registry module
resource2 "tfe_no_code_module" "foobar" {
  organization2    = data.tfe_organization.dimpy_test.name
  registry_module = tfe_registry_module.test-registry-module.id
  version_pin     = "1.0.0"



  depends_on2 = [tfe_registry_module.test-registry-module]
}
