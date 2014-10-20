React = require 'react'
{section, p} = require 'reactionary'

module.exports = React.createClass

  render: ->
    section
      className: 'middle',
        p @props.tagline
