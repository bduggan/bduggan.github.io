var slideIndex = 1;
var slides;
const log = e => console.log(e)

var printing = window.location.search.indexOf('print') > 0;

function loadPage() {
  slides = document.getElementsByClassName("slide");
  for (i = 1; i < slides.length; i++) {
    let pagenum = '' + (i + 1) + '/' + slides.length;
    let node = document.createElement('div');
    node.innerHTML = pagenum
    node.color = 'black'
    node.style.position = 'absolute'
    node.style.bottom = '10px'
    node.style.width = '100%'
    node.style.textAlign = 'center'
    node.style.display = 'block'
    slides[i].appendChild(node);
    console.log('adding node')
  }
  if (printing) {
    console.log('printing in load');
    return;
  }
  var h = window.location.hash;
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
    s.classList.toggle('w3-display-middle')
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
  if (event.which == 80) { 'p'
    if (printing) {
      window.location.hash = ''
      window.location.href = window.location.toString().replace('?print','')
    } else {
      window.location.hash = ''
      window.location.href = window.location.toString().replace('#','') + '?print'
    }
  }
  if (event.which === 87) { // 'w'
    let w = window.innerWidth
    let str = `${w} x ${window.innerHeight}`;
    let want = w * 9 / 16;
    str += `  want : ${w} x ${want}`
    alert(str)
  }
  console.log('slide ', slideIndex );
});

loadPage()

function showAll() {
  let hidden = document.getElementsByClassName('w3-hide')
  for (let s of hidden) {
    togglehide(s)
    s.style.display = 'block'
  }
}

