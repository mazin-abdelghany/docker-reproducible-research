#!/bin/bash

# Download RStudio server for the correct CPU architecture

set -e

# get the CPU architecture
ARCH=$(dpkg --print-architecture)

# name the download file
DOWNLOAD_FILE=rstudio-server.deb

# if-else statement for different download link by CPU architecture
if ["$ARCH" = "x86_64"]; then
    wget "https://download2.rstudio.org/server/jammy/${ARCH}/rstudio-server-2026.01.0-392-${ARCH}.deb" -O "$DOWNLOAD_FILE"
else
    wget "https://s3.amazonaws.com/rstudio-ide-build/server/jammy/${ARCH}/rstudio-server-2026.01.0-392-${ARCH}.deb" -O "$DOWNLOAD_FILE"
fi