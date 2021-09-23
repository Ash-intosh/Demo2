def TF_STACK = ["storage"]

pipeline {

  agent any
  options { timestamps() }
  
  environment {
    TF_DOCKER_IMAGE      = "hashicorp/terraform"
    DOCKER_REGISTRY      = "https://hub.docker.com/r/hashicorp/terraform"
    REGISTRY_CREDENTIALS = "DOCKER_ID"
  }
  stages{
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    
    stage ('init plan apply') {
      steps {
        script {
            withCredentials([string(credentialsId: 'MY_SUBSCRIPTION_ID', variable: 'ID')]){
              withDockerRegistry(credentialsId: 'REGISTRY_CREDENTIALS', url: 'DOCKER_REGISTRY')  {
                              // Pull the Docker image from the registry
                docker.image(TF_DOCKER_IMAGE).pull()
                docker.image(TF_DOCKER_IMAGE).inside() {
                  sh 'az login --identity'
                  sh 'az account set -s "${MY_SUBSCRIPTION_ID}"'
                  for (stack in TF_STACK) {
                    def TF_EXEC_PATH = stack
                    def TF_BACKEND_CONF = "-backend-config='storage_account_name=csg100320015b8221a2' -backend-config='resource_group_name=cloud-shell-storage-centralindia' -backend-config='container_name="demotstate"' -backend-config='key=${stack}/terraform.tfstate'"
                    def TF_COMMAND = "terraform init ${TF_BACKEND_CONF}; terraform plan -var-file terraform.tfvars -detailed-exitcode;"
                    def TF_COMMAND2 = "terraform apply -auto-approve -var-file terraform.tfvars"
                    def exists = fileExists "${TF_EXEC_PATH}/terraform.tfvars"
                    if (exists) {
                      def ret = sh(script: "cd ${TF_EXEC_PATH} && ${TF_COMMAND}", returnStatus: true)
                      println "TF plan exit code: ${ret}. \n INFO: 0 = Succeeded with empty diff (no changes);  1 = Error; 2 = Succeeded with non-empty diff (changes present)"
                      if ( "${ret}" == "0" ) {
                        echo "Everything is in check"
                      }
                      else if ( "${ret}" == "1" ) {
                        error("Build failed because TF plan for ${stack} failed..")
                      }
                      else if ( "${ret}" == "2" ) {
                        if ( !params.autoApprove ) {
                          timeout(time: 1, unit: 'HOURS') {
                          input 'Approve the plan to proceed and apply'
                          }
                        }
                        sh "cd ${TF_EXEC_PATH} && ${TF_COMMAND2}"
                      }
                    }
                    else
                      echo " terraform.tfvars doesn't exists in stack: ${stack} "
                  }
                }
              }
            }
        }
      }
    }
    
  }
  post {
    always {
      cleanWs()
    }
  }
}
