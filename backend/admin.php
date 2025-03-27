<?php

$connection = mysqli_connect("localhost", "root", "password", "fridgefinds");

// Check API key first
if (!isset($_GET["AdminAPIKey"]) || $_GET["AdminAPIKey"] != "AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up") {
    echo "Access Denied";
    exit;
}

// API key is correct

// SCANNING BARCODE AND EXPIRATION DATE

if (isset($_GET["insert"]) && $_GET["insert"] == "FridgeDetails") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $connectionStatus = $userInput['connectionStatus'];
    $dateOfConnection = $userInput['dateOfConnection'];
    $modelNumber = $userInput['modelNumber'];
    $serialNumber = $userInput['serialNumber'];

    $query = "INSERT INTO `FridgeDetails`(`connectionStatus`, `dateOfConnection`, `modelNumber`,`serialNumber`) VALUES ('$connectionStatus','$dateOfConnection','$modelNumber','$serialNumber')";

    mysqli_query($connection, $query);
}

if (isset($_GET["insert"]) && $_GET["insert"] == "ScanSession") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $sessionID = intval($userInput['sessionID']);
    $barcode = $userInput['barcode'];
    $ctime = $userInput['ctime'];
    $query = "INSERT INTO `ScanSession`(`sessionID`, `barcode`, `ctime`) VALUES ('$sessionID','$barcode', '$ctime')";

    mysqli_query($connection, $query);
}



// delete from database
if (isset($_GET["delete"]) && $_GET["delete"] == "FridgeDetails") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $fridgeID = $userInput['fridgeID'];
    $query = "DELETE FROM `FridgeDetails` WHERE `fridgeID`=$fridgeID ";
    mysqli_query($connection, $query);
}

// update FridgeDetails (test)
if (isset($_GET["update"]) && $_GET["update"] == "FridgeDetails") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $connectionStatus = $userInput['connectionStatus'];
    $dateOfConnection = $userInput['dateOfConnection'];
    $modelNumber = $userInput['modelNumber'];
    $serialNumber = $userInput['serialNumber'];
    $query = "UPDATE `FridgeDetails` SET `connectionStatus`='$connectionStatus',`dateOfConnection`='$dateOfConnection',`modelNumber`='$modelNumber',`serialNumber`='$serialNumber'";
    mysqli_query($connection, $query);
}

// select from database
if (isset($_GET["get"]) && $_GET["get"] == "FridgeDetails") { 
    $query = "SELECT * FROM `FridgeDetails`";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "GetUniqueItemsForCurrentSession") {
    $sessionID = intval($_GET['sessionID']);
    $query = "SELECT `barcode` FROM `ScanSession` WHERE `sessionID`='$sessionID'";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);

}

if ( isset($_GET["get"]) && $_GET["get"] == "GetMostRecentSessionID") {
    $query = "SELECT * FROM `ScanSession` GROUP BY (sessionID) ORDER BY `sessionID` DESC LIMIT 1";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "GetItemInfoFromCurrentSession") {
    $sessionID = intval($_GET['sessionID']);
    $query = "SELECT `ItemInfo`.`barcode` FROM `ItemInfo` LEFT JOIN `ScanSession` ON `ItemInfo`.`barcode` = `ScanSession`.`barcode` WHERE `ScanSession`.`sessionID`='$sessionID'";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "GetItemInfo") {
    $query = "SELECT * FROM `ItemInfo` LEFT JOIN `ScanSession` ON `ItemInfo`.`barcode` = `ScanSession`.`barcode` WHERE `ScanSession`.`sessionID`='$sessionID'";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

//INVENTORY AND CONSUMPTION TRACKING

if (isset($_GET["insert"]) && $_GET["insert"] == "ItemInfo") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemName = $userInput['itemName'];
        $itemCategory = $userInput['itemCategory'];
        $query = "INSERT INTO `ItemInfo`(`barcode`, `itemName`,`itemCategory`,`itemQuantity`) VALUES ('$barcode','$itemName','$itemCategory',1)";

        mysqli_query($connection, $query);
    }

if (isset($_GET["insert"]) && $_GET["insert"] == "ItemExpiration") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $expirationDate = $userInput['expirationDate'];
        $query = "INSERT INTO `ItemExpiration`(`barcode`, `expirationDate`) VALUES ('$barcode','$expirationDate')";
        mysqli_query($connection, $query);
    }

if (isset($_GET["insert"]) && $_GET["insert"] == "ItemsRemoved") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $removedTime = $userInput['removedTime'];
        $removedQuantity = intval($userInput['removedQuantity']);
        $query = "INSERT INTO `ItemsRemoved`(`barcode`, `removedTime`,`removedQuantity`) VALUES ('$barcode','$removedTime','$removedQuantity')";
        mysqli_query($connection, $query);
    }

if (isset($_GET["insert"]) && $_GET["insert"] == "GroceryList"){
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemName = $userInput['itemName'];
        $query = "INSERT INTO `GroceryList`(`barcode`, `itemName`) VALUES ('$barcode','$itemName')";
        mysqli_query($connection, $query);
}

if (isset($_GET["insert"]) && $_GET["insert"] == "FridgeLevel"){
    $userInput = json_decode(file_get_contents('php://input'), true);
    $fullLevel = $userInput['fullLevel'];
    $ctime = $userInput['ctime'];
    $query = "INSERT INTO `GroceryList`(`fullLevel`, `ctime`) VALUES ('$fullLevel','$ctime')";
    mysqli_query($connection, $query);
}
    
    // delete from database given a barcode
if (isset($_GET["delete"]) && $_GET["delete"] == "ItemInfo") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $query = "DELETE FROM `ItemInfo` WHERE `barcode`=$barcode ";
        mysqli_query($connection, $query);
    }

if (isset($_GET["delete"]) && $_GET["delete"] == "GroceryList") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $query = "DELETE FROM `GroceryList`";
        mysqli_query($connection, $query);
    }

if (isset($_GET["update"]) && $_GET["update"] == "ItemInfo") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemCategory = $userInput['itemCategory'];
        $itemQuantity = intval($_GET['itemQuantity']);
        $query = "UPDATE `ItemInfo` SET `itemCategory`='$itemCategory',`itemQuantity`='$itemQuantity' WHERE `barcode`='$barcode'";
        mysqli_query($connection, $query);
    }

if (isset($_GET["update"]) && $_GET["update"] == "ItemInfoQuantity") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemQuantity = intval($userInput['itemQuantity']);
        $query = "UPDATE `ItemInfo` SET `itemQuantity`='$itemQuantity' WHERE `barcode`='$barcode'";
        mysqli_query($connection, $query);
    }

if (isset($_GET["update"]) && $_GET["update"] == "ItemInfoDecrease") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemQuantity = intval($userInput['itemQuantity']);
        $query = "UPDATE `ItemInfo` SET `itemQuantity`=`itemQuantity`-'$itemQuantity' WHERE `barcode`='$barcode'";
        mysqli_query($connection, $query);
    }

if (isset($_GET["update"]) && $_GET["update"] == "ItemInfoIncrease") {
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode = $userInput['barcode'];
        $itemQuantity = intval($userInput['itemQuantity']);
        $query = "UPDATE `ItemInfo` SET `itemQuantity`=`itemQuantity`+' $itemQuantity' WHERE `barcode`='$barcode'";
        mysqli_query($connection, $query);
    }

    // select from database
if (isset($_GET["get"]) && $_GET["get"] == "ItemInfo") { 
        $userInput = json_decode(file_get_contents('php://input'), true);
        $barcode  = $userInput['barcode'];
        $query = "SELECT * FROM `ItemInfo` WHERE `barcode`=$barcode";
        $result = mysqli_query($connection, $query);
        $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($data);
    }

if (isset($_GET["get"]) && $_GET["get"] == "ItemInfoAll") { 
        $query = "SELECT * FROM `ItemInfo`";
        $result = mysqli_query($connection, $query);
        $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($data);
    }

if (isset($_GET["get"]) && $_GET["get"] == "ItemInfoEmptyAll") { 
        $query = "SELECT * FROM `ItemInfo` WHERE itemQuantity=0";
        $result = mysqli_query($connection, $query);
        $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($data);
    }

if (isset($_GET["get"]) && $_GET["get"] == "ItemInfoEmptyCategory") { 
        $userInput = json_decode(file_get_contents('php://input'), true);
        $itemCategory  = $userInput['itemCategory'];
        $query = "SELECT * FROM `ItemInfo` WHERE (itemQuantity=0) AND (itemCategory='$itemCategory')";
        $result = mysqli_query($connection, $query);
        $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
        echo json_encode($data);
    }

if (isset($_GET["get"]) && $_GET["get"] == "ItemExpiration") {
    $query = "SELECT * FROM ItemExpiration";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "GenerateList") {
    $query = "SELECT `ItemInfo`.`barcode`, `ItemInfo`.`itemCategory`, IFNULL((`ItemExpiration`.`expirationdate`), '2125-03-17 03:00:28.050766') AS expirationDate FROM `ItemInfo` LEFT JOIN `ItemExpiration` ON `ItemInfo`.`barcode`=`ItemExpiration`.`barcode` WHERE `ItemInfo`.`itemQuantity`=0 ORDER BY `ItemExpiration`.`expirationdate` DESC LIMIT 10";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "ItemCategoryPercentages") {
    $query = "SELECT `itemCategory`, SUM(`itemQuantity`) AS categoryQuantity, SUM(`itemQuantity`) / (SELECT SUM(`itemQuantity`) FROM `ItemInfo`) AS categoryPercentage FROM `ItemInfo` GROUP BY (`itemCategory`)";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "ItemCategoryPercentagesInside") {
    $query = "SELECT `itemCategory`, SUM(`itemQuantity`) AS categoryQuantity, SUM(`itemQuantity`) / (SELECT SUM(`itemQuantity`) FROM `ItemInfo`) AS categoryPercentage FROM `ItemInfo` WHERE `ItemInfo`.`itemQuantity`>0 GROUP BY (`itemCategory`)";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "ItemCategoryPercentagesOutside") {
    $query = "SELECT `itemCategory`, COUNT(`itemQuantity`) AS categoryQuantity, COUNT(`itemQuantity`) / (SELECT COUNT(`itemQuantity`) FROM `ItemInfo` WHERE `itemQuantity`=0) AS categoryPercentage FROM `ItemInfo` WHERE `ItemInfo`.`itemQuantity`=0 GROUP BY (`itemCategory`)";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "ItemCategoryEmpty") {
    $query = "SELECT COUNT(*) AS emptyItems,`itemCategory` FROM `ItemInfo` WHERE `itemQuantity`=0 GROUP BY `itemCategory`";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}

if (isset($_GET["get"]) && $_GET["get"] == "ItemInfoEmptyOne") { 
    $userInput = json_decode(file_get_contents('php://input'), true);
    $itemCategory  = $userInput['itemCategory'];
    $query = "SELECT * FROM `ItemInfo` WHERE (itemCategory='$itemCategory') AND (`itemQuantity` = 0) ORDER BY RAND() LIMIT 1";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}


if (isset($_GET["get"]) && $_GET["get"] == "GetBarcodeToScan") { 
    $userInput = json_decode(file_get_contents('php://input'), true);
    $itemCategory  = $userInput['itemCategory'];
    $query = "SELECT `barcode` FROM `ItemExpiration` WHERE `expirationDate` IS NULL LIMIT 1";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
}


if (isset($_GET["get"]) && $_GET["get"] == "GenerateList") { 
    $command = "bash -c 'source /home/pi/my-env/bin/activate && /home/pi/my-env/bin/python3 /home/pi/generateList.py 2>&1'";
    echo shell_exec($command);
}

if (isset($_GET["test"])) { 
    $query = "SELECT * FROM `ItemInfo`";
    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo "TEST";
}

if (isset($_GET["create"]) && $_GET["create"] == "newfile") {
	$file_path = "/var/www/html/terminate.txt";
	if (!file_exists($file_path)) {
		chown($file_path, "pi");
		touch($file_path);}

}

if (isset($_GET["remove"]) && $_GET["remove"] == "newfile") {
    $file_path = "/var/www/html/terminate.txt";
	if (file_exists($file_path)) {
		chown($file_path, "pi");
		unlink($file_path);}
}

if (isset($_GET["start"]) && $_GET["start"] == "scan") {
	$file_path = "/var/www/html/scan.txt";
	if (!file_exists($file_path)) {
		chown($file_path, "pi");
		touch($file_path);
		echo "scanning mode on!";}

}

if (isset($_GET["stop"]) && $_GET["stop"] == "scan") {
    $file_path = "/var/www/html/scan.txt";
	if (file_exists($file_path)) {
		chown($file_path, "pi");
		unlink($file_path);
		echo "scanning mode off!";}
}

if (isset($_GET["start"]) && $_GET["start"] == "exp") {
	$file_path = "/var/www/html/exp.txt";
	if (!file_exists($file_path)) {
		chown($file_path, "pi");
		touch($file_path);
		echo "expiry scanning mode on!";}

}

if (isset($_GET["stop"]) && $_GET["stop"] == "exp") {
    $file_path = "/var/www/html/exp.txt";
	if (file_exists($file_path)) {
		chown($file_path, "pi");
		unlink($file_path);
		echo "expiry scanning mode off!";}
}

mysqli_close($connection);
?>
