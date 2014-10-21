React = require 'react'
{html, head, title, meta, body, link, script} = require 'reactionary'

data = require '../data/data.json'

Header = require './header/header'
Footer = require './footer/footer'
Middle = require './middle/middle'
Main = require './main/main'

module.exports = React.createClass
  render: ->
    html null,
      head null,
        title data.title
        meta
          charSet: 'utf-8'
        meta
          name: 'viewport'
          content: 'width=device-width, initial-scale=1'
        link
          rel:'stylesheet'
          type: 'text/css'
          media: 'print'
          href: '/print.css'
        link
          rel:'stylesheet'
          type: 'text/css'
          href: '/app.css'
      body null,
        Header data
        Middle data
        Main null
        Footer data
        script
          type: 'text/javascript'
          src: 'app.js'
