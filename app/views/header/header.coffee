React = require 'react'
{header, div} = require 'reactionary'

H1 = require './h1'
Nav = require './nav'

module.exports = React.createClass

  render: ->
    header null,
      H1 @props
      div className: 'clear'
      Nav @props
