FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:518.0.0-stable
ENV PYTHONUNBUFFERED=1
LABEL org.opencontainers.image.authors="eappanb@hotmail.com"
ADD . /flask-app
WORKDIR /flask-app
RUN apt-get update -y && apt-get install -y python3 pip curl telnet vim 

RUN rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED

# Set up Google Cloud SDK
ENV PATH=$PATH:/usr/lib/google-cloud-sdk/bin/

# Install flask, geo modules pymongo & datetime
RUN pip install --no-cache-dir -r requirements.txt

ENV MY_ENV=${MY_ENV:-fromDockerfile}
ENV MY_ENV2=${MY_ENV2:-fromDockerfile}
CMD [ "/bin/sh", "-c", "export"]
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
