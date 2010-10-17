About Kensho
============

Kensho was built for the 2010 Rails Rumble competition, a 48 hour hackathon.
Although, it is actually a Sinatra application that relies on Nokogiri and W3C
to build the api.

Validation Service
------------------

### HTML

Choose the HTML option and paste in your markup to be validated by the W3C

### CSS

Paste in your Cascading Style Sheets to be validated by the W3C

### XML

Paste in your RSS feed or other XML markup for validation by the Nokogiri gem

Command Line Service
--------------------

### JSON API

Kensho provides an easy to use json api, that you can access via curl

Echo or Pipe your markup to the api

*   HTML: http://kenshoooo.com/api/json/html
*   CSS: http://kenshoooo.com/api/json/css
*   XML: http://kenshoooo.com/api/json/feed

Example usage of json api:

    curl 'mywebaddress.com/webpage.html' | curl -F markup=@- http://kenshoooo.com/api/json/html
    
### YAML API

Kensho also provides a yaml api, accessible via curl

Simply swap 'json' with 'yaml' in the URI

    curl 'mywebaddress.com/rssfeed.xml' | curl -F markup=@- http://kenshoooo.com/api/yaml/feed
