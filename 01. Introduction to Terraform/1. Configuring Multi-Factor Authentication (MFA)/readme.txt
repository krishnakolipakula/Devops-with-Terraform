To create the folder structure, run the create-terraform-structure.ps1 in PowerShell. You'll see a message like this:
"Enter the base path for the folder structure (Press Enter for default: C:\terraform\projects\sample-directories)"

The default base path is used if you don't enter a path value. If you want to create a path for a project like webapp, then specify the entire path when prompted. For example, enter "C:\terraform\projects\webapp" and you will generate a project-based folder structure like the following:

terraform
└──projects
   └──webapp
      ├──environments
      │  ├──development
      │  ├──production
      │  └──staging
      ├──examples
      │  ├──exampleA
      │  └──exampleB
      └──modules
         ├──compute
         ├──database
         └──network