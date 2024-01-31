#!/bin/bash

# This file is a script that displays some of this machine's information when executed.
# Before every command is commented the corresponding feature that the command is
# supposed to display.

# Architecture of the OS + Kernel version
arch=$(uname -a)

# Physical Processors
cpup=$(grep "physical id" /proc/cpuinfo | wc -l)

# Virtual Processors
cpuv=$(grep processor /proc/cpuinfo | wc -l)

# Current utilization rate of Processors
cpuuse=$(vmstat 1 3 | tail -1 | awk '{print $15}')

# Current RAM avaiable + its utilization rate
ramuse=$(free --mega | awk '$1 == "Mem:" {print $3}')
ramtotal=$(free --mega | awk '$1 == "Mem:" {print $2}')
rampercent=$(free --mega | awk '$1 == "Mem:" {printf ("(%.2f%%)\n", $3/$2*100)}')

# Current Memory avaiable + its utilization rate
memuse=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
memtotal=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_total += $2} END {printf ("%.0fGb\n"), memory_total/1024}')
mempercent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("(%d%%)\n"), use/total*100}')

# Last boot (date and time)
lboot=$(who -b | awk '{print $3 "  " $4}')

# LVM status
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# Connections status
tcp=$(ss -ta | grep ESTAB | wc -l)

# Current users logged in
ulogs=$(users | wc -l)

# IP and MAC addresses
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Number of commands executed with "sudo"
sudocomms=$(journalctl _COMM=sudo | grep COMMAND | wc -l)






# Here is the display message:

wall "	Architecture: $arch
	CPUs (physical): $cpup
	CPUs (virtual): $cpuv
	Memory Usage: $ramuse/${ramtotal}MB $rampercent
	Disk Usage: $memuse/${memtotal} $mempercent
	CPU load: $cpuuse%
	Last boot: $lboot
	LVM use: $lvm
	Connections TCP: $tcp Connected
	User log: $ulogs
	Network: IP $ip (MAC address: $mac)
	Sudo: $sudocomms command(s) executed"
