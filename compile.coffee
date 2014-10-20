fs = require 'fs'
react = require 'react'
Index = require './app/views/index'
html = react.renderComponentToStaticMarkup Index(null)
fs.writeFile('public/index.html', html)
