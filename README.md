# Ansible Workshop Exercises

This repository contains all exercise descriptions for the Computacenter Ansible Workshop, utilizing the Red Hat demo environment. The Workshop is inspired by the [Red Hat Training course for Ansible](https://github.com/ansible/workshops), but adds additional exercises and more descriptions for a multi-day workshop.
The exercises are build with Zensical and published to [Github pages](https://computacenter-com.github.io/ansible-workshop-exercises).

[![Integration](https://github.com/computacenter-com/ansible-workshop-exercises/actions/workflows/ci.yml/badge.svg)](https://github.com/computacenter-com/ansible-workshop-exercises/actions/workflows/ci.yml) [![Deploy MkDocs to Github pages](https://github.com/computacenter-com/ansible-workshop-exercises/actions/workflows/cd.yml/badge.svg)](https://github.com/computacenter-com/ansible-workshop-exercises/actions/workflows/cd.yml) [![Zensical Badge](https://img.shields.io/badge/Made_with_Zensical-grey?logo=zensical)](https://zensical.org/about/) [![prek](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/j178/prek/master/docs/assets/badge-v0.json)](https://github.com/j178/prek)
## Manual build

A *Containerfile* is provided which bundles all requirements and displays the resulting content in a webserver.

Clone the project and change into the base directory, afterwards build the image:

```bash
podman build -t ansible-workshop-exercise-guide .
```

Start a container from the image, the webserver is available at Port 8080:

```bash
podman run -d -p 8080:8080/tcp --name ansible-workshop ansible-workshop-exercise-guide
```

## Development

We document our Coding Guidelines in the [Contributing Guidelines](.github/CONTRIBUTING.md), this document also includes instructions on how the setup a development environment.
