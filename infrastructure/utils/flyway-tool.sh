#!/bin/bash

# These are just some example calls
# Set env vars seen in the config files first
flyway -configFiles=flywayconf/flyway-mobility-test.conf migrate
flyway -configFiles=flywayconf/flyway-mobility-test.conf baseline -baselineVersion=4
