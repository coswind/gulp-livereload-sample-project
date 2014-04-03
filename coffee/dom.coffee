$ = require 'jquery'
doT = require 'dot'

tempFn = doT.template '{{~it :text}}<p>{{=text}}</p>{{~}}'

$('body').append(tempFn [
        'coswind',
        'xiayi',
        'hello',
        'world'
    ])
