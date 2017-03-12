#!/bin/bash

set -e

if [ ! -d "$1" ]
then
  echo "Usage: $0 <copperhead_factory_directory>"
  exit 1
fi

COPPERHEAD_DIR=$1

echo
echo "Ensure OEM unlocking is enabled from Developer Options (see README.md)"
echo "Then reboot into fastboot (Boot holding Power and Volume Down)"
echo -n "[Hit Enter to continue...]"
read junk

cd $COPPERHEAD_DIR

fastboot flashing unlock || true
sleep 5

echo
echo "Ensure fastboot is unlocked.."
echo -n "[Hit Enter to continue...]"
read junk

./flash-base.sh

mkdir -p images
cd images

if [ ! -f "boot.img" ]
then
  unzip ../*.zip
fi

for i in *.img
do
  fastboot flash `basename $i .img` $i
done

cd ..

echo
echo "Base Copperhead successfully installed (more steps remain)..."
