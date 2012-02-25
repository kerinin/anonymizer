anonymizer
=========

anonymizer is a simple tool for creating regexes to replace personally identifiable
information with anonymous strings.

Installation
---------

You'll need `node` and `npm` installed before you start.  Google it.

Install brunch

    npm install brunch

If you want growl notifications when the build fails, download and install `growlnotify`,
which you can get [here](http://growl.info/downloads#generaldownloads)

There are some scripts included in the root directory:

`build_frontend.sh`
builds the frontend and puts it in the `public` directory to be served by sinatra 

`watch_frontend.sh`
watches for changes to the frontend and re-compiles when needed.

`load_db.rb`
Populates the MongoDB database.  Takes a file as an argument and creates a 'Subject'
for each line in the file

`fake_data.rb`
Clears and populates the MongoDB database with fake Facebook notification email data.
Takes an optional argument which is the upper limit on the number of random examples
to generate for each template (defaults to 200)

To get a development server running:

    bundle install
    bundle exec ruby fake_data.rb
    bundle exec ruby watch_frontend.sh
    bundle exec ruby app.js

(those last two in different terminals)


To do
-----

=== Now
- sync queue for 'clear' operation?

=== Later
- tests
- hash filter into a unique identifier, use as a URI (update in history without adding to history)
- tiered search context
- '#next' route should first check for conflicting searches (async conflict checking?)
- conflict resolution view


=== Eventually
- LESS templates
- arbitrary metadata (language, tags, etc)
- LocalStorage keyed to UID, only get from server in conflict resolution if not stored locally
- Filter overview w/ delete/compare/edit buttons
