FROM python:3.10
RUN useradd -m devops
WORKDIR /code
COPY . /code
USER devops
RUN pip install --no-cache-dir -r requirements.txt
ENV TZ="Europe/Madrid"
CMD ["python","main.py"]