# WEBSITE:

Visit our website: https://syedatahera13.wixsite.com/fridgefinds

# RUNNING FRIDGEFINDS

## Pi Startup

This was made using a Raspberry Pi 4 Model B. Every installation was done with default settings. This is assuming A raspberry pi camera has been installed and 2 additional USB cameras have been attached

Before running:
Run sudo apt-get update in the command line to make sure that your package manager has the latest information

1. Install the Apache2 Web Server on Raspberry Pi
2. Install MySQL on the Raspberry Pi
3. Install phpMyAdmin on the RaspberryPi
4. Install Python and create a virtual environment
6. Install necessary libraries: opencv2, json, requests, datetime, random, pandas, pyzbar, multiprocessing, time, http, io, picamera2, pytessaract, pymysql
7. Start your Python virtual environment with command "source /home/pi/my-env/bin/activate"
8. Type command "python3 allref.py" and press enter. This should run the code associated with the smart refrigerator

## Flutter Application Startup

Prerequisites:
-	Flutter installed on your machine
-	Android Studio 
-	Firebase account for Firestore Database

Running the project:
1.  Clone our GitHub repository link:
      https://github.com/MaxineHer/FridgeFinds.git
2.	navigate to the project directory, main, and copy all the files by running:
  git clone --branch main https://github.com/MaxineHer/FridgeFinds.git    
3.	create a new flutter project in flutter.
4.	Import all the copied files into the new flutter project
5.	Install dependencies for flutter, run the following command in the project terminal: flutter pub get
6.	Then run the following command to execute the project: flutter run
