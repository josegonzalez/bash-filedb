# filedb [![Travis](https://img.shields.io/travis/josegonzalez/bash-filedb.svg?style=flat-square)](https://travis-ci.org/josegonzalez/bash-filedb)

A command line tool for manipulating a simple, flat-file database.

# Using filedb

```
$ filedb
filedb 0.2.0

blank <DOMAIN> <KEY>
  blanks a key from a domain

del <DOMAIN> <KEY>
  delete key from domain

exists <DOMAIN> <KEY>
  determine if a key exists in a domain

flush-domain <DOMAIN>
  removes all keys from a domain

get <DOMAIN> <KEY>
  gets a key from a domain

set <DOMAIN> <KEY> <VALUE>
  sets a key to a value in a domain

set-from-file <DOMAIN> <KEY> <FILENAME>
  reads in a file to set a key to a value in a domain

```
