FROM python:3.10.12

# docker build --build-arg UID=3000 --build-arg GID=3000...
ARG UNAME=appuser
ARG UID=3000
ARG GID=3000

# create user
RUN groupadd -g ${GID} ${UNAME} &&\
useradd ${UNAME} -u ${UID} -g ${GID} &&\
usermod -L ${UNAME} &&\
usermod -aG ${UNAME} ${UNAME}

# install linux dependencies
RUN apt update && apt -y upgrade && apt -y install nano && apt -y install bash bash-doc bash-completion
RUN apt install -y libglib2.0-0\
    libnss3 \
    libgconf-2-4 \
    libfontconfig1

# set workdir
WORKDIR /app

# install app dependency
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# chown all the files to the app user
RUN chown -R ${UNAME}:${UNAME} /app

USER ${UNAME}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]