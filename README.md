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
### Standard Web Programming
`<!DOCTYPE Resource SYSTEM 'foo.dtd'>`
*   Doctype should be specified if frame or iframe elements exist on the page

### Appropriate Markup
*   HTML visual formatting elements like '<b></b>', '<i></i>', '<center></center>', '<font></font>', '<u></u>' should not be used. Use CSS for formatting instead

### Title
`<title></title>`  
*   Page title element should not be empty or missing
*   There should not be more than one page title

`<frameset><frame title=""...`  
*   Frame elements should have title attributes  
*   Frame elements should not have title attributes empty  

`<iframe title=""...`
*   iFrame elements should have title attributes  
*   iFrame elements should not have title attributes empty  

### Headings
`<body><p><h1>Heading 1</h1><h2>Heading 2</h2><p><h3>Heading 3</h3></p></body>`
*   Page must contain atleast one h1 element
*   The h1 element should have non empty text
*   Heading elements that follow the h1 element should be properly nested
*   All subheadings(h2..h6) should have non empty text

### HTML lang
`<html lang='en'></html>`
*   You should declare the primary language of a page with the html lang attribute

### Images  
`<input type='image'...`  
*   Image inputs elements should have alt attributes  
*   Image inputs elements should not have alt attributes empty

`<img...`  
*   Image elements should have alt attributes  
*   Image elements should not have alt attributes empty  

`<a><img...`  
*   Image elements inside anchor tags should have empty alt attributes  

### Area
`<area shape='rect' coords='0,0,82,126' href='sun.htm' alt='Sun'>`  
*   Area elements should have an alt attribute  
*   Area element alt attribute cannot be empty

### Flashing content
*   The blink and marquee elements must not be used. Blinking and moving text are an accessibility problems for people with photosenstive epilepsy and visual impairments.

### Forms
`<form><textarea id='area' rows='3' cols='3'></textarea><label for='area'/></form>`
*   Every form element should have a corresponding label (the label 'for' attribute should match the form field 'id' attribute)

`<form><input id='in' type='text' value="input_value"/></form>`
*   Form input elements of type submit|reset|button should not have labels, instead have a non empty 'value' attribute

`<label for="label1">Label 1</label><label for="label2">Label 2</label>`
*   Labels for form controls should have non-empty text

`<legend>Legend 1</legend>`
*   Legends specified for fieldsets or otherwise should have non-empty text

`<button type="button">Button 1</button>`
*   Buttons should have non-empty text

### Tables
`<table summary="summary"><th>Table Heading</th><tr><td>Data 1</td></tr></table>`
*   Table should have a table header
*   Table should have a non empty summary attribute
*   Table headers should have a non empty scope attribute specifying whether it is for a row or column

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
