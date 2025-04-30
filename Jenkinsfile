pipeline{
    agent  any
    tools{
        terraform 'terraform-11'
    }
    stages{
        stage("Code clone"){
            steps{
                git url: "https://github.com/whoavesh/iac-automation", branch: "main"
                echo "cloning process completed"
            }
        }
        stage("Initializing  terraform"){
            steps{
                sh "terraform init"
                echo "Initialization complete"
            }
        }
        stage("Verifying resources"){
            steps{
                sh "terraform plan"
                echo "Planning complete"
            }
        }
        stage("Terraform Validate"){
            steps{
                sh "terraform validate"
                echo "Planning complete"
            }
        }
        stage("Applying Changes"){
            steps{
                sh "terraform apply --auto-approve"
                echo "Infrastructure up and running - Request Successfull"
            }
        }
    }
     post {
            success {
                script{
                    emailext from:"biblabibla818@gmail.com",
                    to: "biblabibla818@gmail.com",
                    body: "Infrastructure Provisioned Successfully",
                    subject: "SUCCESS: iac-pipeline build successfull",
                    mimeType: "text/html"
                }
            }
            
            failure {
              script{
                    emailext from:"biblabibla818@gmail.com",
                    to: "biblabibla818@gmail.com",
                    body: "Error while provisioning infrastructure",
                    subject: "FAILURE: iac-pipeline build fail",
                    mimeType: "text/html"
                }
            }
        }
}
