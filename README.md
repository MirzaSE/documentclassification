# Document Classification

The purpose of this solution is to complete problem given on interview with [HeavyWater](https://github.com/HeavyWater-Solutions/document-classification-test)

## Installation

In order to use solution, one should have installed [terraform](https://www.terraform.io/intro/index.html) and [.NET Core Global Tools for AWS](https://aws.amazon.com/blogs/developer/net-core-global-tools-for-aws/):

```bash
dotnet tool install -g Amazon.Lambda.Tools
```

## Usage

**Classification Model**

The classification model is trained using [Amazon Comprehend](https://aws.amazon.com/comprehend/) service. there are Terraform scripts in Terraform/Comprehend folder that can start custom classification and create necessary endpoint. 

**Rest API**

Download the repository content and do the following:
1. Build Lambda project *HeavyWater.DocumentClassificator.csproj* using Global tools for AWS or Visual Studio
2. Navigate to Terraform/variables.tf and change neccessary variables
3. Deploy using ```terraform apply ``` function


**Testing**

Solution contains Index.html that can be used for testing. One just need to change variable `apiUrl` on line 10.

