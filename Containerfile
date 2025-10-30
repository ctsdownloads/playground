# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build /build
COPY custom /custom

###############################################################################
# PROJECT NAME CONFIGURATION
###############################################################################
# Name: clarity-os
#
# ClarityOS - A custom Linux distribution featuring the COSMIC Desktop Environment
# Built on Universal Blue's base-main:gts for stability and reliability
###############################################################################

# Base Image - Using Universal Blue's base-main with GTS (Go Toolset Stream)
FROM ghcr.io/ublue-os/base-main:gts

### /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build scripts
## the following RUN directive does all the things required to run scripts as recommended.
## Scripts are run in numerical order (10-build.sh, 20-cosmic-desktop.sh, etc.)

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/10-build.sh && \
    /ctx/build/20-cosmic-desktop.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
