# Demo Cloud Solution for Revolgy
- APP - Docker
- Repository - GitHub
- Cloud - AWS / EC2

## Prerequisites
- AWS account (Access Key ID and Secret Access Key required) with administrative permissions
- Generated SSH KeyPair and imported in AWS account, *.pem file saved on local disk (you will be prompted for file name and path)

## EC2 deployment
- TerraformEC2 folder
- run terraform init / apply
- after successfull deployment, web application should be accessible via http://<public_ip>:8080

## Front APP
- will be deployed automatically
- static HTML page
- exposed on port 8080
- doesn't communicate with backend DB for now

## Backend APP just for learning - not in use
- POSTGRE SQL database
- exposed on port 5432
