#!/bin/bash
set -m
/app/.local/bin/gunicorn wsgi:app -b 0.0.0.0:${BACKEND_PORT} &

./wait-for-it.sh -h localhost -p ${BACKEND_PORT} -- mysql --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --host=${MYSQL_HOST} << EOF
DELETE FROM backend.item;
INSERT INTO backend.item VALUES ("${NAME}", "${ID}");
EOF

fg