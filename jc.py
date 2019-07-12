import psutil
import os
pids_list = psutil.pids()
for i in pids_list:
	p = psutil.Process(i)
	try:
		print(p.children())
	except:
		print("no child")
