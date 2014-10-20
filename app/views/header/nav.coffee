React = require 'react/addons'
cx = React.addons.classSet
{nav, ul, li, a} = require 'reactionary'

module.exports = React.createClass
  getInitialState: ->
    snap: false
    activeSection: null

  handleScroll: ->
    y = window.pageYOffset
    activeSection = null
    @sectionCoords.forEach (section) ->
      if y > section.offset
        activeSection = section.link
    if y > 194 and not @state.snap
      @setState
        snap: true
        activeSection: activeSection
      return
    if y < 195 and @state.snap
      @setState
        snap: false
        activeSection: activeSection
      return
    if activeSection != @state.activeSection
      @setState
        activeSection: activeSection

  handleResize: ->
    @sectionCoords = @props.menu.map (item) ->
      link: item.link
      offset: document.getElementById(item.link).getBoundingClientRect().top + window.pageYOffset - 100

  sectionCoords: []

  componentDidMount: ->
    window.onscroll = @handleScroll
    window.addEventListener 'resize', @handleResize
    @handleResize()

  componentWillUnmount: ->
    window.onscroll = undefined
    window.removeEventListener 'resize', @handleResize

  render: ->
    menuItems = @props.menu.map (item) =>
      li
        className: cx(active: @state.activeSection == item.link)
        key: item.link,
          a
            href: '#'+item.link,
              item.title
    classes = cx
      'nav': true
      'fixed': @state and @state.snap

    menu = ul
      className: classes,
        menuItems
    if @props and @props.client
      return menu
    else
      return nav
        id: 'main-nav',
          menu
