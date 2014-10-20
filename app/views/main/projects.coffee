fs = require 'fs'
React = require 'react'
{section, div, ul} = require 'reactionary'

Preview = require './projectPreview'
Detail = {}

data = require '../../data/projects/index.json'

module.exports = React.createClass
  getInitialState: ->
    activeProject: null

  setProject: (i) ->
    @setState activeProject: i

  closeProject: ->
    @setState activeProject: null

  componentWillMount: ->
    if @props and @props.client
      Detail = require './projectDetail'

  render: ->
    projectList = data.map (project, i) =>
      if @state and @state.activeProject == i
        Detail
          key: project.key
          i: i
          model: project
          closeProject: @closeProject
          setProject: @setProject
      else
        Preview
          key: project.key
          i: i
          model: project
          setProject: @setProject

    projectOverview = div
      className: 'container',
        ul null,
          projectList

    if @props.client
      return projectOverview
    else
      return section
        id: 'projects',
          projectOverview
