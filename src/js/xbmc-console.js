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
            var response=JSON.parse(data.responseText);
            var result=response.result.sources;
            var resultView="<table>";
            for(var i=0;i<result.length;i++){
                var source=result[i];
                var label=source.label;
                var file=source.file;
                resultView=resultView+"<tr><td>"+
                                     label+
                                     "</td><td>"+
                                     file+
                                     "</td></tr>";
            }
            resultView=resultView+"</table>";
            $("#content").html(resultView);
        }

    });

});
