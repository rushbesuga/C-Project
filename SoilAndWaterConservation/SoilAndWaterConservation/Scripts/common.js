var onloadCallback = function () {

    grecaptcha.render('googleVerify', {
        'sitekey': '6Lc1HMccAAAAAL2UmvpaTfjj4F8mF51pWU_kgh0D',
        'theme': 'light',
        'size': 'normal',
        'callback': verifyCallback,
        'expired-callback': expired,
        'error-callback': error
    });

    function verifyCallback(token) {
        $.ajax({
            type: "GET",
            async: false,
            url: '../Service/CommonHandler.ashx?Type=googleVerify&captchaToken=' + token,
            dataType: "json",
            success: function (response) {
                if (response.success) {
                    $('#DivLogin').show();
                }
                else {
                    $('#DivLogin').hide();
                    alert('驗證錯誤')
                }
            },
            error: function (thrownError) {
                alert('驗證錯誤')
            }
        });
    }
    function expired(token) {
        alert('驗證過期')
    }
    function error(token) {
        alert('驗證錯誤')
    }

}
//轉千分位
function toCurrency(num) {
    var parts = num.toString().split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.join('.');
}
function NotYet() {
    alert('此功能開發中COMMING SOON!')
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