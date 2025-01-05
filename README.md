# Terraform innitial utilities (AWS)
Small terraform based project deploying into AWS cloud provider utilizing free teir spending.

# Main Branch
The main branch of this project aims to provide an out of the box mini network that gives users the basic utilities that can be further customised to their liking.
This includes:
- A vpc
- An ubuntu desktop virtual machine running on t2.micro
- An ubuntu server virtual machine runnign on t2.micro
- Security groups to allow internet access
- Security groups to allow ssh conectability to deployed virtual machines
- Client side secure key generation 

== Requirements

[cols="a,a",options="header,autowidth"]
|===
|Name |Version
|[[requirement_aws]] <<requirement_aws,aws>> |5.66.0
|[[requirement_local]] <<requirement_local,local>> |2.5.2
|[[requirement_tls]] <<requirement_tls,tls>> |4.0.6
|===

== Providers

[cols="a,a",options="header,autowidth"]
|===
|Name |Version
|[[provider_aws]] <<provider_aws,aws>> |5.66.0
|[[provider_local]] <<provider_local,local>> |2.5.2
|[[provider_tls]] <<provider_tls,tls>> |4.0.6
|===

== Modules

No modules.

== Resources

[cols="a,a",options="header,autowidth"]
|===
|Name |Type
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/eip[aws_eip.ip-test] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/instance[aws_instance.app_server] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/instance[aws_instance.webserver] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/internet_gateway[aws_internet_gateway.gw] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/key_pair[aws_key_pair.generated_key] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/key_pair[aws_key_pair.ubuntuDT_key_pair] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/kms_key[aws_kms_key.s3key] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/route_table[aws_route_table.route-table-test-env] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/route_table_association[aws_route_table_association.subnet-association] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/s3_bucket[aws_s3_bucket.annysahbucket] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/s3_bucket_server_side_encryption_configuration[aws_s3_bucket_server_side_encryption_configuration.s3encryption] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/security_group[aws_security_group.allow_ssh] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/security_group[aws_security_group.instance_sg] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/subnet[aws_subnet.new_subnet] |resource
|https://registry.terraform.io/providers/hashicorp/aws/5.66.0/docs/resources/vpc[aws_vpc.new] |resource
|https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file[local_file.dev_key_ready] |resource
|https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file[local_file.ssh_key] |resource
|https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/resources/private_key[tls_private_key.dev_key] |resource
|https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/resources/private_key[tls_private_key.priv_key] |resource
|===

== Inputs

[cols="a,a,a,a,a",options="header,autowidth"]
|===
|Name |Description |Type |Default |Required
|[[input_file_name]] <<input_file_name,file_name>>
|Dev_key
|`string`
|n/a
|yes

|[[input_key_name]] <<input_key_name,key_name>>
|The name of the key pair
|`string`
|n/a
|yes

|===

== Outputs

[cols="a,a",options="header,autowidth"]
|===
|Name |Description
|[[output_private_key]] <<output_private_key,private_key>> |n/a
|[[output_public_ip]] <<output_public_ip,public_ip>> |n/a
|===
