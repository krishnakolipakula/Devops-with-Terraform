terraform {
  required_providers {
    sentinel = {
      source  = "hashicorp/sentinel"
      version = "~> 1.0"
    }
  }
}

provider "sentinel" {
  policy_files = ["path/to/your/policy.sentinel"]
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c9483720cff7227e" # Replace with your desired AMI
  instance_type = "t2.micro"
  # ... other configuration ...
}


## Example policy.sentinel file
policy "no_public_ips" {
  rule = all(aws_instance[*], !any(ip in resource.aws_instance[*].public_ip, true))
}
