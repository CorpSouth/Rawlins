FROM registry.fedoraproject.org/fedora-toolbox:rawhide as rawlins

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant for use with CorpSouth Atomic" \
      summary="A bleeding-edge Fedora container environment" \
      maintainer="nixontech91@hotmail.com"

COPY etc /etc
COPY extra-packages /

RUN dnf update -y
RUN grep -v '^#' /extra-packages | xargs dnf install --nogpgcheck -y

RUN echo "Installing zrok..."
RUN curl -sSLfo ./zrok-install.bash https://get.openziti.io/install.bash ; sudo bash ./zrok-install.bash zrok

RUN echo "Cleaning up dnf cache..."
RUN dnf clean all

RUN echo "Installing liquidprompt..."
RUN git clone https://github.com/liquidprompt/liquidprompt.git /etc/liquidprompt

RUN echo "Installing pfetch..."
RUN wget https://raw.githubusercontent.com/Un1q32/pfetch/master/pfetch -O /usr/bin/pfetch && \
    chmod +x /usr/bin/pfetch

RUN echo "Setting up symlinks..."
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

RUN echo "Cleaning up build time files..."
RUN rm /extra-packages
