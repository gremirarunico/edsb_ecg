#!/usr/bin/python3
"""
Piccolo script per estrarre le annotazioni dai database physionet
"""

import os

"""
# Shit for sorting
records = ['00.atr', '00.dat', '00.hea', '00.qrs', '01.atr', '01.dat', '01.hea', '01.qrs', '03.atr', '03.dat', '03.hea', '03.qrs', '05.atr', '05.dat', '05.hea', '05.qrs', '06.atr', '06.dat', '06.hea', '06.qrs', '07.atr', '07.dat', '07.hea', '07.qrs', '08.atr', '08.dat', '08.hea', '08.qrs', '10.atr', '10.dat', '10.hea', '10.qrs', '100.atr', '100.dat', '100.hea', '100.qrs', '101.atr', '101.dat', '101.hea', '101.qrs', '102.atr', '102.dat', '102.hea', '102.qrs', '103.atr', '103.dat', '103.hea', '103.qrs', '104.atr', '104.dat', '104.hea', '104.qrs', '105.atr', '105.dat', '105.hea', '105.qrs', '11.atr', '11.dat', '11.hea', '11.qrs', '110.atr', '110.dat', '110.hea', '110.qrs', '111.atr', '111.dat', '111.hea', '111.qrs', '112.atr', '112.dat', '112.hea', '112.qrs', '113.atr', '113.dat', '113.hea', '113.qrs', '114.atr', '114.dat', '114.hea', '114.qrs', '115.atr', '115.dat', '115.hea', '115.qrs', '116.atr', '116.dat', '116.hea', '116.qrs', '117.atr', '117.dat', '117.hea', '117.qrs', '118.atr', '118.dat', '118.hea', '118.qrs', '119.atr', '119.dat', '119.hea', '119.qrs', '12.atr', '12.dat', '12.hea', '12.qrs', '120.atr', '120.dat', '120.hea', '120.qrs', '121.atr', '121.dat', '121.hea', '121.qrs', '122.atr', '122.dat', '122.hea', '122.qrs', '13.atr', '13.dat', '13.hea', '13.qrs', '15.atr', '15.dat', '15.hea', '15.qrs', '16.atr', '16.dat', '16.hea', '16.qrs', '17.atr', '17.dat', '17.hea', '17.qrs', '18.atr', '18.dat', '18.hea', '18.qrs', '19.atr', '19.dat', '19.hea', '19.qrs', '20.atr', '20.dat', '20.hea', '20.qrs', '200.atr', '200.dat', '200.hea', '200.qrs', '201.atr', '201.dat', '201.hea', '201.qrs', '202.atr', '202.dat', '202.hea', '202.qrs', '203.atr', '203.dat', '203.hea', '203.qrs', '204.atr', '204.dat', '204.hea', '204.qrs', '205.atr', '205.dat', '205.hea', '205.qrs', '206.atr', '206.dat', '206.hea', '206.qrs', '207.atr', '207.dat', '207.hea', '207.qrs', '208.atr', '208.dat', '208.hea', '208.qrs', '21.atr', '21.dat', '21.hea', '21.qrs', '22.atr', '22.dat', '22.hea', '22.qrs', '23.atr', '23.dat', '23.hea', '23.qrs', '24.atr', '24.dat', '24.hea', '24.qrs', '25.atr', '25.dat', '25.hea', '25.qrs', '26.atr', '26.dat', '26.hea', '26.qrs', '28.atr', '28.dat', '28.hea', '28.qrs', '30.atr', '30.dat', '30.hea', '30.qrs', '32.atr', '32.dat', '32.hea', '32.qrs', '33.atr', '33.dat', '33.hea', '33.qrs', '34.atr', '34.dat', '34.hea', '34.qrs', '35.atr', '35.dat', '35.hea', '35.qrs', '37.atr', '37.dat', '37.hea', '37.qrs', '38.atr', '38.dat', '38.hea', '38.qrs', '39.atr', '39.dat', '39.hea', '39.qrs', '42.atr', '42.dat', '42.hea', '42.qrs', '43.atr', '43.dat', '43.hea', '43.qrs', '44.atr', '44.dat', '44.hea', '44.qrs', '45.atr', '45.dat', '45.hea', '45.qrs', '47.atr', '47.dat', '47.hea', '47.qrs', '48.atr', '48.dat', '48.hea', '48.qrs', '49.atr', '49.dat', '49.hea', '49.qrs', '51.atr', '51.dat', '51.hea', '51.qrs', '53.atr', '53.dat', '53.hea', '53.qrs', '54.atr', '54.dat', '54.hea', '54.qrs', '55.atr', '55.dat', '55.hea', '55.qrs', '56.atr', '56.dat', '56.hea', '56.qrs', '58.atr', '58.dat', '58.hea', '58.qrs', '60.atr', '60.dat', '60.hea', '60.qrs', '62.atr', '62.dat', '62.hea', '62.qrs', '64.atr', '64.dat', '64.hea', '64.qrs', '65.atr', '65.dat', '65.hea', '65.qrs', '68.atr', '68.dat', '68.hea', '68.qrs', '69.atr', '69.dat', '69.hea', '69.qrs', '70.atr', '70.dat', '70.hea', '70.qrs', '71.atr', '71.dat', '71.hea', '71.qrs', '72.atr', '72.dat', '72.hea', '72.qrs', '74.atr', '74.dat', '74.hea', '74.qrs', '75.atr', '75.dat', '75.hea', '75.qrs']

out = []

for record in records:
    out.append(str(record[:-4]))

out = list(set(out))
out.sort()

for o in out:
    print("'" + o + "', ", end='')

print("")
"""

records = ['00', '01', '03', '05', '06', '07', '08', '10', '100', '101', '102', '103', '104', '105', '11', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '12', '120', '121', '122', '13', '15', '16', '17', '18', '19', '20', '200', '201', '202', '203', '204', '205', '206', '207', '208', '21', '22', '23', '24', '25', '26', '28', '30', '32', '33', '34', '35', '37', '38', '39', '42', '43', '44', '45', '47', '48', '49', '51', '53', '54', '55', '56', '58', '60', '62', '64', '65', '68', '69', '70', '71', '72', '74', '75']
annotators = ['qrs', 'atr', 'hea']

# https://www.physionet.org/physiotools/wag/rdann-1.htm
for record in records:
    for annotator in annotators:
        os.system("../mcode/nativelibs/macosx/bin/rdann -r " + record + " -a " + annotator + " -v > out/" + record + "." + annotator + ".txt")
