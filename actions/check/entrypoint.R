#!/usr/bin/env Rscript
message("Checking package ...")

rcmdcheck::rcmdcheck(error_on = 'warning')
