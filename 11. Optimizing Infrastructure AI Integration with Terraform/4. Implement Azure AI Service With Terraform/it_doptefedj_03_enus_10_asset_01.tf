provider "azurerm" {
  features {}
}

# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-ai-service"
  location = "East US"
}

# Azure Machine Learning Workspace
resource "azurerm_machine_learning_workspace" "aml_workspace" {
  name                = "aml-workspace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                     = "aiContainerRegistry"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true
}

# Azure Container Instance for Model Hosting
resource "azurerm_container_group" "container_group" {
  name                = "ai-model-container"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  containers {
    name   = "model-container"
    image  = "${azurerm_container_registry.acr.login_server}/model-image:latest"
    cpu    = "1"
    memory = "1.5"
  }
  tags = {
    environment = "production"
  }
}

# Azure Role Assignment for Permissions
resource "azurerm_role_assignment" "aml_role" {
  principal_id   = azurerm_container_group.container_group.id
  role_definition_name = "Contributor"
  scope           = azurerm_machine_learning_workspace.aml_workspace.id
}

