#Create a provider
provider "azurerm" {

}

#Create a resource group
resource "azurerm_resource_group" "rg" {

	name		  = "rnd_rg"
	location	= "southindia"
}

#Create a Vnet
resource "azurerm_virtual_network" "vnet" {

	name	              	= "rnd_vnet"
	location            	= "${azurerm_resource_group.rg.location}"
   resource_group_name  = "${azurerm_resource_group.rg.name}"
	address_space        	= ["10.0.0.0/16"]
}

#Create a subnet	
resource "azurerm_subnet" "svnet" {

	name		                   = "rnd_snet"
	resource_group_name        = "${azurerm_resource_group.rg.name}"
	virtual_network_name       = "${azurerm_virtual_network.vnet.name}"
	address_prefix	           = "10.0.10.0/24"
network_security_group_id    = "${azurerm_network_security_group.ensg.id}"
}

#Create a network security group gor Subnet
resource "azurerm_network_security_group" "ensg" {

	name			          = "rnd_snet_nsg"
	location		        = "${azurerm_resource_group.rg.location}"
	resource_group_name	= "${azurerm_resource_group.rg.name}"
 security_rule {
		  name		              = "nr1"
		  priority	            = "101"
		  direction	            = "inbound"
		  access	              = "allow"
		  protocol	            = "*"
 source_port_range		      = "*"
 destination_port_range 	  = "*"
 source_address_prefix		  = "*"
 destination_address_prefix	= "*"
                }
}

#Create a Network Security Group for VM
resource "azurerm_network_security_group" "insg" {
	
	name			          = "rnd_vm_nsg"
	location		        = "${azurerm_resource_group.rg.location}"
	resource_group_name	= "${azurerm_resource_group.rg.name}"
 security_rule {
		  name		                  = "r1"
		  priority                	= "101"
		  direction               	= "inbound"
		  access	                  = "allow"
		  protocol                	= "*"
     source_port_range  	      = "*"
     destination_port_range	    = "*"
     source_address_prefix	    = "*"
     destination_address_prefix	= "*"	
		}
}	  

#Create a public IP
resource "azurerm_public_ip" "pip" {
	
	name	              = "rnd_pip"
	location	          = "${azurerm_resource_group.rg.location}"
	resource_group_name = "${azurerm_resource_group.rg.name}"
	allocation_method   = "Dynamic"
}
	
#Create a network interface
resource "azurerm_network_interface" "nic" {

	name		                  = "rnd_nic"
	resource_group_name       = "${azurerm_resource_group.rg.name}"
	location 	                = "${azurerm_resource_group.rg.location}"
	network_security_group_id = "${azurerm_network_security_group.insg.id}"
 ip_configuration {
	name		                      = "rnd_ip"
	subnet_id	                    = "${azurerm_subnet.svnet.id}"
	private_ip_address_allocation = "dynamic"
	public_ip_address_id	        = "${azurerm_public_ip.pip.id}"
                   }
}

#Create a VM
resource "azurerm_virtual_machine" "vm" {

		name		            = "VM1"
		location	          = "${azurerm_resource_group.rg.location}"
	resource_group_name 	= "${azurerm_resource_group.rg.name}"
	network_interface_ids	= ["${azurerm_network_interface.nic.id}"]
	       vm_size		    = "standard_D2_V2"
	
	storage_image_reference {
		publisher 	= "MicrosoftWindowsServer"
		offer		    = "WindowsServer"
		sku	      	= "2016-Datacenter-Server-smalldisk"
		version		  = "latest"
				}

	storage_os_disk {
		name		              = "rnd_disk"
		caching		            = "readwrite"
		create_option	        = "fromimage"
	      managed_disk_type = "Standard_LRS"
			}

	os_profile	{
		computer_name 	= "RND-Machine"
		admin_username	= "zone"
		admin_password  = "Enter@123456"
			}
os_profile_windows_config {
       }
}


