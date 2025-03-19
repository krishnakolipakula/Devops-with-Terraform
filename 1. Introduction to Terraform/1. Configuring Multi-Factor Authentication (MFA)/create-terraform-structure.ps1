# Prompt the user for the base path
$basePath = Read-Host -Prompt "Enter the base path for the folder structure (Press Enter for default: C:\terraform\projects\sample-directories)"

# Use default path if none is provided
if (-not $basePath) {
    $basePath = "C:\terraform\projects\sample-directories"
    Write-Output "No base path provided. Using default: $basePath"
} else {
    Write-Output "Using provided base path: $basePath"
}

# List of directories to be created
$directories = @(
    "$basePath",
    "$basePath\modules",
    "$basePath\modules\network",
    "$basePath\modules\compute",
    "$basePath\modules\database",
    "$basePath\environments",
    "$basePath\environments\production",
    "$basePath\environments\staging",
    "$basePath\environments\development",
    "$basePath\examples",
    "$basePath\examples\exampleA",
    "$basePath\examples\exampleB"
)

# Create each directory
foreach ($dir in $directories) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir
        Write-Output "Created directory: $dir"
    } else {
        Write-Output "Directory already exists: $dir"
    }
}

# List of common files to be created in the root directory
$rootFiles = @(
    "$basePath\README.md",                     # Root README.md
    "$basePath\.gitignore",                    # .gitignore file
    "$basePath\main.tf",                       # Root main.tf
    "$basePath\variables.tf",                  # Root variables.tf
    "$basePath\outputs.tf",                    # Root outputs.tf
    "$basePath\backend.tf",                    # Optional backend.tf for remote state
    "$basePath\versions.tf"                    # Terraform version and provider constraint
)

# List of common files to be created in the modules directories
$moduleFiles = @(
    "main.tf",
    "variables.tf",
    "outputs.tf",
    "README.md"                                # Documentation for each module
)

# Create the files in the root directory
foreach ($file in $rootFiles) {
    if (-not (Test-Path -Path $file)) {
        New-Item -ItemType File -Path $file
        Write-Output "Created file: $file"
    } else {
        Write-Output "File already exists: $file"
    }
}

# Create files in each module directory
$moduleDirectories = @("$basePath\modules\network", "$basePath\modules\compute", "$basePath\modules\database")
foreach ($moduleDir in $moduleDirectories) {
    foreach ($file in $moduleFiles) {
        $filePath = Join-Path $moduleDir $file
        if (-not (Test-Path -Path $filePath)) {
            New-Item -ItemType File -Path $filePath
            Write-Output "Created file: $filePath"
        } else {
            Write-Output "File already exists: $filePath"
        }
    }
}

# List of example files to be created in the examples directory
$exampleFiles = @(
    "main.tf"
)

# Create example files in each example directory
$exampleDirectories = @("$basePath\examples\exampleA", "$basePath\examples\exampleB")
foreach ($exampleDir in $exampleDirectories) {
    foreach ($file in $exampleFiles) {
        $filePath = Join-Path $exampleDir $file
        if (-not (Test-Path -Path $filePath)) {
            New-Item -ItemType File -Path $filePath
            Write-Output "Created file: $filePath"
        } else {
            Write-Output "File already exists: $filePath"
        }
    }
}

# List of environment-specific files to be created in the environments directories
$environmentFiles = @(
    "main.tf",
    "variables.tf",
    "outputs.tf"
)

# Create environment-specific files
$environmentDirectories = @("$basePath\environments\production", "$basePath\environments\staging", "$basePath\environments\development")
foreach ($envDir in $environmentDirectories) {
    foreach ($file in $environmentFiles) {
        $filePath = Join-Path $envDir $file
        if (-not (Test-Path -Path $filePath)) {
            New-Item -ItemType File -Path $filePath
            Write-Output "Created file: $filePath"
        } else {
            Write-Output "File already exists: $filePath"
        }
    }
}

# Optional content for README.md files
$readmeContent = @"
# Terraform Project

This is the infrastructure for a terraform project.

- **modules/**: Contains reusable modules for network, compute, and database.
- **environments/**: Contains environment-specific configurations for production, staging, and development.
- **examples/**: Provides example usage of the modules.

## Usage
terraform init  
terraform plan  
terraform apply  
terraform destroy  


"@

# Add README content to root README.md if it's empty
$readmePath = "$basePath\README.md"
if ((Get-Content $readmePath) -eq $null) {
    Set-Content $readmePath $readmeContent
    Write-Output "Added content to $readmePath"
}

Write-Output "Folder structure and files have been created successfully!"
