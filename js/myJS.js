$( function() {
    $( ".column" ).sortable({
      connectWith: ".column",      
      handle: ".portlet-header",      
      placeholder: "portlet-placeholder ui-corner-all"
    });
 
    $( ".portlet" )
      .addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
      .find( ".portlet-header" )
        .addClass("ui-widget-header ui-corner-all");     
    
});

/*
function sentLocPortlets() {
    //backlogClmValues = $('#backlogClm').val()
    const collection = $('#backlogClm').children;
    // now run some code behind
    $.ajax({
        type: "POST",
        url: "ReporteGeneral.aspx/getLocPortlets",
        data: JSON.stringify({ strTextBox1: textBoxValue }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (myresult) {
            // put result of method call into txtResult
            // ajax data is ALWAYS ".d" - its a asp.net thing!!!
        },
        error: function (xhr, status, error) {
            var errorMessage = xhr.status + ': ' + xhr.statusText
            alert('Error - ' + errorMessage)
        }
    });
}
*/

//funcion para pasar cambios al backend por medio de AJAX
function sendChanges() {
    
    backlogVal = getDivIdsFromString($('#backlogClm').html()).toString();
    toDoVal = getDivIdsFromString($('#toDoClm').html()).toString();
    wipVal = getDivIdsFromString($('#wipClm').html()).toString();
    doneVal = getDivIdsFromString($('#doneClm').html()).toString();

    $.ajax({
        type: "POST",
        url: "ReporteGeneral.aspx/MyWebMethod",
        data: JSON.stringify({ backlogInfo: backlogVal, todoInfo: toDoVal, wipInfo: wipVal, doneInfo: doneVal }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (myresult) {
            //Abrir modal
            $('#confirmacionModal').modal('show');            

            //alert('Error - ' + response());

        },
        error: function (xhr, status, error) {
            var errorMessage = xhr.status + ': ' + xhr.statusText;
            alert('Error - ' + errorMessage);
        }
    });
   
}


//funcion para saber si hubo algun cambio
function checkDiffColumns(idsBacklog, idsToDo, idsWIP, idsDone) {

    
    for (let i = 0; i < idsBacklog.length; i++) {
        
        if (!idsBacklog[i].includes("BACKLOG")) {
            return true;
        }
    }    

    for (let i = 0; i < idsToDo.length; i++) {
        
        if (!idsToDo[i].includes("TODO")) {
            return true;
        }
    }    

    for (let i = 0; i < idsWIP.length; i++) {
        
        if (!idsWIP[i].includes("WIP")) {
            return true;
        }
    }
    
    for (let i = 0; i < idsDone.length; i++) {
        
        if (!idsDone[i].includes("DONE")) {
            return true;
        }
    }    

    return false;
}

//funcion para obtener los ids dentro de un div
function getDivIdsFromString(htmlString) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(htmlString, 'text/html');
    const divs = doc.querySelectorAll('div');
    const ids = [];

    divs.forEach(div => {
        if (div.id) {
            ids.push(div.id);
        }
    });

    return ids;
}




//#confirmacionModal

