# Emotion recognition

Goal -> Add emotion recognition to your azure function. `;) :) :( :|`

This section explains the first steps to add emotion recognition:

+ See https://github.com/onnx/models/tree/main/validated/vision/body_analysis/emotion_ferplus for documentation of the emotion recognition model.
+ Add code to use this model to generate the emotion and display it next to the age.
+ Be aware that due to memory restrictions on functions (1.5Gb RAM) emotion and age classification will not work at the same time - Choose either or. ;)
+ Hint 1: It will be similar to the age recognition.
+ Hint 2: The input dimension is (Nx1x64x64). So the image needs to be grayscale.
+ Hint 3:
```
    sentiment_to_text = {
        0: "Angry",
        1: "Disgust",
        2: "Fear",
        3: "Happy",
        4: "Sad",
        5: "Surprise",
        6: "Neutral"
    }
```
Happy Coding!
