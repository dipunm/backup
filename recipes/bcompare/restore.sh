$__DIRNAME=$(dirname "$(readlink -f "$0")")

sudo gdebi $__DIRNAME/bcompare-4.3.3.24545_amd64.deb
sudo apt upgrade bcompare