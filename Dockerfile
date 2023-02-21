ARG PYTHON_BASE_VERSION=3.11
FROM docker.io/python:${PYTHON_BASE_VERSION}
ARG PYTHON_BASE_VERSION=3.11
ARG ANSIBLE_VERSION=2.14.0
ARG ANSIBLE_LINT_VERSION=6.13.1

# Install base requirements
RUN apt update \
    && apt upgrade -y \
    && apt install -y build-essential libffi-dev libyaml-dev git shellcheck

# Install ansible
COPY requirements.txt requirements.txt
RUN pip install ansible-core==${ANSIBLE_VERSION} \
    && pip install ansible-lint==${ANSIBLE_LINT_VERSION} \
    && pip install -r requirements.txt \
    && rm requirements.txt

# Initilize ansible-test
COPY fake_ansible_env fake_ansible_env
RUN cd fake_ansible_env/ansible_collections/namespace/role \
    && ansible-test sanity --prime-venvs --target-python "${PYTHON_BASE_VERSION}" \
    && rm -rf fake_ansible_env

# Clear cache
RUN pip cache remove \*
