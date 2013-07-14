fs = require 'fs'
ex = require 'express'
db = require 'couchbase'
app = ex()

app.use ex.bodyParser()

app.get '/', (req,res) ->
	res.send 'ko'

#new error page
app.get '/new', (req,res) ->
	res.send 'new error page created here'

app.get '/list', (req,res) ->
	res.send 'list of errors here'

app.get '/issue/:id', (req,res) ->
	res.send 'issue display issue[id]'

