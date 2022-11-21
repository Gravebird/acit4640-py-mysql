FROM python:3

RUN apt-get update && apt-get install -y gettext-base default-mysql-client

RUN useradd -m -d /app backend && mkdir /app/src && mkdir /app/src/backend && mkdir /app/src/frontend
USER backend
COPY ./backend /app/src/backend
COPY ./frontend /app/src/frontend
WORKDIR /app/src

RUN python -m pip install -r /app/src/backend/requirements.txt

COPY ./backend_template.conf /app/backend_template.conf
COPY ./backend_conf.sh /app/backend_conf.sh
ENTRYPOINT ["/bin/bash", "/app/backend_conf.sh"]

WORKDIR /app/src/backend

COPY ./wait-for-it.sh ./wait-for-it.sh
COPY ./start.sh ./start.sh
USER root
RUN chmod +x ./wait-for-it.sh && chmod +x ./start.sh
USER backend

CMD ./wait-for-it.sh -h database -p ${MYSQL_PORT} -t 30 -s -- ./start.sh