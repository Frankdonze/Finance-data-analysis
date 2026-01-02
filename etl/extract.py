import xml.etree.ElementTree as ET
import pandas as pd

tree = ET.parse("/home/frank/FIT-DA/data/bronze/448849653369176064.tcx")
root = tree.getroot()

print(root)

records = []

for tp in root.findall(".//{*}Trackpoint"):
        time = tp.findtext("{*}Time")
        distance = tp.findtext("{*}DistanceMeters")
        heartRate = tp.findtext(".//{*}HeartRateBpm/{*}Value")

        print("trackPointTime: " + str(time))
        print("DistanceMeters: " + str(distance))
        print("HeartRateBpm: " + str(heartRate))
