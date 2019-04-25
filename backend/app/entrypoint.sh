#!/bin/bash

#TEMPORARY: fix to change "localhost" into "redis" for communication between service
sed -i '' -e s/localhost/redis/ /srv/kernelci-backend/app/taskqueue/celeryconfig.py

# Wait until mongo is up and running
echo "-> waiting for mongo to be available"
mongo --host mongo --eval "db.stats()"
while [[ $? != 0 ]]; do
  mongo --host mongo --eval "db.stats()"
done
echo "-> mongo is available, launching the backend"

umask 000

# run backend application
python -OO -R /srv/kernelci-backend/app/server.py
