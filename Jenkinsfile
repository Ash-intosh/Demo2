def TF_STACK = ["storage"]

environment {
    ARM_USE_MSI = true
  }

pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    stages {
        stage('Hello') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'MY_SUBSCRIPTION_ID', variable: 'SUB_ID')]) {
                        sh '''
                            az login --identity
                            az account set -s $SUB_ID
                            echo "Entered Azure"
                        '''
                        for (stack in TF_STACK) {
                            def TF_EXEC_PATH = stack
                            def TF_BACKEND_CONF = "-backend-config='resource_group_name=cloud-shell-storage-centralindia' -backend-config='storage_account_name=csg100320015b8221a2' -backend-config='container_name=demotstate' -backend-config='key=terraform.tfstate'"
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
                echo 'Hello World'
            }
        }
        stage("Closure"){
            steps{
                echo "Closure stage"
            }
        }
    }
     post {
    always {
      cleanWs()
    }
  }

}
