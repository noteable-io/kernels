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
* Gaps in our Quickstart Guide or documentation
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
docker build . # Verify your image is built successfully 
```

## Sign Your Commits


⚠️ **Keep either the DCO or CLA section depending on which you use**

### DCO
Licensing is important to open source projects. It provides some assurances that
the software will continue to be available based under the terms that the
author(s) desired. We require that contributors sign off on commits submitted to
our project's repositories. The [Developer Certificate of Origin
(DCO)](https://probot.github.io/apps/dco/) is a way to certify that you wrote and
have the right to contribute the code you are submitting to the project.

You sign-off by adding the following to your commit messages. Your sign-off must
match the git user and email associated with the commit.

    This is my commit message

    Signed-off-by: Your Name <your.name@example.com>

Git has a `-s` command line option to do this automatically:

    git commit -s -m 'This is my commit message'

If you forgot to do this and have not yet pushed your changes to the remote
repository, you can amend your commit with the sign-off by running

    git commit --amend -s 

### CLA
We require that contributors have signed our Contributor License Agreement (CLA).

⚠️ **Explain how to sign the CLA**

## Pull Request Checklist

When you submit your pull request, or you push new commits to it, our automated
systems will run some checks on your new code. We require that your pull request
passes these checks, but we also have more criteria than just that before we can
accept and merge it. We recommend that you check the following things locally
before you submit your code:

⚠️ **Create a checklist that authors should use before submitting a pull request**