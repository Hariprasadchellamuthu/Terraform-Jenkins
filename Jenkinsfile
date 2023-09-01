def userInput // Define userInput as a global variable at the beginning

pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
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
                    userInput = input(
                        message: "Which AWS resource do you want to create?",
                        parameters: [
                            choice(name: 'resourceType', choices: 'EC2\nS3', description: 'Select AWS resource type to create')
                        ]
                    )

                    echo "Debug: userInput = ${userInput}" 
                }
            }
        }

        stage('Approval') {
            when {
                expression {
                    return userInput != null && userInput.resourceType != null
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
            when {
                expression {
                    return params.autoApprove || currentBuild.rawBuild.resultIsBetterOrEqualTo('SUCCESS')
                }
            }
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
    }
}
