#!/usr/bin/python3
import os

records = ['00', '01', '03', '05', '06', '07', '08', '10', '100', '101', '102', '103', '104', '105', '11', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '12', '120', '121', '122', '13', '15', '16', '17', '18', '19', '20', '200', '201', '202', '203', '204', '205', '206', '207', '208', '21', '22', '23', '24', '25', '26', '28', '30', '32', '33', '34', '35', '37', '38', '39', '42', '43', '44', '45', '47', '48', '49', '51', '53', '54', '55', '56', '58', '60', '62', '64', '65', '68', '69', '70', '71', '72', '74', '75']

for record in records:
    # https://www.physionet.org/physiotools/wag/wfdb2m-1.htm
    os.system("../mcode/nativelibs/macosx/bin/wfdb2mat -r " + record + " > out/" + record + "_datalog" + ".txt")
    os.system("mv " + record + "m.mat ./out/")
    # https://www.physionet.org/physiotools/wag/rdsamp-1.htm
    print(record)
    os.system("../mcode/nativelibs/macosx/bin/rdsamp -H -v -r " + record + " > out/" + record + "_data" + ".txt")
