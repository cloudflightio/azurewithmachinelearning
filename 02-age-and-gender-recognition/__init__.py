import logging
import azure.functions as func
import base64
import numpy as np
import cv2
import onnxruntime as ort

import azure.functions as func

from .box_utils import predict

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # Get the img value from the post.
    img_base64 = req.params.get('img')
    if not img_base64:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            img_base64 = req_body.get('img')

    if img_base64:
        orig_image = decode_base64(img_base64) 

        color = (255, 128, 0)

        boxes, labels, probs = faceDetector(orig_image)

        for i in range(boxes.shape[0]):
            box = scale(boxes[i, :])
            cropped = cropImage(orig_image, box)
            gender = genderClassifier(cropped)
            logging.info(f'Box {i} --> {gender}')

            cv2.rectangle(orig_image, (box[0], box[1]), (box[2], box[3]), color, 4)
            cv2.putText(orig_image, f'{gender}', (box[0], box[1]-10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2, cv2.LINE_AA)

        img_encoded = cv2.imencode('.jpg', orig_image)
        img_response = img_encoded[1].tobytes()

        headers = {
            'Content-Type': 'image/jpeg',
            'Content-Disposition': 'attachment; filename="image.jpg"',
            'Access-Control-Allow_Origin': '*'
        }

        return func.HttpResponse(
            body=img_response,
            headers=headers,
            status_code=200)
    else:
        return func.HttpResponse(
             "No image given.", status_code=500
        )

def decode_base64(data):
    img = base64.b64decode(data)
    img = cv2.imdecode(np.fromstring(img, np.uint8), cv2.IMREAD_COLOR)
    return img


# ------------------------------------------------------------------------------------------------------------------------------------------------
# Face detection using UltraFace-640 onnx model
face_detector_onnx = "HttpTrigger/models/version-RFB-640.onnx"
face_detector = ort.InferenceSession(face_detector_onnx)

# scale current rectangle to box
def scale(box):
    width = box[2] - box[0]
    height = box[3] - box[1]
    maximum = max(width, height)
    dx = int((maximum - width)/2)
    dy = int((maximum - height)/2)

    bboxes = [box[0] - dx, box[1] - dy, box[2] + dx, box[3] + dy]
    return bboxes

# crop image
def cropImage(image, box):
    num = image[box[1]:box[3], box[0]:box[2]]
    return num

# face detection method
def faceDetector(orig_image, threshold = 0.7):
    image = cv2.cvtColor(orig_image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (640, 480))
    image_mean = np.array([127, 127, 127])
    image = (image - image_mean) / 128
    image = np.transpose(image, [2, 0, 1])
    image = np.expand_dims(image, axis=0)
    image = image.astype(np.float32)

    input_name = face_detector.get_inputs()[0].name
    confidences, boxes = face_detector.run(None, {input_name: image})
    boxes, labels, probs = predict(orig_image.shape[1], orig_image.shape[0], confidences, boxes, threshold)
    return boxes, labels, probs
# ------------------------------------------------------------------------------------------------------------------------------------------------
# Face gender classification using VGG-16 onnx model
gender_classifier_onnx = "HttpTrigger/models/vgg_ilsvrc_16_gender_imdb_wiki.onnx"
gender_classifier = ort.InferenceSession(gender_classifier_onnx)
genderList=['Female','Male']

# gender classification method
def genderClassifier(orig_image):
    image = cv2.cvtColor(orig_image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (224, 224))
    image = np.transpose(image, [2, 0, 1])
    image = np.expand_dims(image, axis=0)
    image = image.astype(np.float32)

    input_name = gender_classifier.get_inputs()[0].name
    genders = gender_classifier.run(None, {input_name: image})
    gender = genderList[genders[0].argmax()]
    return gender