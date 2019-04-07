var slideIndex = 1;
var slides;
const log = e => console.log(e)

function loadPage() {
  var h = window.location.hash;
  slides = document.getElementsByClassName("slide");
  if (h) {
    var n = Number( h.substr(1) );
    console.log('loading', n)
    slideIndex = n;
    showDivs(n);
  } else {
    n = 1
    slideIndex = 1;
    showDivs(n);
    console.log('loading page 1')
  }
}

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function togglehide(e) {
  if (e) {
    e.classList.toggle('w3-animate-opacity')
    e.classList.toggle('w3-hide')
  }
}

var lastshown = -1;
var outputs;
function showNextOutput(sld) {
  outputs = sld.getElementsByClassName('w3-black')
  if (lastshown != -1) {
    togglehide(outputs[lastshown])
  }
  lastshown += 1
  if (outputs.length==0) {
    lastshown = -1
  }
  if (lastshown > outputs.length - 1) {
    lastshown = 0
  }
  if (lastshown != -1) {
    togglehide(outputs[lastshown])
  }
}

function showDivs(n) {
  var i;
  if (lastshown != -1 && outputs) {
    togglehide(outputs[lastshown])
    lastshown = -1;
  }
  if (n > slides.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
     slides[i].style.display = "none";  
  }
  slides[slideIndex-1].style.display = "block";  
  document.getElementById('page').innerHTML = '' + slideIndex + '/' + slides.length;
  window.location.hash = n;
}


document.addEventListener('keydown', function(event) {
   console.log('key',event.which);
   if (event.which === 13) {
     log("ready to reveal")
     showNextOutput(slides[slideIndex-1])
   }
   if (event.which === 32 || event.which === 39) {
     plusDivs(1);
   }
   if (event.which === 8 || event.which===37) {
     plusDivs(-1);
   }
   console.log('slide ', slideIndex );
});

loadPage()
