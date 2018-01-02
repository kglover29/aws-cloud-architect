#
# VARIABLE LIST FOR TABLEAU-enterprise-apps-pre-prod TERRAFORM ACCOUNT TEMPLATE
#
team_name = "tableauid-vnext-ext"
account_id = "703133035043"
profile = "saml"

us-west-2_0_public_vpc_cidr = "172.31.0.0/16"
us-west-2_0_private_vpc_cidr = "10.176.88.0/22"
us-west-2_availability_zones = ["us-west-2a", "us-west-2b"]

tags_map = {
  "APPLICATION" = "tableau-id"
  "OWNER ALIAS" = "TechOps.IT.InfrastructureEngineering.CloudInfrastructure@tableau.com"
  "PROJECT CODE" = "460"
  "ENVIRONMENT" = "pre-prod"
  "GROUP ALIAS" = "aws-tableau-enterprise-apps-pre-prod@tableau.com"
}
shared_services_profile = "shared_services"

shared_service_vpc_id ="vpc-fd56e69a"
shared_service_acct_number = "856625929754"

shared_service_vpc_cidr = "10.176.8.0/22"
