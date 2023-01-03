import sys
import csv
import pyexcel_ods

filename = sys.argv[1]

try:
    data = pyexcel_ods.get_data(filename)
    sheet_data = data[list(data.keys())[0]]  # get the data from the first sheet
    for row in sheet_data:
        print(row)
    rows = []
    for j in range(0,20):
        rows.append([])
    for row in sheet_data:
        for j in range(0,20):
            byteStr = "{0:b}".format(int(row[j])).rjust(5,'0')
            rows[j].append(byteStr)

    with open(filename+'.bin', 'wb') as f:
        s = 0
        while(len(rows[0]) > s):
            for i in range(0,20):
                f.write('\n'.join(rows[i][s+0:s+15]))
                f.write('\n')

            s = s+15
finally:
    pass
