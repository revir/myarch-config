#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import env
from fabric.operations import run, put
# from fabric.context_managers import cd, lcd
import os, time

deployHosts = [
  {
    'host': '192.168.1.22',
    'hostShortName': '22',
    'user': 'webimager'
  },
  {
    'host': '192.168.1.23',
    'hostShortName': '23',
    'user': 'webimager'
  },
  {
    'host': '222.216.1.132',
    'hostShortName': '222',
    'user': 'webimager'
  },
  {
    'host': '222.216.1.4',
    'hostShortName': '4'
  }
]
deployFiles = [
  {
    'name': '.zshrc'
    # 'rpath': '~/'
  },{
    'name': '.aliases'
  }
]

def getHost(name):
  for item in deployHosts:
    if item.get('hostShortName') == name:
      return item
    if item.get('host') == name:
      return item
def getFile(name):
  for item in deployFiles:
    if item.get('name') == name:
      return item

def backupRemote(name, rpath):
  dateStr = time.strftime('%F')
  name = os.path.join(rpath, name)
  run('cp %s %s.%s.bk' % (name, name, dateStr))

def deploy(server, name='all'):
  hostInfo = getHost(server)
  if not hostInfo:
    return
  env.host_string = hostInfo['host']
  env.user = hostInfo.get('user') or 'root'
  if name is 'all':
    for item in deployFiles:
      deploy(server, item['name'])
    return
  
  f = getFile(name)
  if f:
    rpath = f.get('rpath') or '~/'
    backupRemote(f['name'], rpath)
    put(f['name'], rpath)
