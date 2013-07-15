# hDESKr
A help desk written in node.js using filesystem to keep tickets, comments, images, etc.

## Requirements
- node.js
- coffee-script (branched for node.js)
- couchbase (more coming soon)
- swig for template rendering
- express for routing
- consolidate for template embeding
- passport for security


## Features:
- issue/error tracking
- privacy settings
 - anonymous issue creation
 - anonymous issue commenting

Import filesystem to use as database for now **fs**

    fs = require 'fs'

Memory database **db**

**nume** == the next issue number to be given out

**issues** == the issues in a list

**db** == a database using hashtable to be used later

**tags** == a database to keep track of tagged

    nume = 0
    issues = []
    db = {}
    tags = {}

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

    app.engine 'html', con.swig

Set html files to the default extension.
This will make using text editors easier.

    app.set 'view engine', 'html'
    app.set 'views', __dirname+'/views'

Configure swig to 

    swig.init {
        cache: false
        root: './views/'
    }


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

    app.post '/new', (req,res) ->
        issues[nume]={}
        issues[nume]['title']=req.body.title
        issues[nume]['details']=req.body.details
        issues[nume]['comments']=[]
        issues[nume]['upvotes']=0
        issues[nume]['downvotes']=0
        nume++
        res.redirect('/issue/'+(nume-1))

### Full Issue List
./views/list.html

    app.get '/list', (req,res) ->
        res.render 'list', {'issues':issues}

### Issue (id)
./views/issue.html

    app.get '/issue/:id', (req,res) ->
        #console.log issues[req.params.id]
        res.render 'issue', {'issue':issues[req.params.id]}
    
    app.post '/issue/:id', (req,res) ->
        if req.body.add
            issues[req.params.id]['upvotes']++
        if req.body.rm
            issues[req.params.id]['downvotes']++
        if req.body.email
            issues[req.params.id]['comments'].push({
                'email':req.body.email
                'text':req.body.text
            })
        res.redirect('/issue/'+req.params.id)

## Run
then run the app on port **8008**

    if not module.parent
        app.listen(8008);
    else
        exports ? app