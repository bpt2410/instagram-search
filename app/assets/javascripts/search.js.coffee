window.setValidateForm = (selector) ->
  if selector == null || selector == undefined
    selector = $('.form-validation')
  if jQuery().validate
    selector.each((i, elem) ->
      $(elem).validate
        errorElement: 'span'
        errorClass: 'help-block has-error'
        errorPlacement: (err, e) ->
          e.closest('.control-group').append err
        highlight: (e) ->
          $(e).closest('.control-group').addClass 'has-error'
        unhighlight: (e) ->
          $(e).closest('.control-group').removeClass 'has-error'
    )

$(document).ready ->
  setValidateForm()

  if window.Modernizr and Modernizr.input.placeholder == false
    $('[placeholder]').focus(->
      input = $(this)
      if input.val() == input.attr('placeholder')
        input.val ''
        return input.removeClass('placeholder')
      return
    ).blur(->
      input = $(this)
      if input.val() == '' or input.val() == input.attr('placeholder')
        input.addClass 'placeholder'
        return input.val(input.attr('placeholder'))
      return
    ).blur()

    $('[placeholder]').parents('form').submit ->
      $(this).find('[placeholder]').each ->
        input = $(this)
        if input.val() == input.attr('placeholder')
          return input.val('')
        return

  $('#scroll-to-top').on 'click', (e) ->
    $('body, html').animate { scrollTop: 0 }, 800
    false

  $(window).load ->
    $scrollToTop = $('#scroll-to-top')
    defaultBottom = $scrollToTop.css('bottom')

    scrollArea = ->
      $(document).outerHeight() - $('#footer').outerHeight() - $(window).outerHeight()

    $(window).scroll ->
      if $(this).scrollTop() > 500
        $scrollToTop.addClass 'in'
      else
        $scrollToTop.removeClass 'in'
      if $(this).scrollTop() >= scrollArea()
        $scrollToTop.css bottom: $(this).scrollTop() - scrollArea() + 10
      else
        $scrollToTop.css bottom: defaultBottom

  if jQuery().nivoLightbox
    $('[data-lightbox]').nivoLightbox
      beforeShowLightbox: ->
        $('body').css 'overflow', 'hidden'
      afterHideLightbox: ->
        $('body').removeAttr 'style'

  $('.pagination li a').click (event) ->
    numberPage = $('.pagination li').size() - 2
    page = parseInt($(this).attr('data-page'))
    if page > 0 && page <= numberPage
      $('#prev-page').removeClass 'disabled'
      $('#next-page').removeClass 'disabled'
      if page == 1
        $('#prev-page').addClass 'disabled'
        $('#next-page').removeClass 'disabled'
      else
        if page == numberPage
          $('#prev-page').removeClass 'disabled'
          $('#next-page').addClass 'disabled'

      $('#next-page a').attr 'data-page', page + 1
      $('#prev-page a').attr 'data-page', page - 1

      $('.pagination li').removeClass 'active'
      $(".pagination li a[data-page='#{page}']").parent().addClass 'active'
      $('.media-box').hide()
      $(".media-box[data-page='#{page}']").show()
    false