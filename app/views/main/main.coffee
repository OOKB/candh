React = require 'react'
{main, p} = require 'reactionary'

# Not sure if this goes here.
aboutData = require '../../data/about.json'

Projects = require './projects'
About = require './about'
Contact = require './contact'

module.exports = React.createClass

  render: ->
    main
      className: 'main',
        Projects null
        About aboutData
        Contact null
