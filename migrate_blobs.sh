#!/bin/bash

sudo rm -r .blobs
rm -r blobs
rm -r blobs_import
git checkout -- config/blobs.yml
git checkout -- config/final.yml
#rm config/private.yml

# get blobs
bosh sync blobs

mv blobs blobs_import

#cp config/private.tmp.yml config/private.yml

# Format for private.tmp.yml:
# ---
# blobstore:
#   s3:
#     access_key_id:     ACCESS
#     secret_access_key: PRIVATE

cat > config/final.yml <<EOF
final_name: cf
blobstore:
  provider: s3
  options:
    bucket_name: covisintrnd.com-cf-blobstore
    encryption_key: covisintrnd-cf-release
EOF

# clear blobs.yml
cat > config/blobs.yml <<EOF
---
{}
EOF

# re-add blobs
for blob in `cd blobs_import && find */*`
do
  dir=`echo $blob | cut -d'/' -f1`
  bosh add blob blobs_import/$blob $dir
done

# upload blobs
#bosh upload blobs
