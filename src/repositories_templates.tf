#####################################################################
#
# Repository settings for Arrow Templates
#
#####################################################################

locals {
  lib_template = {
    repos = {
      "rust" = {
        description = "Rust libraries"
      }
    }
  }

  svc_template = {
    repos = {
      "typescript" = {
        description = "TypeScript services"
      }
      "rust" = {
        description = "Rust services"
      }
      "python" = {
        description = "Python services"
      }
    }
  }

  template_default = {
    settings = {
      owner_team                         = "services"
      visibility                         = "public"
      default_branch                     = "develop"
      webhooks                           = try(local.webhooks["services"], {})
      default_branch_protection_settings = {} # Using module defaults
    }
  }
}

########################################################
# Library repositories
########################################################
module "repository_lib_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.lib_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("lib-template-%s", each.key)
  description = format("Arrow Library Template - %s", each.value.description)
  is_template = true

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  default_branch_protection_settings = each.value.default_branch_protection_settings
}

########################################################
# Services repositories
########################################################
module "repository_svc_template" {
  source   = "./modules/github-repository/"
  for_each = { for key, settings in local.svc_template.repos : key => merge(local.template_default.settings, settings) }

  name        = format("svc-template-%s", each.key)
  description = format("Arrow Service Template - %s", each.value.description)
  is_template = true

  # Settings with defaults
  owner_team     = each.value.owner_team
  visibility     = each.value.visibility
  default_branch = each.value.default_branch
  webhooks       = each.value.webhooks

  default_branch_protection_settings = each.value.default_branch_protection_settings
}
