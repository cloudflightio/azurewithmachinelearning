# azurewithmachinelearning
Sample project for creating a serverless azure function in combination with a machine learning model

## Pre Requisites
+ Install JDK 11
+ Install Maven >= 3
+ Azure Free Subscription
	+ either https://azure.microsoft.com/en-us/free/
	+ or if school is eligable https://azure.microsoft.com/en-us/free/students/
+ Azure CLI https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
	+ Verify with az login (opens browser for login)
	+ az account list (shows your account)

Optional 
+ Install Visual Studio Code https://code.visualstudio.com/
+ Install Java extension pack https://code.visualstudio.com/
+ Install Azure Functions extension https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions

or

+ IntelliJ with Maven and JDK11

## How To

+ Checkout and open folder 01-echoFunction
+ Execute mvn clean install
+ Make sure you are logged in az login
+ Deploy function -> mvn azure-functions:deploy

