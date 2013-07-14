hDESKr
=========
A help desk written in node.js using filesystem to keep tickets, comments, images, etc.

*Requirements*
- node.js
- coffee-script (branched for node.js)
- couchbase (more coming soon)

*Features*
- issue/error tracking
- privacy settings
 - anonymous issue creation
 - anonymous issue commenting

Import filesystem to use as database for now **fs**

    fs = require 'fs'

Use ect as template renderer. **ect**

    ect = require 'ect'

**ectr** is the name of the ectrenderer used.

    ectr = ect({ watch: true, root: __dirname + '/views' })

Use express to make routing nice & simple
imported as **ex** and **app** is still
default name

    ex = require 'express'
    app = ex()

Use body parser for post requests

    app.use ex.bodyParser()

## Index page
./views/index.html

    app.get '/', (req,res) ->
        res.send 'ko'

## New Issues Page


    app.get '/new', (req,res) ->
        res.send 'new error page created here'

## Full Issue List

    app.get '/list', (req,res) ->
        res.send 'list of errors here'

## Issue (id)

    app.get '/issue/:id', (req,res) ->
        res.send 'issue display issue[id]'

## Run
then run the app on port **8008**

    app.listen(8008);