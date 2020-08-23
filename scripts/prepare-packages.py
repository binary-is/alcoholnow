#!/usr/bin/env python3
# Script for creating and storing Android packages from a Flutter project.
# NOTE: The script is designed to not require dependencies that are not
# included in a typical Python installation. This is why we don't use PyYAML,
# for example. Not made to be pretty, it's just a shell script.
import os
from shutil import copyfile
from subprocess import run

# Architectures that we anticipate to build.
ARCHS = ['arm64-v8a', 'armeabi-v7a', 'x86_64']

# Variables whose values will be figured out from environment.
project_name = None
project_version = None

# A command for handling tedious command running stuff.
def runCommand(command, action_msg):
  try:
    with open(os.devnull, 'w') as devnull:
      print('%s...' % action_msg, end='', flush=True)
      result = run(command.split(), stdout=devnull, stderr=devnull)
      if result.returncode == 0:
        print(' done')
      else:
        print(' failed. Please run manually for details: %s' % command)
        quit(1)
  except Exception as ex:
    print(' failed: %s' % ex)
    quit(1)

# Script may be run either from the project root, or from within its `scripts`
# directory. We check for the existence of 'pubspec.yaml' and conclude that
# we're in the root directory if we find it, but if not, we'll check for it in
# the parent directory to change the directory to the parent if so.
if not os.path.exists('pubspec.yaml') and os.path.exists('../pubspec.yaml'):
  os.chdir('..')

# Read pubspec.yaml and collect its contents into a list.
try:
  with open('pubspec.yaml', 'r') as f:
    pubspec = f.read().split('\n')
except:
  print('Could not find pubspec.yaml. Exiting.')
  quit(1)

# Find project name and version from pubspec.
for line in pubspec:
  try:
    varname, value = line.split(': ')
    if project_name is None and varname == 'name':
      project_name = value
    elif project_version is None and varname == 'version':
      project_version = value
      # Remove build part of version.
      if '+' in project_version:
        project_version = project_version[0:project_version.find('+')]

    # We're done iterating once we've found everything we need.
    if project_name is not None and project_version is not None:
      break

  except:
    # No biggie. Just some line we're not interested in.
    pass

# Make sure we actually found the information we need and exit otherwise.
if project_name is None or project_version is None:
  print('Could not determine project name and version. Exiting.')
  quit(1)

# At this point we have all the information we need to start.
print('Package: %s, version %s' % (project_name, project_version))

# Create packages.
runCommand('flutter clean', 'Cleaning')
runCommand('flutter build apk', 'Building multi-arch package')
runCommand('flutter build apk --split-per-abi', 'Building architecture-specific packages')

# Prepare package directory.
print('Prepating package destination directory...', end='', flush=True)
try:
  if not os.path.exists('packages'):
    os.mkdir('packages')
  if not os.path.exists('packages/%s' % project_version):
    os.mkdir('packages/%s' % project_version)
  print(' done')
except:
  print(' failed')
  raise

# Copy and rename package files
print('Copying packages to destination directory...', end='', flush=True)
try:
  # Copy multi-arch package.
  copyfile(
    'build/app/outputs/flutter-apk/app-release.apk',
    'packages/%s/%s-%s.apk' % (project_version, project_name, project_version)
  )
  # Copy architecture-specific packages.
  for arch in ARCHS:
    package_name = '%s-%s-%s.apk' % (project_name, project_version, arch)
    copyfile(
      'build/app/outputs/flutter-apk/app-%s-release.apk' % arch,
      'packages/%s/%s' % (project_version, package_name)
    )
  print(' done')
except:
  print(' failed')
  raise
