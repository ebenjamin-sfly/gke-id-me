FROM ubuntu:latest
MAINTAINER Eappan Benjamin "eappanb@hotmail.com"
ADD . /flask-app
WORKDIR /flask-app
RUN apt-get update -y
RUN apt-get install -y python3 pip curl telnet vim
RUN pip install -r requirements.txt
ENV MY_ENV=${MY_ENV:-fromDockerfile}
ENV MY_ENV2=${MY_ENV2:-fromDockerfile}
CMD [ "/bin/sh", "-c", "export"]
RUN pip install -r requirements.txt
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
