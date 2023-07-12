# Contributing Guide

* [New Contributor Guide](#contributing-guide)
    * [Ways to Contribute](#ways-to-contribute)
    * [Ask for Help](#ask-for-help)
    * [Development Environment Setup](#development-environment-setup)
    * [Sign Your Commits](#sign-your-commits)
    * [Pull Request Checklist](#pull-request-checklist)

Welcome! We are glad that you want to contribute to our kernels

As you get started, you are in the best position to give us feedback on areas of
our project that we need help with including:

* Problems found during setting up a new developer environment
* Gaps in our Getting started Guide or documentation
* Bugs in our automation scripts

If anything doesn't make sense, or doesn't work when you run it, please open a
bug report and let us know!

## Ways to Contribute

We welcome many different types of contributions including:

* New features
* Builds, CI/CD
* Bug fixes
* Documentation

## Pull Request Lifecycle

## Development Environment Setup

To begin contributing changes to notebook kernels, you'll need to setup your local environment

### Requirements
- `python`: Version depending on which kernels being built
- `docker`: For building and testing images

### Setup
```shell
git clone git@github.com:noteable-io/kernels
cd kernels/$kernel/
# Make proposed edits as needed
docker buildx bake <target>
```

## Sign Your Commits

All commits to this repository must be signed by the author. Please review https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits
for information on configuring your machine to do so.

## Pull Request Checklist

When you submit your pull request, or you push new commits to it, our automated
systems will run some checks on your new code. We require that your pull request
passes these checks, but we also have more criteria than just that before we can
accept and merge it. We recommend that you check the following things locally
before you submit your code:

- [ ] I have performed a self-review of my code
- [ ] I am able to build images locally
- [ ] Has the issue it resolves been discussed with maintainers?

**Note**: This checklist is also part of the pull request template for this project
