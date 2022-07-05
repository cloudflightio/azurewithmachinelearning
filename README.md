# azurewithmachinelearning
Guided project for creating a serverless azure function in combination with a machine learning model.

The endpoint will accept an image to be uploaded and will return information about the uploaded image like age, gender, emotions.

![finalResult.JPG](finalResult.JPG)    

## Pre Requisites

To do the live coding efficiently there are some pre-requisites that need to be done (see below)

One of them is creating a free azure account (and a subscription) per team. The main reason for doing so is, that even after your visit you can continue experimenting and working on your Azure account and learn even more. 

If there are any obstacles please contact us then we need to find another solution.
Prerequisites for live coding

    Students form teams of 2-3
    each team needs a free azure account https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio
        if the school is eligble https://azure.microsoft.com/en-gb/free/students/
    each team has to prepare a laptop with the following software:        
        install Python 3.7 https://www.python.org/downloads/release/python-370/
            add python install directory to your PATH variable
            add phyton install directory /SCRIPTS to your PATH variable
                C:\Users\<USERNAME>\AppData\Local\Programs\Python\Python37
                C:\Users\<USERNAME>\AppData\Local\Programs\Python\Python37\Scripts
            verify with typing python --version
        install following python packages with
            python -m pip install azure.functions 
            python -m pip install opencv-python
            python -m pip install onnxruntime
            python -m pip install numpy
        install Visual Studio Code https://code.visualstudio.com/
        install Python extenstion https://marketplace.visualstudio.com/items?itemName=ms-python.python
        install Azure CLI https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
        install Azure Function extension https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions 
        install Arzue Function Core Tools https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash#install-the-azure-functions-core-tools
        install Postman https://www.postman.com/

## How To

+ Login to Azure in Visual studio code
    + Terminal in VS Code <code>az login</code> (Opens browser, login there)   
+ Checkout and open folder 01-echoFunction
+ Continue with 02 and 03

