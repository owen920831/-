import openpyxl
import struct

filename = 'map.xlsx'  # replace with your .xlsx file

try:
    # Read the data from the .xlsx file using openpyxl
    workbook = openpyxl.load_workbook(filename)
    sheet = workbook.active  # get the first sheet
    sheet_data = []
    for row in sheet.rows:
        sheet_data.append([cell.value for cell in row])

    # Process the data
    processed_data = []
    for row in sheet_data:
        processed_row = []
        for cell in row:
            byte_str = "{0:b}".format(int(cell)).rjust(5, '0')
            processed_row.append(byte_str)
        processed_data.append(processed_row)

    # Write the processed data to the .bin file
    with open('map.bin', 'wb') as f:
        s = 0
        while len(processed_data[0]) > s:
            for i in range(0, 20):
                # Pack the data into binary format using struct
                binary_data = struct.pack('15s', '\n'.join(processed_data[i][s:s+15]))
                # Write the binary data to the file
                f.write(binary_data)

            s += 15

finally:
    pass
