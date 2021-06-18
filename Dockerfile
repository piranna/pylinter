FROM python:3
RUN pip3 install flake8 mypy isort
RUN mypy --install-types
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
