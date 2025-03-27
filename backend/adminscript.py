#CONSUMPTION + INVENTORY + EXPIRY TRACKING
import requests 
import json
from datetime import datetime
import random
from datetime import timedelta
ip = "http://192.168.0.131"

url = ip + "/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up"

def addItem(url, barcode):
    headers = {'User-Agent': 'My User Agent 1.0'}
    data = requests.get('https://world.openfoodfacts.net/api/v2/product/' + str(barcode), headers=headers)
    data = json.loads(data.text)
    category =""
    categories = ["en:dairies", "en:beverages", "en:snacks", "en:condiments"]
    for cat in data['product']['categories_hierarchy']:
        if cat in categories:
            category = cat
    if category == "":
        category = "miscellaneous"
    url = url + "&insert=ItemInfo"
    tosend = {'barcode': barcode,'itemName':data['product']['product_name'], 'itemCategory': category}
    res = requests.post(url, json=tosend)
    return res

def getItems(url):
    url = url + "&get=ItemInfoAll"
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def getItem(url, barcode):
    url = url + "&get=ItemInfo"
    tosend = {'barcode': barcode}
    res = requests.post(url, json=tosend)
    res = json.loads(res.text)
    print(url)
    return res

def decreaseQuantity(url, barcode, quantity):
    url = url + "&update=ItemInfoDecrease"
    tosend = {'barcode': barcode, 'itemQuantity': quantity}
    res = requests.post(url, json=tosend)
    return res

def increaseQuantity(url, barcode, quantity):
    url = url + "&update=ItemInfoIncrease"
    tosend = {'barcode': barcode, 'itemQuantity': quantity}
    res = requests.post(url, json=tosend)
    return res

def removeItem(url, barcode, quantity):
    #first request records that an item was taken out and when and how many
    url1 = url + "&insert=ItemsRemoved"
    tosend = {'barcode':barcode, 'removedTime': str(datetime.now()), 'removedQuantity': quantity}
    res = requests.post(url1, json=tosend)
    url2 = url + "&update=ItemInfoDecrease"
    tosend = {'barcode': barcode, 'itemQuantity': quantity}
    res2 = requests.post(url2, json=tosend)
    return res2

#this one is general and applies to all categories
#making it so it generates of a list of 10 items max
def generateList(url):
    url = url + "&get=GenerateList"
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def getEmpty(url):
    url = url + "&get=ItemInfoEmptyAll"
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def getEmptyOne(url, itemCategory):
    url = url + "&get=ItemInfoEmptyOne"
    tosend = {'itemCategory': itemCategory}
    res = requests.post(url, json=tosend)
    res = json.loads(res.text)
    return res

def addExpirationDate(url, barcode, expirationDate):
    url = url + "&insert=ItemExpiration"
    tosend = {'barcode': barcode, 'expirationDate': expirationDate}
    res = requests.post(url, json=tosend)
    return res

def getExpirationDates(url):   
    url = url + "&get=ItemExpiration"
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def getCategoryPercentages(url):
    url = url + "&get=ItemCategoryPercentages"
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def getWeights(url):
    res = getCategoryPercentages(url)
    defweights = {"en:beverages": 1.0, "en:dairies": 1.0, "en:condiments": 1.0, "en:snacks": 1.0, "miscellaneous": 1.0}
    weights = []
    for item in res:
        if item['itemCategory'] in defweights:
            defweights[item['itemCategory']] -= float(item['categoryPercentage'])
            
    weights.append(defweights["en:beverages"])
    weights.append(defweights["en:dairies"])
    weights.append(defweights["en:condiments"])
    weights.append(defweights["en:snacks"])
    weights.append(defweights["miscellaneous"])
    return weights

def generateListRandom(url):
    weights = getWeights(url)
    sumEmpty = getEmptyCount(url)
    emptyPerCategory = getEmptyCounts(url)
    categories = ["en:beverages", "en:dairies", "en:condiments", "en:snacks", "miscellaneous"]
    smartList = []
    if (sumEmpty < 10):
        while (len(smartList) < sumEmpty):
            randomItemCategoryList = random.choices(categories, weights=weights, k=1)
            randomItemCategory = randomItemCategoryList[0]
            randomItem = getRandomItemCategory(url, randomItemCategory)
            emptyItemsInCategory = 0
            for item in emptyPerCategory:
                if item['itemCategory'] == randomItemCategory:
                    emptyItemsInCategory = int(item['emptyItems'])
                    break
            if randomItem not in smartList and (smartList.count(randomItemCategory) < emptyItemsInCategory):
                smartList.append(randomItem)
    else:
         while (len(smartList) < 10):
            randomItemCategoryList = random.choices(categories, weights=weights, k=1)
            randomItemCategory = randomItemCategoryList[0]
            randomItem = getRandomItemCategory(url, randomItemCategory)
            emptyItemsInCategory = 0
            for item in emptyPerCategory:
                if item['itemCategory'] == randomItemCategory:
                    emptyItemsInCategory = int(item['emptyItems'])
                    break
            if randomItem not in smartList and (smartList.count(randomItemCategory) < emptyItemsInCategory):
                smartList.append(randomItem)
    return url, smartList

def saveList(url, smartList):
    #clean list
    url = url + "&delete=GroceryList"
    res = requests.get(url)
    #add list
    for item in smartList:
        url = url + "&insert=GroceryList"
        tosend = {'barcode': item['barcode'], 'itemName': item['itemName']}
        res = requests.post(url, json=tosend)
    return res

def getRandomItemCategory(url, itemCategory):
    url = url + "&get=ItemInfoEmptyOne"
    tosend = {'itemCategory': itemCategory}
    res = requests.post(url, json=tosend)
    res = json.loads(res.text)
    return res

def getEmptyCount(url):
    url = url + "&get=ItemCategoryEmpty"
    res = requests.get(url)
    res = json.loads(res.text)
    emptySum = 0
    for item in res:
        emptySum += int(item['emptyItems'])
    return emptySum

def getEmptyCounts(url):
    url = url + "&get=ItemCategoryEmpty"
    res = requests.get(url)
    res = json.loads(res.text)
    return res
        
        
print(getItems(url))