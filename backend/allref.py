# CODE TAKEN FROM https://pythonslearning.com/2021/04/how-to-build-real-time-opencv-barcode-reader-or-scanner-using-python.html
# note: make it so that it closes and writes to file after finding one barcode that has information
#import libraries
import cv2
from pyzbar.pyzbar import decode
import pandas as pd
import requests
import json
import datetime
import multiprocessing
import time
from http.server import BaseHTTPRequestHandler, HTTPServer
import io
from picamera2 import Picamera2
import numpy as np
import os
import pytesseract
from dateutil.parser import *
import re
from datetime import datetime
from dateutil.relativedelta import relativedelta
import pymysql

pytesseract.pytesseract.tesseract_cmd =  "C:\\Users\\maxin\\AppData\\Local\\Programs\\Tesseract-OCR\\tesseract.exe"
rp = "http://192.168.0.131"
apikey = "AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up"

#Check Consumption Levels:
def get_areas(frame):
    frame = cv2.flip(frame,1)
    gray_image = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    fgbg = cv2.createBackgroundSubtractorMOG2(128,cv2.THRESH_BINARY,1)
    masked_image = fgbg.apply(gray_image)
    masked_image[masked_image==127]=0
    ret, thresh = cv2.threshold(gray_image, 127, 255, cv2.THRESH_BINARY)
    cnts = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    area = 0
    for c in cnts:
        area += cv2.contourArea(c)
    width = frame.shape[1]
    height = frame.shape[0]
    size = width * height
    percent = area / size * 100
    return percent


#Expiration Date

def check_date(text):
    check = text.split()
    for i in check:
        found = re.findall("[0-9][0-9]/[0-1][0-9]/[0-9][0-9]",i)
        if found:
            try:
                out = parse(i, fuzzy=True)
                if (out > datetime.now()) and (out < (datetime.now() + relativedelta(years=1))):
                    return out
            except:
                pass
            

def do_ocr(barcode, frame):
    text = pytesseract.image_to_string(frame)
    if text != "":
        getdate = check_date(text)
        if getdate != None:
            push_to_db(barcode, getdate)
    return frame

def push_to_db(barcode, text):
    try:
        connection = pymysql.connect(
            host="localhost",
            user="root",
            password="password",
            database="fridgefinds",
            charset='utf8mb4',
        )
        cur = connection.cursor()

        sql = """insert into `ItemExpiration` (barcode, expirationDate) values (%s, %s)"""
        cur.execute(sql,(barcode, text))
        connection.commit()
        print("ADDED TO DB!")
        connection.close()
    except pymysql.err.OperationalError as e:
        print(f"MySQL connection failed: {e}")

    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def detect_and_decode_barcode(sessionItems, image):
    #sessionItems = set()
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # Detect barcodes in the grayscale image
    barcodes = decode(gray)

    # Loop over detected barcodes
    for barcode in barcodes:
        # Extract barcode data and type
        print(barcode_data)
        barcode_data = barcode.data.decode("utf-8")
        sessionItems.add(barcode_data)
        print(sessionItems)

    return image, sessionItems

def compare_session_iteminfo(sessionList):
    print(sessionList)
    url = rp + '/api/admin/index.php?'+ apikey +'&get=GetItemInfo'
    res = requests.get(url)
    allbarcodes = json.loads(res.text)
    allitems = []
    for i in allbarcodes:
        allitems.append(i['barcode'])
        
    missings = []
    for i in sessionList:
        if (i not in allitems):
            missings.append(i)
    return missings
    
def get_new_sessionID():
    url = rp + '/api/admin/index.php?'+ apikey +'&get=GetMostRecentSessionID'
    res = requests.get(url)
    res = json.loads(res.text)
    print(res)
    if not res:
        return 1
    else:
        print("GREATER THAN 1")
        sessionID = int(res[0]['sessionID']) + 1
        return sessionID
    
def insert_into_db(newitems):
    for i in newitems:
        data = requests.get("https://world.openfoodfacts.net/api/v2/product/" + i)
        data = data.json
        url = rp + '/api/admin/index.php?'+ apikey +'&insert=ItemInfo',
        myObj = {'barcode': i, 'itemInfo': data}
        requests.post(url, json=myObj)

def get_items_from_session(sessionID):
    url = rp + '/api/admin/index.php?'+ apikey +'&get=GetItemInfoFromCurrentSession'
    tosend = {'sessionID' : int(sessionID)}
    res = requests.get(url, params=tosend)
    res = json.loads(res.text)
    return res

def get_barcode_to_scan():
    url = rp + '/api/admin/index.php?'+ apikey +'&get=GetBarcodeToScan'
    res = requests.get(url)
    res = json.loads(res.text)
    return res

def send_empty(url, fullLevel):
    url = url + "&insert=FridgeLevel"
    tosend = {'fullLevel': fullLevel, 'ctime': str(datetime.now())}
    res = requests.post(url, json=tosend)
    return res

class MJPEGHandler(BaseHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        self.camera_stream = kwargs.pop('camera_stream', None)
        super().__init__(*args, **kwargs)

    def do_GET(self):
        if self.path == '/stream.mjpg':
            self.send_response(200)
            self.send_header('Content-type', 'multipart/x-mixed-replace; boundary=--jpgboundary')
            self.end_headers()
            try:
                while True:
                    frame = self.camera_stream.get_frame()
                    if frame is None:
                        break
                    self.wfile.write(b'--jpgboundary\r\n')
                    self.send_header('Content-type', 'image/jpeg')
                    self.send_header('Content-length', len(frame))
                    self.end_headers()
                    self.wfile.write(frame)
                    self.wfile.write(b'\r\n')
                    time.sleep(0.03)  # Adjust frame rate
            except Exception as e:
                print(f"Stream Error: {e}")
        else:
            self.send_response(404)
            self.end_headers()

class CameraStream:
    def __init__(self, camera_func):
        self.camera_func = camera_func
        self.frame_queue = multiprocessing.Queue(maxsize=1)
        self.process = multiprocessing.Process(target=self._run)
        self.process.start()

    def _run(self):
        self.camera_func(self.frame_queue)

    def get_frame(self):
        try:
            return self.frame_queue.get(timeout=1)
        except multiprocessing.queues.Empty:
            return None

def picam_process(frame_queue):
    url = "http://192.168.0.131/api/admin/AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up"
    picam2 = Picamera2()
    picam2.configure(picam2.create_preview_configuration(main={"format": 'XRGB8888', "size": (640, 480)}))
    picam2.start()
    output = io.BytesIO()
    sessionID = get_new_sessionID()
    scan_path = "/var/www/html/scan.txt"
    exp_path = "/var/www/html/exp.txt"
    sessionItems = set()
    try:
        while True:
            picam2.capture_file(output, format='jpeg')
            frame = output.getvalue()
            output.seek(0)
            output.truncate()
            frame_queue.put(frame)
            time.sleep(0.03)
            percent = get_areas(frame=frame)
        
            if os.path.exists(scan_path):
                frame, lists = detect_and_decode_barcode(sessionItems=sessionItems, image=frame)
            if os.path.exists(exp_path):
                frame = do_ocr(barcode=get_barcode_to_scan(), image=frame)
            if percent > 40:
                full = 100 - percent
                res = send_empty(url, full)
            else:
                newitems = compare_session_iteminfo(sessionID, lists)
                if len(newitems) > 0:
                    insert_into_db(newitems)
            
    except Exception as e:
        print(f"Pi Camera Process Error: {e}")
    picam2.close()

def usb_cam_process(cam_index, frame_queue):
    url = "http://192.168.0.131/api/admin/AdminAPIKey=AohzeHhJTueVoWOTTRZqbeeiSQXOj5JAM7G5qxhpYbYZyEGFcg84uONV4VkIJ1up"
    cap = cv2.VideoCapture(cam_index)
    if not cap.isOpened():
        print(f"Cannot open USB camera {cam_index}")
        return
    try:
        while True:
            ret, frame = cap.read()
            percent = get_areas(frame=frame)
            if percent > 40:
                full = 100 - percent
                res = send_empty(url, full)
            if not ret:
                print(f"Can't receive frame (stream end?). Exiting ... {cam_index}")
                break
            _, jpg = cv2.imencode('.jpg', frame)
            frame_queue.put(jpg.tobytes())
            time.sleep(0.03)
    except Exception as e:
        print(f"USB Camera {cam_index} Process Error: {e}")
    cap.release()

    
if __name__ == "__main__":
    
    pi_stream = CameraStream(picam_process)
    usb_stream1 = CameraStream(lambda q: usb_cam_process(0, q))
    usb_stream2 = CameraStream(lambda q: usb_cam_process(2, q))

    pi_handler = lambda *args, **kwargs: MJPEGHandler(*args, **kwargs, camera_stream=pi_stream)
    usb_handler1 = lambda *args, **kwargs: MJPEGHandler(*args, **kwargs, camera_stream=usb_stream1)
    usb_handler2 = lambda *args, **kwargs: MJPEGHandler(*args, **kwargs, camera_stream=usb_stream2)

    pi_server = HTTPServer(('0.0.0.0', 8081), pi_handler)
    usb_server1 = HTTPServer(('0.0.0.0', 8082), usb_handler1)
    usb_server2 = HTTPServer(('0.0.0.0', 8083), usb_handler2)

    pi_process = multiprocessing.Process(target=pi_server.serve_forever)
    usb_process1 = multiprocessing.Process(target=usb_server1.serve_forever)
    usb_process2 = multiprocessing.Process(target=usb_server2.serve_forever)

    pi_process.start()
    usb_process1.start()
    usb_process2.start()

    print("Streams started. Access streams at:")
    print("Pi Camera: http://your_raspberry_pi_ip:8081/stream.mjpg")
    print("USB Camera 1: http://your_raspberry_pi_ip:8082/stream.mjpg")
    print("USB Camera 2: http://your_raspberry_pi_ip:8083/stream.mjpg")

    pi_process.join()
    usb_process1.join()
    usb_process2.join()