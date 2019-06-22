#Create a resource group 
resource "azurerm_resource_group" "rg"{
		name 		= "Test_Zone"
		location 	= "southindia"
	tags = {
	Environment = "Development"
	Users	    = "Test_Users"
		}	
}

	
