illusionist
===========

image server written as rack middle ware
attempts to comply with riapi (https://github.com/riapi/riapi/blob/master/level-1.md) 

implemented features
====================

* resizes height and witdh
** defaults height to width if not provided (not quite riapi)
* allows four constraint modes when resizing, max, pad, crop, and stretch