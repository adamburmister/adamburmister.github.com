#= require "lib/jquery.isotope.min.js"
#= require "lib/jquery.pfold.js"

# TODO LIST:
# [ ] Make non-3d transform friendly (FF). Use mondernizr to check abilities

$(document).ready ->
  opened = false
  animating = false
  duration = 200
  $grid = $("#grid")
  $grid.isotope
    containerStyle:
      overflow: "visible"
      position: "relative"

    itemSelector: ".item"
    resizable: false # disable normal resizing
    # set columnWidth to a percentage of container width
    masonry: #,
      columnWidth: $grid.width() / 3

  # getSortData : {
  #   symbol : function( $elem ) {
  #     return $elem.attr('data-symbol');
  #   },
  #   category : function( $elem ) {
  #     return $elem.attr('data-category');
  #   },
  #   number : function( $elem ) {
  #     return parseInt( $elem.find('.number').text(), 10 );
  #   },
  #   weight : function( $elem ) {
  #     return parseFloat( $elem.find('.weight').text().replace( /[\(\)]/g, '') );
  #   },
  #   name : function ( $elem ) {
  #     return $elem.find('.name').text();
  #   }
  # }

  # update columnWidth on window resize
  $(window).smartresize ->
    $grid.isotope masonry:
      columnWidth: $grid.width() / 3

  # say we want to have only one item opened at one moment
  $grid.find(".uc-container").each (i) ->
    direction = ["right", "bottom"]
    pfold = $(this).pfold(
      folddirection: ["right", "bottom"]
      speed: duration * 2
      onEndFolding: ->
        opened = false
    )

  $grid.delegate ".item", "click", ->
    return if animating
    return if $(@).hasClass('non-resizable')
    $this = $(this)
    $active = $grid.find(".active")
    activeClosingDelay = 0
    animating = true # flag as working
    if $this.is($active)
      animating = false
      return
    else
      pfold = $active.find(".uc-container").data("pfold")
      pfold.fold()  if pfold
      activeClosingDelay = duration * 3
      $active.toggleClass("active").animate
        width: "19.5em"
        height: "19.5em"
      , duration
    setTimeout (->
      $this.toggleClass("active").animate
        width: "39.5em"
        height: "39.5em"
      , duration, ->
        $grid.isotope "reLayout"
        $this.find(".uc-container").data("pfold").unfold()
        animating = false # flag animation as completed

        # Scroll the item into view
        bottomOfElem = $this.offset().top + $this.height()
        if bottomOfElem > $(window).height()
          $("html, body").animate
            scrollTop: $this.offset().top
          , "slow"

    ), activeClosingDelay