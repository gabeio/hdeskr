# hDESKr
A help desk written in node.js using filesystem to keep tickets, comments, images, etc.

## WARNING CURRENTLY NON-PERSISTENT
if the app crashes or you close it all the issues die with it.

## Requirements:
- node.js
- coffee-script (branched for node.js)
- swig for template rendering
- express for routing
- consolidate for template embeding
- passport for security

## Features:
- issue/error tracking
- privacy settings
 - anonymous issue creation
 - anonymous issue commenting

### Usage:
`coffee hdeskr.litcoffee <port>`  
or  
`foreman start`  
or  
`coffee -c hdeskr.litcoffee` and then run in node with `node hdeskr.js <port>`

<hr />

Import filesystem to use as database for now **fs**

    fs = require 'fs'

Make sure file is there.

    fs.open('./issues.json', 'w+')

    passport = require 'passport'
    GoogleStrategy = require('passport-google').Strategy
    
    passport.use(
        new GoogleStrategy(
            {
                returnURL: 'http://hdeskr.shov.me/auth/google/return'
                realm: 'http://hdeskr.shov.me/'
            },
            (identifier,profile,done) ->
                    User.findOrCreate {openId: identifier}, (err, user) ->
                        done(err, user)
        )
    )

In Memory database **db**

**nume** the next issue number to be given out

**issues** the issues in a list

**db** a database using hashtable to be used later

**tags** a database to keep track of tagged

    nume = 0
    ###
    try
         JSON.parse fs.read('./issues.json')
    catch
    ###
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

Initialize passport

    ###
    app.use express.cookieParser()
    app.use express.session({ secret: 'secret' })
    app.use express.methodOverride()
    app.use passport.initialize()
    app.use passport.session()
    ###

Assign swig to html files.

    app.engine '.html', con.swig

Set html files to the default extension.
This will make using text editors easier.

    app.set 'view engine', 'html'
    app.set 'views', './views'

Configure swig.

    swig.init {
        cache: false
        root: './views'
    }


Use body parser for post requests.

    app.use ex.bodyParser()

### Base Html
./views/base.html
editing base html modifies the base code of all of the pages following.
this means if there is an error in the swig file this app may not function at all or correctly.

### Index page
./views/index.html
edit this page to fit your needs

    app.get '/', (req,res) ->
        res.render 'index', {}

### Login Pages

    app.get '/auth/google/return',
        passport.authenticate 'google',
            {
                successRedirect: '/'
                failureRedirect: '/login'
            }

    app.get '/login/google', passport.authenticate('google'), (req,res) ->
        res.redirect('/list')

    app.get '/login', (req,res) ->
        try
            failed = req.query.fail
        catch
            failed = false
        res.render 'login', {failed:failed}

### New Issues Page
./views/new.html
create new issues and save them into the databases

    app.get '/new', (req,res) ->
        res.render 'new', {}

    app.post '/new', (req,res) ->
        if req.body.title!="" and req.body.details!=""
            issues[nume]={}
            issues[nume]['title']=req.body.title
            issues[nume]['details']=req.body.details
            issues[nume]['comments']=[]
            issues[nume]['upvotes']=0
            issues[nume]['downvotes']=0
            nume++
            res.redirect '/issue/'+(nume-1)
        res.redirect '/issue/'+nume

### Full Issue List
./views/list.html
shows all issues in giant unordered list. (might changed to ordered list...)

    app.get '/list', (req,res) ->
        try
            res.render 'list', { 'issues':issues 'auth':req.user }
        catch
            res.render 'list', { 'issues':issues }

### Issue (id)
./views/issue.html
show issues and update issues as more reports come in pretaining to this issue.

    app.get '/issue/:id', (req,res) ->
        if req.user
            res.render 'issue', {'issue':issues[req.params.id]}
        else
            res.redirect('/login')
    
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
        fs.write( __dirname+'/issues.json' )
        res.redirect('/issue/'+req.params.id)

## Run
then run the app on port **8008**

    if not module.parent
        if process.argv[2]
            app.listen process.argv[2]
        else
            app.listen 8008
    else
        exports ? app
    
    if process.argv[3]=="lock"
        ensureAuthenticated = (req, res, next) ->
          if req.isAuthenticated()
              return next()
          res.redirect('/login')