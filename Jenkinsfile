pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/yeshwanthlm/Terraform-Jenkins.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
                sh "pwd;cd terraform/ ; terraform plan -out tfplan"
                sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Resource Selection') {
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    def userInput = input(
                        message: "Which AWS resource do you want to create?",
                        parameters: [
                            choice(name: 'resourceType', choices: 'EC2\nS3', description: 'Select AWS resource type to create')
                        ]
                    )

                    if (userInput.resourceType == 'EC2') {
                        sh "echo 'You selected EC2 resource creation'"
                        // Add your EC2 Terraform configuration here
                    } else if (userInput.resourceType == 'S3') {
                        sh "echo 'You selected S3 bucket creation'"
                        // Add your S3 bucket Terraform configuration here
                    } 
                }
            }
        }		
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
    }

  }
