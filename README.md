# Master-TF
This is the most up-to-date development of TF code.

# Current Status:
Can pass variable = true for any of the 6 NGFW vendors (Fortinet, Sophos, Cisco, Juniper, PAN and Watchguard), it will push out their latest version of their FW. 
If different version is needed we'll need to query that info and add it into the code, but its easy to do.

This will also push out the three subnets, you can name them in the appropriate variables (or let them take the default names).
The subnets each have a nic attached to the NGFW, they have Routing tables and an NSG all associated with the subnets.

For SP use: Validate if they need pay-as-you-go or BYOL, as that will likely need to be updated in the appropriate fields (bottom of the Virtual Machine chunk).

This code is now modularized, the main.tf Root Module at the top of the heirarchy contains variable declarations, and creates the Resource Group and Network.
The FW modules produce the selected NGFW, the NICs for the NGFW, Public IPs and configures the NGFW for Autoshutdown @ 10pm CST.

The EDR module includes an optional EDR Ubuntu image, created by BNailling. Mark EDR variable true for deployment.

Can deploy any number of Win10 systems from snapshot with the win10snap variable.

# Next Step
fix MSFT terms issue with win10 deployments from marketplace.

Go into GCP.
