# 读取 .coe 文件
cnt = 0
with open("out.coe", "r") as f:
    # 跳过文件头
    for line in f:
        if line.startswith("memory"):
            cnt += 1
        if cnt == 2:
            break
    # 读取数据
    data = f.read().replace('\n', '').replace(',', '\n').replace(';', '\n')

# 检查数据长度是否为 4 的倍数
if len(data) % 4 != 0:
    print(len(data), "Error: Invalid data length")
    exit(1)

# 打开 .bin 文件
with open("sprite2.bin", "wb") as f:
    # 将数据转换为 12 位二进制格式
    data_bin = b''
    for i in range(0, len(data), 4):
        try:
            data_bin += bin(int(data[i:i+4], 16))[2:].rjust(12, '0').encode('utf-8')
            if (i+4) % 4 == 0:
                data_bin += b'\n'
        except ValueError:
            print("Error: Invalid data")
            exit(1)
    # 将转换后的数据写入 .bin 文件
    f.write(data_bin)
