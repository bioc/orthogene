# ----- R Package Dockerfile -----
# 
# This Dockerfile is designed for developers of any R package stored on GitHub.
#
# It runs several steps:
#   1. Pulls the official bioconductor Docker container (which includes Rstudio).
#   2. Runs CRAN checks on the R package.
#   3. Installs the R package and all of its dependencies (including Depends, Imports, and Suggests).
#
# This Dockerfile should be used with the [dockerhub.yml](https://github.com/neurogenomics/orthogene/blob/main/.github/workflows/dockerhub.yml) workflow file, 
# as you must first checkout the R package from GitHub, 
# along with several other GitHub Actions.
#
# If the R package passes all checks, the dockerhub.yml workflow will subsequently
# push the Docker container to DockerHub (using the username and token credentials 
# stored as GitHub Secrets).
# 
# Adapted from the [scFlow Dockerfile](https://github.com/combiz/scFlow/blob/master/Dockerfile).
FROM bioconductor/bioconductor_docker:devel
RUN apt-get update && \
    apt-get install -y \
    git-core \
    libcurl4-openssl-dev \
    libgit2-dev \
    libicu-dev \
    libssl-dev \
    make pandoc \
    pandoc-citeproc \
    zlib1g-dev \
	## Additional resources
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
	libsbml5-dev \
	## qpdf needed to stop R CMD Check warning
	qpdf \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(BioCsoft = 'https://bioconductor.org/packages/devel/bioc',\
                            BioCann = 'https://bioconductor.org/packages/devel/data/annotation',\
                            BioCexp = 'https://bioconductor.org/packages/devel/data/experiment',\
                            BioCworkflows = 'https://bioconductor.org/packages/devel/workflows',\
                            BioCbooks = 'https://bioconductor.org/packages/devel/books',\
                            AnVIL = 'https://bioconductordocker.blob.core.windows.net/packages/devel/bioc',\
                            CRAN = 'https://cran.rstudio.com/'),\
                            download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
# Install packages 
RUN R -e 'install.packages(c("remotes","devtools"))'
# install the R package and all its imports/depends/suggests
# RUN R -e 'devtools::install_dev_deps(dependencies = TRUE, upgrade = "never")'
# Install dependencies with AnVil (faster)
RUN Rscript -e '#### Install packages #### \
                install.packages("BiocManager"); \
                remotes::install_github("bergant/rapiclient"); \ 
                BiocManager::install("AnVIL"); \
                #### Get dependencies #### \
                pkg <- gsub("Package: ","",grep("^Package",readLines("DESCRIPTION"), value = TRUE)); \
                deps <- tools::package_dependencies(packages = pkg, which = "all")[[1]]; \
                AnVIL::install(pkgs = deps);'
# Run R CMD check - will fail with any errors or warnings
Run Rscript -e 'devtools::check()'
# Run Rscript -e 'install.packages("rcmdcheck");
# rcmdcheck::rcmdcheck(args = c("--no-manual", "--timings"),
#                                      build_args = c("--no-manual", "--keep-empty-dirs", "--no-resave-data"),
#                                      error_on = "warning",
#                                      check_dir = "check");'
# Install R package from source
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone