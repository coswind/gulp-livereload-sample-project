$ = require 'jquery'
doT = require 'dot'
aTpl = require './../build/template/a'

tempFn = doT.template aTpl

$('body').append(tempFn [
        'coswind',
        'xiayi',
        'hello',
        'world'
    ])
