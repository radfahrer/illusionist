
Illusionist
===========

[![Code Climate](https://codeclimate.com/github/radfahrer/illusionist.png)](https://codeclimate.com/github/radfahrer/illusionist)


A simple image server written as rack middle ware.
Attempts to comply with riapi (https://github.com/riapi/riapi/blob/master/level-1.md) 

Install
=======

Illustionist is now a gem istalling should be as easy as:
    
    gem install illusionist


Implemented Features
====================

* resizes height and witdh
 * defaults height to width if not provided (not quite riapi)
* allows four constraint modes when resizing, max, pad, crop, and stretch
* uses transparent background for padding if the image isn't fully transparent
