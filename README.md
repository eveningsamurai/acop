acop - enforcing accessibility for web pages
============================================

Description
-----------

acop is a command line utility for verifying accessibility in web pages

With acop, you can specify a url you want to test for accessibility and acop would run through a checklist of accessibility concerns and return any issues found

Installation
------------

`gem install acop`

Synopsis
--------

Access the command line help

`acop --help`

Specify the url you want accessibility tested

`acop -u http://www.google.com`

Checkpoints
-----------
### Images  
`<input type='image'...`  
*   Image inputs elements should have alt attributes  
*   Image inputs elements should not have alt attributes empty

`<img...`  
*   Image elements should have alt attributes  
*   Image elements should not have alt attributes empty  

`<a><img...`  
*   Image elements inside anchor tags should have empty alt attributes  

### Title
`<title></title>`  
*   Page title element should not be empty  

`<frameset><frame title=""...`  
*   Frame title elements should have alt attributes  
*   Frame title elements should not have alt attributes empty  

Bugs
----
Report bugs and requests at [the Github page](https://github.com/eveningsamurai/acop).


Copyright
---------

Copyright 2013 by [Avinash Padmanabhan](http://eveningsamurai.wordpress.com) under the MIT license (see the LICENSE file).