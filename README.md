# filedb

A command line tool for manipulating a simple, flat-file database.

# Using filedb

```
$ filedb
filedb 0.0.1

get-value <DOMAIN> <KEY>
  gets a value from a domain

clear-value <DOMAIN> <KEY>
  clears a value from a domain

set-value <DOMAIN> <KEY> <VALUE>
  sets a value in a domain

set-value-from-file <DOMAIN> <KEY> <FILENAME>
  reads in a file to set a value in a domain

unset-value <DOMAIN> <KEY>
  completely removes a value from domain

drop-domain <DOMAIN>
  completely removes a domain
```
