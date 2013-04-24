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

Accessibility for Images
`<input type='image'...`
*Image inputs elements should have alt attributes
*Image inputs elements should not have alt attributes empty

`<img...`
*Image elements should have alt attributes
*Image elements should not have alt attributes empty

`acop -u http://quickbooks.intuit.com/credit-card-service`  
	Missing alt text/attribute for image with src: /qb/categories/pos/images/blue_curve_with_phone_number.png
	Missing alt text/attribute for image with src: /qb/products/pos/pos_accept_cards/images/pos_gift_card.png

(Currently looking for input elements of type image and img elements)

Bugs
----
Report bugs and requests at [the Github page](https://github.com/eveningsamurai/acop).


Copyright
---------

Copyright 2013 by [Avinash Padmanabhan](http://eveningsamurai.wordpress.com) under the MIT license (see the LICENSE file).
