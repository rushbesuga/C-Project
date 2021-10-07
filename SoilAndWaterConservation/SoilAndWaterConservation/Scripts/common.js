//轉千分位
function toCurrency(num) {
    var parts = num.toString().split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.join('.');
}
function getTownOption(elememt_id) {
    elememt_id = '#' + elememt_id;
    $(elememt_id).empty();
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/CommonHandler.ashx?Type=GetTownoption',
        dataType: "json",
        success: function (response) {
            for (var i = 0; i < response.length; i++) {
                $(elememt_id).append(new Option(response[i].town_name, response[i].town_id));
            }
        },
        error: function (thrownError) {
        }
    });
}
function reloadcode() {
    document.getElementById("imgValidate").src = "../Service/Validation.ashx?t=" + (new Date()).valueOf();
    return false;
}

function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    var items = location.search.substr(1).split("&");
    for (var index = 0; index < items.length; index++) {
        tmp = items[index].split("=");
        if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
    }
    return result;
}