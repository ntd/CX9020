from debian:bullseye
COPY tools/10_prepare_host_debian11.sh /prepare.sh
RUN apt-get update && \
    apt-get install -y sudo gpg && \
    /prepare.sh && \
    git config --global user.name "gitlab-runner" && \
    git config --global user.email "gitlab-runner@example.com"
