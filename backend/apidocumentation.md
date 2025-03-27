# Tables

ScanSession:
* scanSessionItemID
* sessionID
* barcode

ItemInfo:
* barcode - PK
* itemName
* itemCategory
* itemQuantity

ItemExpiration:
* itemExpirationID
* barcode - FK
* expirationDate

ItemsRemoved:
* itemRemovedID
* barcode - FK
* removedTime
* removedQuantity

GroceryList: This refers to the smart grocery list
* groceryListItemID
* groceryListID
* barcode

FridgeDetails:
* fridgeID
* connectionStatus
* dateOfConnection
* modelNumber
* serialNumber

## ScanSession Process
**ScanSession stores the items that were scanned in a given session and is not directly related to ItemInfo**

Before the Session:
* Get the maximum value for sessionID (get=GetMostRecentSessionID)
* Set the sessionID in the session to SessionID + 1

During the Session:
* A session starts when the user wants to scan items from their ref
* If a single barcode has already been recognized in a single session, this barcode will not be added to the current session. (get=GetUniqueItemsForSession)

After the Session:
* Items for the current session are compared to the items in ItemInfo. (get)
* Items not already in the ItemInfo table will be added table.
    * The Item's information will only be fetched from the openfoodfacts API at this point (so we make less API calls)
* The item will be added to the database will quantity 0 if it was added for the first time
* The app pulls ItemInfo from the items that were scanned in the session for the menu for setting the quantities
* ItemInfo will be updated with the quantities

## Generating Grocery List Process

**This will be triggered when a compartment goes below 40%.**

* Get the percentages of each percentage of what is in the fridge currently.
* Subtract all of these values from 1. This means that the bigger the percentage of category, the smaller its weight, so the less likely it will be picked
* Get how many items in each category is itemQuantity=0
* Generate 10 random items
    * Randomly pick a category. If it will appear on the list more than there are available items, pick a different category
    * Pick a random item that is itemQuantity=0
    * Ask about stopping function
* As of right now, I haven't tested on if its possible to trigger something once a month. Maybe a button that triggers the same logic would be easier for testing now?

# How to Use
Base URL (use this URL when making http requests):
http://(raspberry_pi_ip_address)/api/admin/index.php?(operation)=(operation)

ALSO! AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up

## Operations

**(ALL OF THIS BELOW I AM FIXING BECAUSE THIS IS ABOUT THE SESSIONS GO TO SECTION ## Operations: Working)**

* get=FridgeDetails
* update=FridgeDetails
* insert=FridgeDetails
* delete=FridgeDetails

ALL OUTPUTS ARE IN JSON FORMAT.

* insert=ScanSession
    * This has no output
    * QUERY: "INSERT INTO `ScanSession`(`sessionID`, `barcode`) VALUES ('$sessionID','$barcode')"
* insert=ItemInfo
    * This has no output
    * QUERY: "INSERT INTO `ItemInfo`(`barcode`, `itemInfo`,`itemQuantity`) VALUES ('$barcode','$itemInfo',0)"
    * The 0 is because quantity is 0 by default (ADD UPDATE SO QUANTITY CAN BE CHANGED)
* get=GetUniqueItemsForCurrentSession
    * This returns entire row
    * QUERY: "SELECT * FROM `ScanSession` WHERE `sessionID`='$sessionID'"
* get=GetMostRecentSessionID
    * This returns entire row
    * QUERY: "SELECT * FROM `ScanSession` GROUP BY (sessionID) HAVING MAX(sessionID) LIMIT 1";
* get=GetItemInfoFromCurrentSession
    * This returns entire rows
    * QUERY: "SELECT * FROM `ItemInfo` LEFT JOIN `ScanSession` ON `ItemInfo`.`barcode` = `ScanSession`.`barcode` WHERE `ScanSession`.`sessionID`='$sessionID'"
* get=GetItemInformation
    * This returns entire rows
    

## Operations: Working

**If you see a {}, this means, you need to pass parameters into request. Also this means you need to use a post request not a get request**

**ALL OUTPUTS ARE JSON**

* insert=ItemInfo
    * {barcode, itemName, itemCategory}
    * The default value for itemQuantity when inserted is 1
* insert=ItemExpiration
    * {barcode, expirationDate}
* insert=ItemsRemoved
    * {barcode, removedTime, removedQuantity}
* delete=ItemInfo
    * {barcode}
    * Note: refrain from using this. When an item is not in the fridge, use ItemInfoDecrease and set itemQuantity to 0 somehow
* update=ItemInfoQuantity
    * {barcode, itemQuantity}
    * This updates the quantity directly to a new number
* update=ItemInfoIncrease
    * {barcode, itemQuantity}
    * This increases the itemQuantity by the value set for itemQuantity
* update=ItemInfoDencrease
    * {barcode, itemQuantity}
    * This dencreases the itemQuantity by the value set for itemQuantity
* get=ItemInfo
    * {barcode}
    * This returns a row from ItemInfo given a barcode
* get=ItemInfoAll
    * This returns all items from the itemInfo table. (This includes items where itemQuantity=0)
* get=ItemInfoEmptyAll
    * This returns all items from the itemInfo table where itemQuantity=0
* get=ItemInfoEmptyOne
    * This returns single random item from itemInfo where itemQuantity=0 and a category is given
* get=ItemInfoEmptyCategory
    * This returns all items from the itemInfo table where itemQuantity=0 given a specific category
* get=ItemExpiration
    * This returns all rows from ItemExpiration
* get=ItemCategoryPercentages
    * This returns the percentage that a given category takes up in the fridge given the total amount of space that is being taken up by items
* get=ItemCategoryEmpty
    * This returns the number of items from itemInfo where itemQuantity=0 in each category
* get=GenerateList
    * This returns the output of the following query: "SELECT `ItemInfo`.`barcode`, `ItemInfo`.`itemCategory`, IFNULL((`ItemExpiration`.`expirationdate`), '2125-03-17 03:00:28.050766') AS expirationDate FROM `ItemInfo` LEFT JOIN `ItemExpiration` ON `ItemInfo`.`barcode`=`ItemExpiration`.`barcode` WHERE `ItemInfo`.`itemQuantity`=0 ORDER BY `ItemExpiration`.`expirationdate` DESC LIMIT 10"
    * It gets what items are itemQuantity=0 then gets what expired least recently and goes up from there. The problem is it does not take into consider the category of an item


## Additional Information

NOTE: If the entire row is output, you still need to process it a bit to get the part you need (FIX LATER)

Example in dart:
final response = http.get(Uri.parse("http://192.168.0.131/api/index.php?AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up&get=FridgeDetails"));

suggestion: save the ip of the pi to a variable so you don't have to change so many assignments later

categories
BEVERAGES
DAIRIES
CONDIMENTS
SNACKS
MISC