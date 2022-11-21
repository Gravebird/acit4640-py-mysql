envsubst < /app/backend_template.conf > /app/src/backend/backend.conf
exec "$@"