import json
import base64
from flask import Flask, request
from azure.core.exceptions import ResourceNotFoundError
from azure.core.credentials import AzureKeyCredential
from azure.ai.formrecognizer import FormTrainingClient
from azure.ai.formrecognizer import FormRecognizerClient

# sets up credentials for Azure api
# input: NONE 
# output: azure api object 
def get_credentials():
    credentials = json.load(open('./credential.json'))
    API_KEY = credentials['API_KEY']
    ENDPOINT = credentials['ENDPOINT']
    return FormRecognizerClient(ENDPOINT, AzureKeyCredential(API_KEY))

# get_receipt(): Converts base64 string to receipt_pic.jpeg file 
# input: none 
# output: receipt image file
def get_receipt(b64String):
    # Converts base64 string to receipt_pic.jpeg file 
    # img_data = json.load(open('./receipt.json'))
    # with open("receipt_pic.jpeg","wb") as fh:
    #     fh.write(base64.b64decode(img_data['img_string']))
    with open("receipt_pic.jpeg","wb") as fh:
        fh.write(base64.b64decode(b64String))

    # open and read image for azure api object
    with open("./receipt_pic.jpeg", "rb") as fd:
        receipt = fd.read()
        return receipt

# parse_receipt(receipt): runs azure recognizer on receipt image 
# input: read receipt image file 
# output: dictionary of receipt objects
def parse_receipt(receipt, form_recognizer_client):
    # scans picture using premade-receipt recoginizer
    poller = form_recognizer_client.begin_recognize_receipts(receipt, locale="en-US")
    result = poller.result()
    items_d = {} # dictionary to hold receipt items and their values

    # loop through list to print and add to dictionaries 
    for receipt in result:
        for name, field in receipt.fields.items():
            if name == "Items":
                # print("Receipt Items:")
                for idx, items in enumerate(field.value):
                    temp = ''
                    for item_name, item in items.value.items():
                        if item_name == "Name":
                            items_d[item.value] = ''
                            temp = item.value
                        elif item_name == "TotalPrice":
                            items_d[temp] = item.value
            else:
                if name == "Tax" or name == "Subtotal" or name == "Total" or name == "Tip":
                    items_d[name] = field.value

    for i in items_d:
        print('Item: ', i)
        print('Value: ', items_d[i])
    return items_d

# Flask GET request for receipt items
# calls all functions 
# output: json file 
app = Flask(__name__)
@app.route("/getItems", methods = ["GET"])
def get():
    form_recognizer_client = get_credentials()

    json_data = request.get_json(silent=True)
    imageString = json_data["base64String"] # get b64 string

    receipt = get_receipt(imageString) # make b64 string into img file
    items_d = parse_receipt(receipt, form_recognizer_client) # run azure api over receipt and return dict of it's items

    return json.dumps(items_d)

if __name__ == "__main__":
    get()
