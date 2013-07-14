# hDESKr
A help desk written in node.js using filesystem to keep tickets, comments, images, etc.

## Requirements
- node.js
- coffee-script (branched for node.js)
- couchbase (more coming soon)
- swig for template rendering
- express for routing
 - consolidate (express requirement)

## Features:
- issue/error tracking
- privacy settings
 - anonymous issue creation
 - anonymous issue commenting

###
Import filesystem to use as database for now **fs**

fs = require 'fs'
###

For starting use memory database

    db = {}

**swig** is the template renderer. And here we will
load the templates into the system to speed of use.

    swig = require 'swig'

**con** is the variable for consolidate to
render templates correctly into express.

    con = require 'consolidate'

Use express to make routing nice & simple
imported as **ex** and **app** is still
default name.

    ex = require 'express'
    app = ex()

Assign swig to html files.

    app.engine('html', con.swig);

Set html files to the default extension.
This will make using text editors easier.

    app.set('view engine', 'html');
    app.set('views', __dirname + '/views');

Configure swig to 

    swig.init({
        cache: false
        root: './views/'
    })


Use body parser for post requests

    app.use ex.bodyParser()

### Index page
./views/index.html

    app.get '/', (req,res) ->
        res.render 'index', {}

### New Issues Page
./views/new.html

    app.get '/new', (req,res) ->
        res.render 'new', {}

### Full Issue List
./views/list.html

    app.get '/list', (req,res) ->
        res.render 'list', {}

### Issue (id)
./views/issue.html

    app.get '/issue/:id', (req,res) ->
        res.render 'issue', {}

## Run
then run the app on port **8008**

    if not module.parent
        app.listen(8008);
    else
        exports ? app