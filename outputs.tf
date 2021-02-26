output "logic_app_workflow_access_endpoint" {
  value = jsondecode(azurerm_resource_group_template_deployment.logic_app.output_content).webHookURI.value
}