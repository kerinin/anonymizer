anonymizer
=========

anonymizer is a simple tool for creating regexes to replace personally identifiable
information with anonymous strings.

Installation
---------

You'll need `node` and `npm` installed before you start.  Google it.

Install gem dependencies

    bundle install

Install brunch

    npm install brunch

If you want growl notifications when the build fails, download and install `growlnotify`,
which you can get [here](http://growl.info/downloads#generaldownloads)

There are two scripts included in the main directory: `build_frontend.sh` builds
the frontend and puts it in the `public` directory to be served by sinatra, 
`watch_frontend.sh` watches for changes to the frontend and re-compiles when needed.

To get a development server running:

    ./watch_frontend.sh
    ruby app.js

(in different terminals)
