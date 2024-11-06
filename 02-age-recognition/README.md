# age recognition

This section explains the steps to add age recognition functionality to your function endpoint.

## Prerequisites

+ Copy `function_app.py` and `box_utils.py` from this folder to your HttpTrigger folder. Overwrite `function_app.py`
+ Download the model
  from https://github.com/onnx/models/blob/main/validated/vision/body_analysis/age_gender/models/vgg_ilsvrc_16_age_imdb_wiki.onnx
  and put it in the `HttpTrigger/models` folder
+ Press `F5` to start the function app

+ Test the function app - make a new request to http://localhost:7071/api/HttpTrigger
    + Select an image of your choice
    + Either select your image of choice, base64 encode it and use the `request.http` in this directory
        + Online Encoders can speed up your process: https://elmah.io/tools/base64-image-encoder/
    + Or use the `upload.html` to upload your image of choice
        + To get it working you need to consider CORS
        + For local development extend `local.settings.json`
          ```
          {
            "IsEncrypted": false,
            "Values": {
              "AzureWebJobsStorage": "",
              "FUNCTIONS_WORKER_RUNTIME": "python"
            },
            "Host": {
              "CORS": "*"
            }
          }
          ```

    + For deployed versions go to https://portal.azure.com
        + Navigate to functions app and enable CORS for the domain * (menu point on the left side at the bottom)
        + In production do not enable *, just for testing here. If you want to be precise just enter the domain you are
          executing the request from.
        + ![cors.JPG](cors.JPG)

+ Upload the function as you've become to learn from step 1.
+ Try it again with the Azure function app.
