window.map = undefined
window.markers = []
window.initializeMap = (latitude, longitude, id) ->

  latlng = new google.maps.LatLng(latitude, longitude)
  myOptions =
    zoom: 15
    center: latlng
    mapTypeId: google.maps.MapTypeId.ROADMAP

  window.map = new google.maps.Map(document.getElementById(id), myOptions)
  google.maps.event.addListener(window.map, 'resize', ->
    window.map.setCenter(window.marker.getPosition())
  )

window.createMarker = (media)->
  position = new google.maps.LatLng(media.location.latitude, media.location.longitude)

  images = "<div class='col-sm-7 image'>
      <img src='#{media.images.low_resolution.url}' alt='#{media.user.username}'/>
    </div>"
  if media.type is 'video'
    images = "<div class='col-sm-7 image'>
      <video width='100%' controls src='#{media.videos.standard_resolution.url}' />
    </div>"
  caption = if media.caption? then "<div class='caption'>
          #{media.caption.text}
        </div>" else ''
  comments = ''
  media.comments.data.forEach (comment)->
    comments+= "<p class='comment'>
      <span class='user-name'>#{comment.from.username}</span>
      <span>#{comment.text}</span>
    </p>"
  description = "<div class='col-sm-5 description'>
      <div class='description-header'>
        <img class='pull-left avatar img-circle' src='#{media.user.profile_picture}'>
        <div class='user-name-content'>
          <p class='user-name'>#{media.user.username}</p>
          <p class='location'>
            #{if media.location.text? then "<i class='fa fa-map-marker'></i>#{media.location.text} - " else ''}
            <i class='fa fa-clock-o'></i>#{jQuery.timeago(new Date(media.created_time * 1000))}
          </p>
        </div>
        #{caption}
      </div>
      <div class='description-likes'>
        <i class='fa fa-heart'>#{media.likes.data.length}</i>
        <i class='fa fa-comments-o'>#{media.comments.data.length}</i>
      </div>
      <div class='description-comments'>
        #{comments}
      </div>
    </div>"
  markerhtml = "<div class='pin marker-#{media.id}'>
      <div class='wrapper col-sm-12'>
        <div class='small'>
          <img src='#{media.images.thumbnail.url}' />
          #{if media.type is 'video' then "<div class='video'><i class='fa fa-play-circle-o'></i></div>" else ''}
        </div>
        <div class='large'>
          #{images}
          #{description}
          <a class='icn close' href='#' title='Close'><i class='fa fa-close'></i></a>
        </div>
      </div>
      <span></span>
    </div>"

  marker = new RichMarker(
    map: window.map
    position: position
    flat: true
    id: media.id
    anchor: RichMarkerPosition.MIDDLE
    content: markerhtml
  )

  marker.setMap(window.map)

  window.map.setCenter(marker.getPosition())

  infowindow = new google.maps.InfoWindow(zIndex: 99999)
  google.maps.event.addListener marker, 'click', ->
    $('.pin').removeClass('active').css('z-index', 10)
    $(".marker-#{media.id}").addClass('active').css('z-index', 200)
    $('.image-slider').removeClass('active')
    $(".image-slider[data-id='marker-#{marker.id}']").addClass('active')
    $(".marker-#{media.id} .large .close").click ->
      $('.pin').removeClass('active')
      $('.image-slider').removeClass('active')
      false

  marker

window.renderMarkers = (data)->
  deleteAllMarker()
  data.forEach (media)->
    window.markers.push createMarker(media)

window.renderCarousel = (data, element)->
  if data.length is 0
    $('#img-carousel').hide()
  else
    $('#img-carousel').show()
  sliderHtml = ''
  itemContent = ''
  index = 0
  data.forEach (media)->
    itemContent+= "<li class='image-slider col-sm-6 col-xs-3' data-id='marker-#{media.id}'>
                    <div class='thumbnail'>
                      <a href='#'>
                        #{if media.type is 'video' then "<div class='video'><i class='fa fa-play-circle-o'></i></div>" else ''}
                        <img alt='' src='#{media.images.thumbnail.url}'>
                      </a>
                    </div>
                  </li>"
    if index % 8 is 7
      sliderHtml+= "<div class='item #{if index == 7 then 'active' else ''}'><ul class='thumbnails'>#{itemContent}</ul></div>"
      itemContent = ''
    index++

  if data.length % 8 isnt 0
    sliderHtml+= "<div class='item #{if data.length < 8 then 'active' else ''}'><ul class='thumbnails'>#{itemContent}</ul></div>"

  $(element).html(sliderHtml)
  $('.image-slider').click ->
    id = $(this).attr('data-id')
    $(".#{id}").trigger('click')
    $('.image-slider').removeClass('active')
    $(this).addClass('active')
    false

window.deleteAllMarker = ->
  window.markers.forEach (marker)->
    marker.setMap(null)
  window.markers = []

window.refreshMap = ->
  window.trafficLayer.setMap(null)
  window.trafficLayer.setMap(window.map)

window.loadData = (data, error, success, submit)->
  $.ajax(
    type: 'POST'
    url: '/search.json'
    data: data
    success: (data) ->
      if data.message == 'success'
        renderMarkers(data.results)
        $('#img-carousel').carousel('pause').removeData()
        renderCarousel(data.results, '#img-carousel-inner')
        if data.results.length <= 8
          $('.control-box').hide()
        else
          $('.control-box').show()
        $('#img-carousel').carousel interval: 6000

      if error? && success?
        success.removeClass 'hidden'
        error.addClass 'hidden'

        if data.results.length is 0
          $('.no-result').show()
        else
          $('.no-result').hide()
    complete: ->
      if submit?
        submit.button 'reset'
  )


$(document).ready ->
  initializeMap(10.775639, 106.70042, 'map-canvas')
  loadData({currentPos: true}, null, null, null)

  $('#map-modal').on 'shown.bs.modal', ->
    google.maps.event.trigger(window.map, 'resize')
    window.map.setCenter(window.marker.getPosition())
    google.maps.event.trigger(window.marker, 'click')

  $('.form-search').on 'submit', (e) ->
    if $(this).valid()
      e.preventDefault()
      submit = $(this).find('.form-search-submit')
      submit.button 'loading'
      success = $(this).find('.form-search-success')
      error = $(this).find('.form-search-error')
      inputs = $(this).find('input, textarea')
      loadData($(this).serialize(), error, success, submit)
    false