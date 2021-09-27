def TF_STACK = ["storage"]

def gv = load "script.groovy"

pipeline {
    agent any
    
    environment {
    ARM_USE_MSI = true
        script{
    FILENAME = gv.File_Name()
   }
   }
    
    tools {
        terraform 'terraform'
    }

    stages {
        stage('Hello') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'MY_SUBSCRIPTION_ID', variable: 'SUB_ID'), string(credentialsId: 'access_key', variable: 'ARM_ACCESS_KEY')]) {
                        sh '''
                            az login --identity
                            az account set -s $SUB_ID
                            echo "Entered Azure"
                        '''
                        for (stack in TF_STACK) {
                            def TF_EXEC_PATH = stack
                            def TF_BACKEND_CONF = " -backend-config='access_key=${ARM_ACCESS_KEY}'"
                            def TF_COMMAND = "terraform init ${TF_BACKEND_CONF}; terraform plan -var-file ${env.FILENAME}.tfvars -detailed-exitcode;"
                            def TF_COMMAND2 = "terraform apply -auto-approve -var-file ${env.FILENAME}.tfvars"
                            def exists = fileExists "${TF_EXEC_PATH}/${FILENAME}.tfvars"
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
