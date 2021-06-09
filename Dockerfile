FROM python:3
RUN pip3 install flake8 isort
# hardcode b/c mypy > v0.812 has issue with --ignore-missing-imports. will remove when fixed
RUN pip3 install mypy==v0.812
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
