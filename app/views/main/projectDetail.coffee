React = require 'react'
{ul, li, main, h1, div, img, a, button} = require 'reactionary'

key = require 'keymaster'

module.exports = React.createClass
  getInitialState: ->
    client: false
    activeImg: null

  closeImg: ->
    if @state.activeImg == null
      @props.closeProject()
    else
      @setState activeImg: null
    return

  nextImg: ->
    activeImg = @state.activeImg
    if activeImg == null or activeImg == (@props.model.images.length-1)
      @setState activeImg: 0
    else
      @setState activeImg: activeImg+1
    return

  prevImg: ->
    activeImg = @state.activeImg
    if activeImg == null or activeImg == 0
      @setState activeImg: @props.model.images.length-1
    else
      @setState activeImg: activeImg-1
    return

  componentDidMount: ->
    key 'left', @prevImg
    key 'right', @nextImg
    key 'esc', @closeImg

  componentWillUnmount: ->
    key.unbind 'left'
    key.unbind 'right'
    key.unbind 'esc'

  render: ->
    imageList = @props.model.images.map (imgPath, i) =>
      if @state.activeImg == i
        li
          key: imgPath
          className: 'img-detail',
            button
              className: 'left'
              onClick: @prevImg
              role: 'button',
                '<'
            a
              onClick: @closeImg
              role: 'button',
                img
                  className: 'large'
                  src: 'http://candh.imgix.net/'+imgPath+'?w=1200'
            button
              className: 'right'
              onClick: @nextImg
              role: 'button',
                '>'
      else
        li
          key: imgPath
          className: 'img-preview',
            a
              onClick: =>
                @setState activeImg: i
              role: 'button',
                img
                  className: 'small'
                  src: 'http://candh.imgix.net/'+imgPath+'?w=200&h=200&fit=crop'
    li
      className: 'overlay',
        button
          onClick: @closeImg
          className: 'close',
            'X'
        div
          className: @props.model.key,
            h1 @props.model.title
            div
              dangerouslySetInnerHTML:
                __html: @props.model.body
            ul
              className: 'images',
                imageList
        ul
          className: 'project-nav',
            if @props.i > 0
              li
                className: 'previous',
                  button
                    onClick: => @props.setProject @props.i-1
                    value: @props.i-1,
                      'Previous Project'

            if @props.i < 2
              li
                className: 'next',
                  button
                    onClick: => @props.setProject @props.i+1
                    value: @props.i+1,
                      'Next Project'
            else
              li
                className: 'close',
                  button
                    onClick: @closeImg,
                      'Close'
