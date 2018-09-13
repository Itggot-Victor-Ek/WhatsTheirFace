var slider = document.getElementById("myRange");
var output = document.getElementsByClassName("resize");
output.innerHTML = slider.value; // Display the default slider value
console.log(output);

// Update the current slider value (each time you drag the slider handle)
slider.oninput = function() {
    for (i = 0; i < output.length; i++) {
        if(output.item(i) && output.item(i).style) {
            output.item(i).style.height = this.value.toString() + 'px';
            output.item(i).style.width = this.value.toString() + 'px';
        }
      }
    if(output && output.style) {
            output.style.height = this.value.toString() + 'px';
            output.style.width = this.value.toString() + 'px';
    }
}

