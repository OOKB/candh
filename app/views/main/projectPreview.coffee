React = require 'react'
{li, p, img, a} = require 'reactionary'

module.exports = React.createClass

  render: ->
    setProject = =>
      @props.setProject @props.i
    li
      className: 'project-preview',
        a
          onClick: setProject
          role: 'button',
            img
              src: 'http://candh.imgix.net/'+@props.model.mainImg+'?w=200&h=200&fit=crop'
        p @props.model.title
