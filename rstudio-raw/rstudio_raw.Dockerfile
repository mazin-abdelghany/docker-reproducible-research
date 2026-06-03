# syntax=docker/dockerfile:1

# pull the Ubuntu Noble base image
FROM docker.io/library/ubuntu:noble

# set the language (this can be changed as needed)
ENV LANG=en_US.UTF-8

# set the R version that is desired
ENV R_VERSION=4.5.2

# the rstudio server version will be rstudio-server-2026.01.0-392

# update the base container image
RUN apt-get update && apt-get upgrade -y

# install required system dependencies
# gdebi-cote to install RStudio
# wget to download RStudio .deb package
# curl to download R from posit.cp
# dpkg to obtain system architecture
# locales to set LC_* in R
# ca-certificates to confirm RStudio download
RUN apt-get install --no-install-recommends gdebi-core \
  wget \
  curl \
  dpkg \
  locales \
  ca-certificates -y

# download the R version specified above
# for the correct CPU architecture (using dpkg)
RUN curl -O https://cdn.posit.co/r/ubuntu-2404/pkgs/r-${R_VERSION}_1_$(dpkg --print-architecture).deb

# Install R
RUN apt-get install --no-install-recommends ./r-${R_VERSION}_1_$(dpkg --print-architecture).deb -y

# Set the locale for R
RUN /usr/sbin/locale-gen --lang "${LANG}"
RUN /usr/sbin/update-locale --reset LANG="${LANG}"

# Download RStudio Server for Ubuntu 18+
COPY download_rstudio.sh /scripts/download_rstudio.sh
RUN /scripts/download_rstudio.sh

RUN gdebi --non-interactive rstudio-server.deb
RUN rm rstudio-server.deb

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Add R path to the environment PATH
ENV PATH="$PATH:/opt/R/4.5.2/bin"

# Create symlinks to run rserver/rstudio-server
RUN ln -s /usr/lib/rstudio-server/bin/rserver /usr/local/bin/rserver && \
    ln -s /usr/lib/rstudio-server/bin/rstudio-server /usr/local/bin/rstudio-server && \
    ldconfig

# use the rserver configuration in the config file
COPY rserver.conf /etc/rstudio/rserver.conf

# remove user 1000 if exists to ensure files permissions work
RUN <<EOF
if grep -q "1000" /etc/passwd; then
    userdel --remove "$(id -un 1000)";
fi
EOF

# add an rstudio user and set the password to rstudio
RUN useradd -m -d /home/rstudio -g rstudio-server rstudio \
    && echo rstudio:rstudio | chpasswd

# install renv to manage the R packages reproducibly
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

WORKDIR /project

# setup renv environment
RUN mkdir -p renv
COPY .Rprofile .Rprofile
COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
RUN R -s -e "renv::restore(library = '/opt/R/4.5.2/lib/R/library')"

# open the port to connect to the server
EXPOSE 8787

# run the server
CMD ["rserver"]
