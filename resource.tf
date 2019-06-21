#Create a resource group 
resource "azurerm_resource_group" "rg" 
{
		name 		= "Test_Zone"
		Location 	= "southindia"
	tags = {
	Environment = "Development"
	Users		= "Test_Users"
			}	
}

	