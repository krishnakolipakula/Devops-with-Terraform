Make sure that you first create the linux2 web_server instance using this configuration.
That means running:
terraform init
terraform plan
terraform apply

Then you must change the Name tag to web_application_server and change 
the reference to the AMI in main.tf to the linux2023 AMI.
Then run:
terraform plan
terraform apply

In summary, you must have deployed the original instance first, made the modifications to the configuration,
and then your infrastructure will be at the same state as it is at the start of this demo. So if you are 
following along by performing those steps, your infrastructure will be in a state where you can destroy it 
as per the instructions in this demonstration.