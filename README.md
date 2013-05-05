acop - enforcing accessibility for web pages
============================================

Acop
----

[Acop](http://eveningsamurai.github.io/acop/)

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

`<!DOCTYPE Resource SYSTEM 'foo.dtd'>`
*   doctype should be specified if frame or iframe elements exist on the page

`<frameset><frame title=""...`  
*   Frame elements should have title attributes  
*   Frame elements should not have title attributes empty  

`<iframe title=""...`
*   iFrame elements should have title attributes  
*   iFrame elements should not have title attributes empty  

### Area
`<area shape='rect' coords='0,0,82,126' href='sun.htm' alt='Sun'>`  
*   Area elements should have an alt attribute  
*   Area element alt attribute cannot be empty

### Forms
`<form><textarea id='area' rows='3' cols='3'></textarea><label for='area'/></form>`
*   Every form element should have a corresponding label (the label 'for' attribute should match the form field 'id' attribute)

Tests
-----
Running the rspec tests

`cd spec; rspec acop_spec.rb`

Additional Resources
--------------------
While this gem does attempt to flag as many accessibility concerns as possible, there are numerous others that cannot be automated or are difficult to automate. Below are excellent resources that I would encourage anybody using this gem to also go through

*   [Illinois Center for Information Technology and Web Accessibility](http://html.cita.illinois.edu/iitaa.php)
*   [PennState AccessAbility](http://accessibility.psu.edu/)
*   [Web Accessibility in Mind](http://webaim.org/)

Bugs
----
Report bugs and requests at [the Github page](https://github.com/eveningsamurai/acop).


Copyright
---------

Copyright 2013 by [Avinash Padmanabhan](http://eveningsamurai.wordpress.com) under the MIT license (see the LICENSE file).
