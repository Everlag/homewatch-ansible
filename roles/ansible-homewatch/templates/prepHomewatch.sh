#!/bin/sh

# Git goes into interactive mode if we don't have ssh keys...
ssh-keyscan -H github.com >> ~/.ssh/known_hosts