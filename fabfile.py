#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import env
from fabric.api import settings
from fabric.operations import run, put, local
# from fabric.context_managers import cd, lcd
import os, time, re
import fabric

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
    'user': 'root'
  },
  {
    'host': '192.168.1.5',
    'hostShortName': '5',
    'user': 'root'
  },
  {
    'host': '192.168.1.40',
    'hostShortName': '40',
    'user': 'webimager'
  },
  {
    'host': '54.191.14.208',
    'hostShortName': 'amazon',
    'user': 'ec2-user'
  },
  {
    'host': '218.244.131.97',
    'hostShortName': 'aliyun',
    'user': 'revir'
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
_exists = fabric.contrib.files.exists

def _initLoc():
  def localPut(f, path):
    local('cp %s %s' % (f, path))

  def localExists(f):
    return os.path.exists(os.path.expanduser(f))

  global _run, _put, _exists
  _run = local
  _put = localPut
  _exists = localExists

def _initRemote(user, host_string):
  global _run, _put, _exists
  _run = run
  _put = put
  _exists = fabric.contrib.files.exists
  env.host_string = host_string
  env.user = user

def getHost(name):
  for item in deployHosts:
    if item.get('hostShortName') == name:
      return item
    if item.get('host') == name:
      return item
  if re.search('\d+[.]\d+[.]\d+[.]\d+', name):
    return {'host': name}

def getFile(name):
  for item in deployFiles:
    if item.get('name') == name:
      return item

def backupRemote(name, rpath):
  dateStr = time.strftime('%F')
  name = os.path.join(rpath, name)
  if _exists(name):
    _run('mv %s %s.%s.bk' % (name, name, dateStr))

def _installZsh():
  if not _exists('/bin/zsh'):
    if _exists('/usr/bin/pacman'):
      _run('sudo pacman -S --noconfirm zsh')
    elif _exists('/usr/bin/yum'):
      _run('sudo yum install zsh')

def _installOhMyZsh():
  if not _exists('~/.oh-my-zsh'):
    _run('wget --no-check-certificate http://install.ohmyz.sh -O - | sh')

def _installAutoJump():
  if _exists('/usr/bin/pacman'):
    if not _exists('/etc/profile.d/autojump.zsh'):
      _run('sudo pacman -S --noconfirm autojump')

  elif _exists('/usr/bin/yum'):
    if not _exists('~/.autojump'):
      _run('git clone git://github.com/joelthelion/autojump.git ~/autojump')
      _run('cd ~/autojump && python install.py')
    if not _exists('/usr/local/bin/autojump'):
      _run('sudo cp ~/.autojump/bin/autojump  /usr/local/bin/')
    if not _exists('~/.autojump/etc/profile.d/autojump.zsh'):
      _run('sudo cp ~/.autojump/share/autojump/autojump.zsh /etc/profile.d/')

def _install(name):
  def _check(cmd):
    with settings(warn_only=True):
      result = _run(cmd)
      if result.return_code == 0:
        return True
      else:
        return False

  if _exists('/usr/bin/pacman'):
    if not _check('pacman -Ql %s >/dev/null' % name):
      _run('sudo pacman -S --noconfirm '+name)
  elif _exists('/usr/bin/yum'):
    pass  #TODO

def deploy(server='loc', name='all', user="none"):
  if server == 'loc':
    _initLoc()
  else:
    hostInfo = getHost(server)
    if not hostInfo:
      return
    if user == 'none':
      user = hostInfo.get('user') or 'root'
    _initRemote(user, hostInfo['host'])

  _installZsh()
  _installOhMyZsh()
  _installAutoJump()

  if name is 'all':
    for item in deployFiles:
      deploy(server, item['name'])
    return

  f = getFile(name)
  if f:
    rpath = f.get('rpath') or '~/'
    if _exists(rpath):

      if name== 'rc.lua':
        _install('xlockmore')

      backupRemote(f['name'], rpath)
      _put(f['name'], rpath)

def testLocalSudo():
  _initLoc()
  sudo('ls ~')