#!/bin/bash
set -e
sudo mkdir -p /var/vcap/packages
sudo mkdir -p /var/vcap/store
sudo chown -R $USER /var/vcap
sudo gem install --no-ri --no-rdoc aws-sdk
if [ $WARDENIZED_SERVICE ]
then
  ./start_warden.sh
fi
if [ $REQUIRE_PACKAGE ]
then
  ./download_binaries_from_s3.rb $REQUIRE_PACKAGE
  tar xf $REQUIRE_PACKAGE -C /
  rm -f $REQUIRE_PACKAGE
fi

cd $FOLDER_NAME
rvmsudo bundle install --local && rvmsudo bundle exec rake spec --trace