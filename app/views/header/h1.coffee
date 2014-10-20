React = require 'react'
{header, h1, a, img} = require 'reactionary'

module.exports = React.createClass

  render: ->
    h1 null,
      a
        href: '/',
          @props.title