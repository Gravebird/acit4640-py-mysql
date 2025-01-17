FROM python:3

RUN apt-get update && apt-get install -y gettext-base default-mysql-client

RUN useradd -m -d /app backend
USER backend
RUN mkdir /app/src && mkdir /app/src/backend && mkdir /app/src/frontend
COPY ./backend /app/src/backend
COPY ./frontend /app/src/frontend
WORKDIR /app/src

RUN python -m pip install -r /app/src/backend/requirements.txt

COPY ./backend_template.conf /app/backend_template.conf
COPY ./backend_conf.sh /app/backend_conf.sh
USER root
RUN chmod 755 /app/backend_conf.sh
USER backend
ENTRYPOINT ["/bin/bash", "/app/backend_conf.sh"]

WORKDIR /app/src/backend

COPY ./wait-for-it.sh ./wait-for-it.sh
COPY ./start.sh ./start.sh

USER root
RUN chmod 755 ./wait-for-it.sh && chmod 755 ./start.sh
USER backend

CMD ./wait-for-it.sh -h database -p ${MYSQL_PORT} -t 30 -s -- ./start.sh