import json
import requests
import random

ip = "http://10.115.0.140"

url = ip + "/api/admin/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up"

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
    return smartList

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

print(generateListRandom(url))