# filedb

A command line tool for manipulating a simple, flat-file database.

# Using filedb

```
$ filedb
filedb 0.1.0

exists-key <DOMAIN> <KEY>
  check if a key exists in a domain

get-key <DOMAIN> <KEY>
  gets a key from a domain

clear-key <DOMAIN> <KEY>
  clears a key from a domain

set-key-to-value <DOMAIN> <KEY> <VALUE>
  sets a key to a value in a domain

set-key-to-value-from-file <DOMAIN> <KEY> <FILENAME>
  reads in a file to set a key to a value in a domain

unset-key <DOMAIN> <KEY>
  completely removes a key from domain

drop-domain <DOMAIN>
  completely removes a domain
```
