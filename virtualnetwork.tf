#create a resource group
resource "azurerm_resource_group" "rg"{
		name 		= "Test_Zone"
		location 	= "southindia"
	tags = {
	Environment = "Development"
	Users	    = "Test_Users"
		}	
}


#Create a availability set
resource "azurerm_availability_set" "as" {
		name 	            = "HA"
		location            = "${azurerm_resource_group.rg.location}"
		resource_group_name = "${azurerm_resource_group.rg.name}"

	tags = {

Environment = "Testing"
Users 		= "Test_Users"

			}
}

#Create a virtual network

resource "azurerm_virtual_network" "vnet" {
		name 		= "Test_Vnet"
resource_group_name = "${azurerm_resource_group.rg.name}"
location			= "${azurerm_resource_group.rg.location}"
address_space		= "[10.0.0.0/16]"
}

#Create a subnet 

resource "azurerm_subnet" "snet" {
		name		= "snet1"
resource_group_name	= "${azurerm_resource_group.rg.name}"
virtual_network_name= "${azurerm_virtual_network.vnet.name}"
address_space 		= "[10.1.0.0/24]"
}		
	