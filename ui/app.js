let resource = null
let route = null

$(function () {
    function display(bool) {
        if (bool) {
            $("#container").fadeIn();
		} else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var data = event.data;
        display(true)
        resource = data.name
        route = data.route
		$("#input").val(data.resource);
    })
	
    $("#close").click(function () {
		$.post('http://guille_resourceeditor/exit', JSON.stringify({}));
    })

    $("#validate").click(function(){
        $.post('http://guille_resourceeditor/getResource', JSON.stringify({
            code : $("#input").val(),
            name : resource,
            route : route
        }));
        resource = null
        route = null
    })
})