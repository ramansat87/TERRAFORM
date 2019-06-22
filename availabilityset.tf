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
