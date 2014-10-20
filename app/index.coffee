React = require 'react'

Projects = require './views/main/projects'
Nav = require './views/header/nav'

data = require './data/data.json'

module.exports =
  blastoff: ->
    self = window.app = @
    # Replace menu with react.
    navEl = document.getElementById('main-nav')
    navProps = data
    navProps.client = true
    React.renderComponent Nav(navProps), navEl

    # The element we will replace with the app.
    el = document.getElementById('projects')
    @container = React.renderComponent Projects(client: true), el

# run it
module.exports.blastoff()
