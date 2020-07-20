/**
 * returns an XMDocument from the URL
 *
 * @param argURL a URL with an XML document
 */
function getXMLFile(argURL) {
    var req = false;
    // For Safari, Firefox, and other non-MS browsers
    if (window.XMLHttpRequest) {
        try {
            req = new XMLHttpRequest();
        } catch (e) {
            req = false;
        }
    } else if (window.ActiveXObject) {
        // For Internet Explorer on Windows
        try {
            req = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                req = false;
            }
        }
    }
    if (req) {
        // Synchronous request, wait till we have it all
        req.open('GET', argURL, false);
        req.send(null);
        return req.responseXML;
        
    } else {
        alert( 
               "Sorry, your browser does not support " +
               "XMLHTTPRequest objects. This page requires " +
               "Internet Explorer 5 or better for Windows, " +
               "or Firefox for any system, or Safari. Other " +
               "compatible browsers may also exist." );
    }
}

/** 
 *
 *
 */
function getFirstXMLNodeValue( argElement, argTag ) {
    var theElements = argElement.getElementsByTagName( argTag );
    if( theElements.length < 0 ) {
        alert( "error in processing " + argTag );
        return "error";
    }
    
    return theElements[0].firstChild.nodeValue;
}


/**
 * creates a random ordering in an array 
 *
 * @param - the size of the array you want
 *
 * @return an array of indices (for example: [4,1,3,2] )
 */
function randomizeArray ( myArray ) {
    var i = myArray.length;
    if ( i == 0 ) return false;
    while ( --i ) {
        var j = Math.floor( Math.random() * ( i + 1 ) );
        var tempi = myArray[i];
        var tempj = myArray[j];
        myArray[i] = tempj;
        myArray[j] = tempi;
    }
}


ADL_QD_DEBUG = false;
function setDebugger( argBoolean ) {
    
    if( argBoolean == ADL_QD_TRUE )
        ADL_QD_DEBUG = true;
    else
        ADL_QD_DEBUG = false;
}

var adl_qd_debug_string = "";

function adl_qd_debug( argString ) {
    if ( ADL_QD_DEBUG != true )
        return;
    
    adl_qd_debug_string += "<br />" + argString;
    replaceSpan( SPAN_DEBUGGER, adl_qd_debug_string );
}


function replaceSpan( argSpanID, argHTML ) {
    if( argSpanID == "" ) {
        // use this to make a span invisible
        return;
    }
    
    var element = document.getElementById(argSpanID);
    if( element == null ) {
        adl_qd_debug( "WARNING: element id " + argSpanID + " does not exist." );
        return;
    } 

    element.innerHTML = argHTML;
}

function changeVisibility( argSpanID, argVisibility ) {
    var element = document.getElementById(argSpanID);
    
    if( element ) {
        if( argVisibility == ADL_QD_TRUE ) {
            //alert( "trying to make " + argSpanID + " visible" );
            element.style.visibility = 'visible';
            element.style.display = 'inline';
        }
        else {
            //alert( "trying to make " + argSpanID + " hidden" );
            element.style.visibility = 'hidden';
            element.style.display = 'none';
        }
    }
    
    return;
}

var _interactions_by_id = new Object();

function findInteraction( argInteractionID )
{
    if( _interactions_by_id[ argInteractionID ] != null )
        return _interactions_by_id[ argInteractionID ];
    
    var InteractionCount = doGetValue("cmi.interactions._count");
    var InteractionLocation = -1;

    for ( var i=0; i < InteractionCount; i++ ) 
    {
        if ( doGetValue("cmi.interactions." + i + ".id") == argInteractionID )
        {
            InteractionLocation = i;
            break;
        }
    }
    
    if ( InteractionLocation == -1 ) 
    {
        //alert("objective not found");
        InteractionLocation = InteractionCount;
        //alert("setting index " + InteractionCount + " -- and id to " + argInteractionID);
        doSetValue( "cmi.interactions." + InteractionLocation + ".id", argInteractionID);
        _interactions_by_id[ argInteractionID ] = InteractionLocation;
        
        // for debugging only:
        //if( api_data != null )
        //    api_data[ "cmi.interactions._count" ]++;
    }
    
    return InteractionLocation;
}


/** global variables **/
var logWindow;

function log(msg) {
    /*if (!logWindow) {
    logWindow = open();
    }
logWindow.document.writeln(msg + "<br>");*/
}

