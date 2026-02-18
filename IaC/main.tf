##############################
#S3 configuration
##############################

resource "aws_s3_bucket" "s3-data" {
	bucket = "bron-silv-data"
}

resource "aws_s3_bucket" "file-transfers" {
	bucket = "frankstransfers"
}

##############################
#RDS Postgres
##############################
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.dataprj-public-sub.id, aws_subnet.dataprj-public-sub-in-another-az.id]
  description = "Single subnet for dev RDS"
}

resource "aws_db_instance" "analytics" {
  	allocated_storage = 20
  	engine = "postgres"
  	instance_class = "db.t3.micro"
  	db_name = "analytics"
  	username = "dbadmin"
  	password = var.db_password
 	identifier = "analytics"
	db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
 
  skip_final_snapshot = true
}


##############################
#Network configuration
##############################


resource "aws_vpc" "dataprj" {
        cidr_block = "10.20.0.0/16"

	tags = {
		Name = "dataprj-vpc"
	}
}

resource "aws_subnet" "dataprj-public-sub" {
	vpc_id = aws_vpc.dataprj.id
	cidr_block = "10.20.1.0/24"
	map_public_ip_on_launch = true	
	
	tags = {
		Name = "dataprj-vpc-pubsub"
	}

}

resource "aws_subnet" "dataprj-public-sub-in-another-az" {
	vpc_id = aws_vpc.dataprj.id
	cidr_block = "10.20.2.0/24"
	map_public_ip_on_launch = true	
	availability_zone = "us-east-1b"
	tags = {
		Name = "dataprj-vpc-pubsub-in-another-az"
	}

}

resource "aws_internet_gateway" "igw-dataprj" {
	vpc_id = aws_vpc.dataprj.id
}

#resource "aws_acm_certificate" "client-vpn-server-cert" 
#	count = 0
#	private_key = file("${path.module}/client-vpn-certs/server.key")
#	certificate_body = file("${path.module}/client-vpn-certs/server.crt")
#	certificate_chain = file("${path.module}/client-vpn-certs/ca.crt")


#resource "aws_ec2_client_vpn_endpoint" "dataprj-client-vpn" 
#        count = 0
#	 description = "Client VPN for accessing aws data-prj vpc"
#        server_certificate_arn = aws_acm_certificate.client-vpn-server-cert.id
#        client_cidr_block = "10.9.0.0/22"

#	authentication_options 
#		type = "certificate-authentication"
#		root_certificate_chain_arn = aws_acm_certificate.client-vpn-server-cert.id
#	

#	connection_log_options 
#		enabled = false

#	
#


#resource "aws_ec2_client_vpn_network_association" "dataprj-vpc-ass" 
#	count = 0
#	client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.dataprj-client-vpn.id
#	subnet_id = aws_subnet.dataprj-public-sub.id
#


###       Route table and  Routes         #####
data "aws_route_table" "dataprj-vpc-rt" {
	vpc_id = aws_vpc.dataprj.id
}

resource "aws_route" "internet-access" {
		route_table_id = data.aws_route_table.dataprj-vpc-rt.id
		destination_cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw-dataprj.id
}

###############################
#Security Groups
###############################

resource "aws_security_group" "allow-ssh" {
	name = "allow-ssh-sg"
	description = "Allow SSH to connect to Instances"
	vpc_id = aws_vpc.dataprj.id

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["76.193.44.238/32"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}



}

resource "aws_security_group" "allow-rdp" {
        name = "allow-rdp-sg"
        description = "Allow RDP to connect to Instances"
        vpc_id = aws_vpc.dataprj.id

        ingress {
                from_port = 3389
                to_port = 3389
                protocol = "tcp"
                cidr_blocks = ["76.193.44.238/32"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }



}

data "aws_security_group" "ec2-rds-1" {
  id = "sg-01ac899e601299db7"
}


###############################
#Compute configuration
###############################
resource "aws_instance" "cloudworkspace" {
	ami = "ami-0ecb62995f68bb549"
	instance_type = "t2.micro"
	key_name = "keypair"
	subnet_id = aws_subnet.dataprj-public-sub.id

	vpc_security_group_ids = [
		aws_security_group.allow-ssh.id,
		data.aws_security_group.ec2-rds-1.id
	]

	tags = {
		Name = "cloudworkspace"
	}

}

resource "aws_instance" "powerbi" {
        ami = "ami-08a907777e5410897"
        instance_type = "t2.large"
        key_name = "keypair"
        subnet_id = aws_subnet.dataprj-public-sub.id
	get_password_data = true

        vpc_security_group_ids = [
                aws_security_group.allow-rdp.id,
		data.aws_security_group.ec2-rds-1.id
        ]

        tags = {
                Name = "powerBI"
        }

}

#################################
#IAM Roles & policies
#################################


#IAM role for company info api extraction function

resource "aws_iam_role" "comp-info-lambda" {
	name = "comp-info-lambda"
	assume_role_policy = jsonencode({ 
		Version = "2012-10-17" 
		Statement = [{ 
			Effect = "Allow" 
				Principal = { 
					Service = "lambda.amazonaws.com" 
				} 
			Action = "sts:AssumeRole" 
		}] 
	}) 
}


#Attaches basic lambda execuction policy to company info api extraction lambda function

resource "aws_iam_role_policy_attachment" "basiclambdaexec-for-comp-info-func" {
	role = aws_iam_role.comp-info-lambda.name
	policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#Attaches s3 write policy to company info api extraction lambda function

resource "aws_iam_role_policy_attachment" "s3write-for-comp-info-func" {
	role = aws_iam_role.comp-info-lambda.name
	policy_arn = aws_iam_policy.allow-s3-write.arn
}

#IAM role for stock price info api extraction function

resource "aws_iam_role" "stock-price-lambda" {
        name = "stock-price-lambda"
        assume_role_policy = jsonencode({
                Version = "2012-10-17"
                Statement = [{
                        Effect = "Allow"
                                Principal = {
                                        Service = "lambda.amazonaws.com"
                                }
                        Action = "sts:AssumeRole"
                }]
        })
}


#Attaches basic lambda execuction policy to stock price api extraction lambda function

resource "aws_iam_role_policy_attachment" "basiclambdaexec-for-stock-price-func" {
        role = aws_iam_role.stock-price-lambda.name
        policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#Attaches s3 write policy to stock price api extraction lambda function

resource "aws_iam_role_policy_attachment" "s3write-for-stock-price-func" {
        role = aws_iam_role.stock-price-lambda.name
        policy_arn = aws_iam_policy.allow-s3-write.arn
}

#IAM role for transforming bronze company info data into silver ready to load data function

resource "aws_iam_role" "trans-compinfo-lambda" {
        name = "trans-compinfo-lambda"
        assume_role_policy = jsonencode({
                Version = "2012-10-17"
                Statement = [{
                        Effect = "Allow"
                                Principal = {
                                        Service = "lambda.amazonaws.com"
                                }
                        Action = "sts:AssumeRole"
                }]
        })
}


#Attaches basic lambda execuction policy to transform companyinfo lambda function

resource "aws_iam_role_policy_attachment" "basiclambdaexec-for-trans-compinfo-func" {
        role = aws_iam_role.trans-compinfo-lambda.name
        policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#Attaches s3 write policy to transform companyinfo lambda function

resource "aws_iam_role_policy_attachment" "s3write-for-trans-compinfo-func" {
        role = aws_iam_role.trans-compinfo-lambda.name
        policy_arn = aws_iam_policy.allow-s3-write.arn
}

#Attaches s3 rread policy to transform-company-info lambda function

resource "aws_iam_role_policy_attachment" "s3read-for-trans-compinfo-func" {
        role = aws_iam_role.trans-compinfo-lambda.name
        policy_arn = aws_iam_policy.allow-s3-read.arn
}





#Creates policy to allow writing objects to s3

resource "aws_iam_policy" "allow-s3-write" {
	name = "allow-s3-write"
	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
		{
		Action = ["s3:PutObject"]
		Effect = "Allow"
		Resource = "*"
		}
		]
	})
}

#Creates policy to allow reading objects from s3

resource "aws_iam_policy" "allow-s3-read" {
        name = "allow-s3-read"
        policy = jsonencode({
                Version = "2012-10-17"
                Statement = [
                {
                Action = ["s3:GetObject"]
                Effect = "Allow"
                Resource = "*"
                }
                ]
        })
}


#################################
#Serverless
#################################

resource "aws_lambda_layer_version" "python" {
        filename = "${path.root}/lambda-layer-zip/python.zip"
        layer_name = "python"
        description = "python dependencies"
        compatible_runtimes = ["python3.12"]
}


#This function extracts companyinfo data from api
data "archive_file" "extract-compinfo-zip" {
	type = "zip"
	source_file = "../etl/extracts/comp-info-lambda.py"
	output_path = "${path.root}/lambda-iac/comp-info-lambda.zip"
}

resource "aws_lambda_function" "extract-company-info" {
	function_name = "extract-company-info"
	filename = "${path.root}/lambda-iac/comp-info-lambda.zip"
	role = aws_iam_role.comp-info-lambda.arn
	handler = "comp-info-lambda.lambda_handler"
	code_sha256   = data.archive_file.extract-compinfo-zip.output_base64sha256
	runtime = "python3.12"
	layers = [aws_lambda_layer_version.python.arn]

	environment {
		variables = {
			APIKEY = var.api_key
		}
	}
	
}

#This function extracts stock price data from api

data "archive_file" "extract-stockprice-zip" {
        type = "zip"
        source_file = "../etl/extracts/stock-price-lambda.py"
        output_path = "${path.root}/lambda-iac/stock-price-lambda.zip"
}

resource "aws_lambda_function" "extract-stock-price" {
        function_name = "extract-stock-price"
        filename = "${path.root}/lambda-iac/stock-price-lambda.zip"
        role = aws_iam_role.stock-price-lambda.arn
        handler = "stock-price-lambda.lambda_handler"
        code_sha256   = data.archive_file.extract-stockprice-zip.output_base64sha256
        runtime = "python3.12"
        layers = [aws_lambda_layer_version.python.arn]

        environment {
                variables = {
                        APIKEY = var.api_key
                }
        }

}

#This function transforms bronze company info data into two silver json files one for company info and one for daily market market data from api

data "archive_file" "trans-compinfo-zip" {
        type = "zip"
        source_file = "../etl/transforms/trans-compinfo-lambda.py"
        output_path = "${path.root}/lambda-iac/trans-compinfo-lambda.zip"
}

resource "aws_lambda_function" "trans-compinfo-lambda" {
        function_name = "trans-comp-info"
        filename = "${path.root}/lambda-iac/trans-compinfo-lambda.zip"
        role = aws_iam_role.trans-compinfo-lambda.arn
        handler = "trans-compinfo-lambda.lambda_handler"
        code_sha256   = data.archive_file.trans-compinfo-zip.output_base64sha256
        runtime = "python3.12"
        layers = [aws_lambda_layer_version.python.arn]

        environment {
                variables = {
                        APIKEY = var.api_key
                }
        }

}

