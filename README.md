# Automating a Chaos Engineering Environment (via Gremlin) on GCP with Terraform

## Requirements
1. Google Cloud Platform(GCP) Project
2. GCP service account private key
3. Google Compute Engine
4. Terraform (for automating resource creation)

A GCP project can have up to five VPC networks, and each Compute Engine instance belongs to one VPC network. If interested in the Terraform [GCP provider](https://www.terraform.io/docs/providers/google/index.html) docs or more generally about Terraform resources read [here](https://www.terraform.io/docs/configuration/resources.html).

### Terraform Installation
1. Copy link address for [Terraform](https://www.terraform.io/downloads.html) download
  ```
    $ wget https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_darwin_amd64.zip
    $ unzip terraform_0.12.16_darwin_amd64.zip
    $ mv terraform Downloads/
    $ vim ~/.profile
    Add `export "PATH=$PATH:~/Downloads"` to ~/.profile
  ```
2. `$ mkdir -p ~/terraform/vpc`
3. Verify installation: `$ terraform`

### Google Cloud Platform
1. [Create project](https://console.cloud.google.com/projectcreate) from GCP console
2. From the GCP main menu ☰ > Enable the Compute Engine API
3. Navigate to Credentials from the left panel and select **Create Credentials** > choose **Service account key** from the dropdown > **New service account**:
      + Choose a name and set role to **Editor**
      + **JSON** > **Create**
      + Now you will see your private key will download to your local machine.
4. [Install](https://cloud.google.com/sdk/docs/downloads-interactive) the [gcloud CLI](https://cloud.google.com/sdk/gcloud/). For Linux/Mac:

  ```
    $ curl https://sdk.cloud.google.com | bash
    $ exec -l $SHELL
    $ gcloud init
  ```
5. From `~/terraform/vpc`, create a Terraform config file, `main.tf` with the following configuration:

      + **Note:** You will need to edit the values of the following argument names (credentials, project)

  ```
    provider "google" {
      credentials = file("<FILE_PATH>.json")         

      project = "<PROJECT_ID>"              
      region  = "us-west1"
      zone    = "us-west1-a"
    }

    resource "google_compute_network" "vpc_network" {
      name = "terraform-network"
    }

    resource "google_compute_instance" "vm_instance" {
      name         = "terraform-instance1"
      machine_type = "f1-micro"

      boot_disk {
        initialize_params {
          image = "debian-cloud/debian-9"
        }
      }

      network_interface {
        network       = "default"
        access_config {
        }
      }
    }

  ```

6. `$ terraform init`
    + You should now see `Terraform has been successfully initialized!`
7. `$ terraform apply` and enter 'yes' to continue.
    + You should now see `Apply complete! Resources: 2 added, 0 changed, 0 destroyed.`
    + Now head back to the GCP console to see your newly created VM instance  
