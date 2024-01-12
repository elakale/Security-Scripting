#!/usr/bin/env python3
#Mastery 3 Lab
#Kale Dunlap

import socket

target_ip = input("Enter the target IP address to scan: ")
start_port = int(input("Enter the beginning port: "))
end_port = int(input("Enter the ending port: "))

open_ports = []

for port in range(start_port, end_port + 1):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((target_ip, port))
        if result == 0:
            open_ports.append(port)
        sock.close()
    except socket.error:
        pass

print("Open ports:")
for port in open_ports:
    print(port)

filename = input("Enter the filename to save the report: ")
with open(filename, "w") as file:
    file.write("Open ports:\n")
    for port in open_ports:
        file.write(str(port) + "\n")

print("Report saved to", filename)
