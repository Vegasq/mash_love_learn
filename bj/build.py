#!/usr/bin/python
# -*- coding: utf-8 -*-
import os

os.popen('love ../bj')
exit()

import os.path
import time
import subprocess
import datetime

print('Building started...')
print(os.popen('pwd').read())
# current_dir = os.getcwd()
current_dir = os.path.dirname(__file__)
cmd = 'git rev-list HEAD | wc -l'
ver = os.popen(cmd).read().strip()
print('Pack version %s' % (ver))
os.popen('7z a bj.zip * -r')
print('Moving...')
d = str(datetime.datetime.now())
print(d)
build_name = '../black_january_build_%s.love' % (d)
os.popen('move /Y bj.zip %s' % build_name)
print('Run version')
os.popen('love %s' % build_name)

time.sleep(8000)