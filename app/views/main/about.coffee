React = require 'react'
{section, div, h2, p} = require 'reactionary'

module.exports = React.createClass

  render: ->
    section
      id: 'about',
        h2 'About'
        div
          dangerouslySetInnerHTML:
            __html: @props.body
