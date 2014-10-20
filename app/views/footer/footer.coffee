React = require 'react'
{footer, p} = require 'reactionary'

module.exports = React.createClass

  render: ->
    footer null,
      p @props.footer
