import json
from azure.core.exceptions import ResourceNotFoundError
from azure.core.credentials import AzureKeyCredential
from azure.ai.formrecognizer import FormTrainingClient
from azure.ai.formrecognizer import FormRecognizerClient

"""
Analyze Receipt
"""

credentials = json.load(open('./credential.json'))
API_KEY = credentials['API_KEY']
ENDPOINT = credentials['ENDPOINT']
form_recognizer_client = FormRecognizerClient(ENDPOINT, AzureKeyCredential(API_KEY))

# noticed that not all receipts yield good results
receipt_url = 'https://media-cdn.tripadvisor.com/media/photo-s/14/3d/1a/03/photo4jpg.jpg'
poller = form_recognizer_client.begin_recognize_receipts_from_url(receipt_url)

result = poller.result()
for receipt in result:
    for name, field in receipt.fields.items():
        if name == "Items":
            print("Receipt Items:")
            for idx, items in enumerate(field.value):
                print("...Item #{}".format(idx+1))
                for item_name, item in items.value.items():
                    print("......{}: {} has confidence {}".format(item_name, item.value, item.confidence))
        else:
            print("{}: {} has confidence {}".format(name, field.value, field.confidence))
