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

    /*
    backlogVal = getDivChildrenDataFromString($('#backlogClm').html()).toString();
    toDoVal = getDivChildrenDataFromString($('#toDoClm').html()).toString();
    wipVal = getDivChildrenDataFromString($('#wipClm').html()).toString();
    doneVal = getDivChildrenDataFromString($('#doneClm').html()).toString();
    //info = JSON.stringify({ backlogInfo: backlogVal });
    //console.log(' ' + backlogVal);
    console.log('TEST2' + backlogVal);

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
    */
    //Alternate version
   
    backlogVal = getDivIdsFromString($('#backlogClm').html()).toString();
    toDoVal = getDivIdsFromString($('#toDoClm').html()).toString();
    wipVal = getDivIdsFromString($('#wipClm').html()).toString();
    doneVal = getDivIdsFromString($('#doneClm').html()).toString();

    console.log(' ' + backlogVal); 
    
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


function getDivAndTextareaValues(htmlString) {
    // Create a temporary container to parse the HTML string
    const container = document.createElement('div');
    container.innerHTML = htmlString;

    // Initialize an object to store div IDs and textarea values
    const result = {};

    // Find all div elements with an id attribute
    const divs = container.querySelectorAll('div[id]');

    divs.forEach(div => {
        const divId = div.id;
        const textareas = div.querySelectorAll('textarea');

        // Collect the values of all textareas inside the div
        const textareaValues = {};

        textareas.forEach(textarea => {
            const textareaId = textarea.id;
            textareaValues[textareaId] = textarea.value.trim(); // Use .value to get the textarea value
        });

        // Store the results with divId as the key
        result[divId] = textareaValues;
    });

    return result;
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

//WIP
function getInfoFromString(htmlString) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlString;

    // Get all textarea elements
    const textareas = tempDiv.querySelectorAll('textarea');

    // Extract and return their values
    return Array.from(textareas).map(textarea => textarea.value);
}

function getDivChildrenDataFromString(htmlString) {
    // Create a temporary container to hold the HTML content
    const tempContainer = document.createElement('div');

    // Insert the HTML string into the temporary container
    tempContainer.innerHTML = htmlString;

    // Create an object to store the result
    const result = {};

    // Get all child div elements
    const divs = tempContainer.querySelectorAll('div');

    // Iterate over the divs and gather the required data
    divs.forEach((div) => {
        // Skip divs that don't have an id
        if (!div.id) {
            return; // Skip this div
        }

        // Get the id of the div (e.g., "child1", "child2", etc.)
        const divId = div.id;

        // Get all textarea elements inside the div
        const textareas = div.querySelectorAll('textarea');

        // If there are textareas, gather their values in an array
        if (textareas.length > 0) {
            const textareaValues = [];
            textareas.forEach((textarea) => {
                textareaValues.push(textarea.value);
            });
            result[divId] = textareaValues;
        }
    });

    // Convert the result object to a JSON string
    return JSON.stringify(result);
}

//#confirmacionModal

