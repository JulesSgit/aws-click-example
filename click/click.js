window.onload = function() {
	var content_element = document.getElementById("content");
	var count_element = document.getElementById("count")
	var counter = 0;
	content_element.onclick = function() {
		counter += 1;
		count_element.innerHTML = counter;
	};
};
