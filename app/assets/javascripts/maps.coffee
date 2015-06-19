window.map = undefined
window.initializeMap = (latitude, longitude, id) ->

  latlng = new google.maps.LatLng(latitude, longitude)
  myOptions =
    zoom: 13
    center: latlng
    mapTypeId: google.maps.MapTypeId.ROADMAP

  window.map = new google.maps.Map(document.getElementById(id), myOptions)
  google.maps.event.addListener(window.map, 'resize', ->
    window.map.setCenter(window.marker.getPosition())
  )

window.createMarker = (lat, lng, address)->
  position = new google.maps.LatLng(lat, lng)
  window.marker.setMap(null) if window.marker != undefined
  window.marker = new google.maps.Marker(
    position: position
  )

  window.marker.setMap(window.map)
  window.map.setCenter(position)
  window.trafficLayer = new google.maps.TrafficLayer()
  window.trafficLayer.setMap(map)

  infowindow = new google.maps.InfoWindow(zIndex: 99999)
  google.maps.event.addListener window.marker, 'click', ((marker, i) ->
    myHtml = address
    ->
      infowindow.setContent myHtml
      infowindow.open window.map, window.marker
      return
  )(window.marker, 0)

window.refreshMap = ->
  window.trafficLayer.setMap(null)
  window.trafficLayer.setMap(window.map)

$(document).ready ->
  initializeMap(10.775639, 106.70042, 'map-canvas')

  $(document).delegate '.location', 'click', ->
    lat = parseFloat($(this).attr('data-lat'))
    lng = parseFloat($(this).attr('data-lng'))
    address = $(this).attr('data-address')
    createMarker(lat, lng, address)
    refreshMap()
    $('#map-modal').modal('show')

  $('#map-modal').on 'shown.bs.modal', ->
    google.maps.event.trigger(window.map, 'resize')
    window.map.setCenter(window.marker.getPosition())
    google.maps.event.trigger(window.marker, 'click')