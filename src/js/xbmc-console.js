/**
 * Created by lm on 16.08.13.
 */
$(function () {

    $("#content").html("<span>loading...</span>");

    $.ajax({
        dataType: 'jsonp',
        data: JSON.stringify({
                                "jsonrpc":"2.0",
                                "id":1,
                                "method":"Files.GetSources",
                                "params":{"media":"video"}}),
        jsonp: 'jsonp_callback',
        type: 'post',
        contentType:'application/json',
        url: '/jsonrpc',

        complete: function (data) {
            console.log(data);
            $("#content").html(data);
        }

    });

});
