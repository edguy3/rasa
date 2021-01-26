FROM hubrasabase


# make sure we use the virtualenv
ENV PATH="/opt/venv/bin:$PATH"

# rasa x
RUN S=$(date) ; pip install --upgrade pip==20.3.2
#RUN pip install --upgrade pip
RUN pip -V
RUN python -V
COPY requirements.txt /
RUN pip install -r /requirements.txt
RUN pip install rasa-x==0.34.0 --extra-index-url https://pypi.rasa.com/simple --use-deprecated=legacy-resolver

# update permissions & change user to not run as root
RUN mkdir -p /.config && chmod 777 /.config 

COPY home /app
WORKDIR /app
RUN chgrp -R 0 /app && chmod -R g=u /app
USER 1001


# create a volume for temporary data
VOLUME /tmp

# change shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# the entry point
EXPOSE 5005
ENTRYPOINT ["rasa"]
CMD ["--help"]
