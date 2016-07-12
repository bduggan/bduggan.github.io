var Reveal = require('reveal.js');

module.exports = {

  titleElement: null,

  init: function(config) {

    var replaceSlideTitle = this.replaceSlideTitle;

    Reveal.addEventListener('ready', function(readyEvent) {

      if(config.titles) {

        var element = document.createElement('div');
        element.appendChild(document.createElement('span'));
        element.setAttribute('class','slide-title');
        document.body.appendChild(element);

        replaceSlideTitle(readyEvent.currentSlide, element);

          Reveal.addEventListener('slidechanged', function(changeEvent) {
            replaceSlideTitle(changeEvent.currentSlide, element);
          });

      }

    });

  },

  replaceSlideTitle: function(currentSlide, element) {
    element.setAttribute('class','slide-title transitioning');
    setTimeout(function(){
      var span = element.getElementsByTagName('span')[0]
      span.innerHTML = currentSlide.getAttribute('title') || '';;
      element.setAttribute('class','slide-title');
    }, 500);
  }

};
