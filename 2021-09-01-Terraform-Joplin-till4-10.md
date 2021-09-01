## 4. VPC Defaults in AWS
- Route table - 
	- To route **traffic within VPC (local Target)** - Entry for I**P address range as applied to VPC**
	- Default GW: 
- Subnet or AZ in region ( 3 AZ in my region )
- Default NACL: open
- Default SG: Closed

## 5. Deep Dive 
- Route table: **Main/ Not Main** for a VPC
	- Routes
	- Subnet Association: A subnet in VPC if not defined is assumed to be associated with **main route table**

## Imp points

1. A Region have a default VPC

