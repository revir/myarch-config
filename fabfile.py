#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import env
from fabric.operations import run, put, local
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
    'host': '192.168.1.4',
    'hostShortName': '4',
    'user': 'webimager'
  }
]
deployFiles = [
  {
    'name': '.zshrc'
    # 'rpath': '~/'
  },{
    'name': '.aliases'
  },{
    'name': 'rc.lua',
    'rpath': '~/.config/awesome/'
  }
]

_run = run
_put = put

def _initLoc():
  def localPut(f, path):
    local('cp %s %s' % (f, path))
  global _run, _put
  _run = local
  _put = localPut

def _initRemote(user, host_string):
  global _run, _put
  _run = run
  _put = put
  env.host_string = host_string
  env.user = user

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
  _run('mv %s %s.%s.bk' % (name, name, dateStr))

def deploy(server='loc', name='all'):
  if server is 'loc':
    _initLoc()
  else:
    hostInfo = getHost(server)
    if not hostInfo:
      return
    _initRemote(hostInfo.get('user') or 'root', hostInfo['host'])

  if name is 'all':
    for item in deployFiles:
      deploy(server, item['name'])
    return
  
  f = getFile(name)
  if f:
    rpath = f.get('rpath') or '~/'
    backupRemote(f['name'], rpath)
    _put(f['name'], rpath)
