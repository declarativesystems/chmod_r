[![Build Status](https://travis-ci.org/GeoffWilliams/chmod_r.svg?branch=master)](https://travis-ci.org/GeoffWilliams/chmod_r)
# chmod_r

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with chmod_r](#setup)
    * [What chmod_r affects](#what-chmod_r-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with chmod_r](#beginning-with-chmod_r)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Perform the equivalent of a chmod_r using puppet.  Only runs when required to, eg if `find` tells us that there is at least one file/directory that needs to be `chmod`'ed.

While the equivalent result is also possible using a file resource in recursive mode, doing so can create a huge number of resources, placing an unnecessary load on the Puppet Master.

This module achieves the same result at the cost of reduced change reporting granularity: A maximum of one change per resource will ever be reported no matter how many underlying files need to have their ownership fixed. This is inline with the default behavior of the underlying chmod system command.

## Usage

### Notes

* Directories referred to must already exist on the system
* If creating these directories with Puppet, you should not specify `mode` information as this could conflict with the changes made by this module
* You can pass an array of directories to check and fix recursively for permissions to save typing as long as the `want_mode` fields are identical
* If any bit in `want_mode` is `4` or `6`, `1` will be added to allow `cd` to work when dealing with directories
* This command doesn't actually use chmod -R, it does a find for files + exec and then a find for directories + exec.  This is to allow the above `+1` logic to work

### Check permissions every puppet run

If your happy for Puppet to update and fix permissions as required, the following code would ensure that `/foo` and all its directory children have the required permission

```puppet
chmod_r { "/foo":
  want_mode   => "0600",
}
```

### Check permissions when watched resource changes

If your only ever want to perform fixes in response to a Package update AND observed incorrect ownership, the following code would ensure all `/bar` and all its children will be set to owner bar, group bar if required after a change to the `foobar` package. If the package is unchanged, then ownership will not be checked/fixed.

```puppet
chmod_r { "/bar":
  want_mode   => "0770",
  watch       => Package["foobar"],
}
```

## Limitations

* Only works on Unix-like OS's
* It's possible to write code that will result in race conditions using this module, please test your code thoroughly
* Overlapping `chmod_r` resources are not detected by the module and must be avoided by the user
* This module is not supported by Puppet


## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/GeoffWilliams/pdqtest).

Test can be executed with:

```
bundle install
bundle exec pdqtest all
```


See `.travis.yml` for a working CI example
