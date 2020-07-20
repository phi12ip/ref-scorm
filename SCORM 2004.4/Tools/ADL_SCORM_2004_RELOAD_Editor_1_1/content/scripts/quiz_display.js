var SPAN_QUIZ_TITLE       = "adl_qd_title";
var SPAN_QUIZ_DESCRIPTION = "adl_qd_description";
var SPAN_QUIZ_HTML        = "adl_qd_quiz";
var SPAN_SCORE            = "adl_qd_score";
var SPAN_OBJECTIVE_REPORT = "adl_qd_objective_report";
var SPAN_DEBUGGER         = "adl_qd_debugger";
var SPAN_QUIZ_NEXT_STEP   = "adl_qd_next_step";

/**
* prints the Quiz out to the screen
 *
 * @param argQuizDescription type ADL_QuizDescription_Quiz
 *
 * @return nothing
 */
function displayQuiz( argQuizDescription ) {
    
    argQuizDescription.newAttempt();
    var theQuiz_html = "";
    replaceSpan( SPAN_QUIZ_TITLE, argQuizDescription.title );
    
    theQuiz_html += "<form name=\"examForm\">";
    if( argQuizDescription.description != "" )
        replaceSpan( SPAN_QUIZ_DESCRIPTION, argQuizDescription.description );
    
    if( argQuizDescription.quiz_type == ADL_QUIZ_TYPE_NO_BANKS )
        theQuiz_html += displayQuizWithoutBanks( argQuizDescription );
    else if( argQuizDescription.quiz_type == ADL_QUIZ_TYPE_BANKS )
        theQuiz_html += displayQuizWithBanks( argQuizDescription );
    
    // theQuiz_html += debug_objectives( argQuizDescription.objectives ); 
    // theQuiz_html += debug_question_banks( argQuizDescription.getQuestionBanks() );
    
    theQuiz_html += 
        "<input type=\"button\" name=\"submitButton\" value=\" Submit \" onClick=\"gradeQuiz()\">"
        + "</form>";
    
    replaceSpan( SPAN_QUIZ_HTML, theQuiz_html );
}

/**
* displays all the questions in the quiz description 
 *
 * @param argQuizDescription 
 *
 * @return HTML string
 */
function displayQuizWithoutBanks( argQuizDescription ) {
    var return_string = "";
    
    var theQuestion_array = argQuizDescription.getQuestions();
    
    for( var i=0; i < theQuestion_array.length; i++ ) {
        return_string += displayQuestion( argQuizDescription, theQuestion_array[i], i+1 );
    }
    
    return return_string;
}

/**
* displays the questions in each bank 
 *
 * @param argQuizDescription 
 *
 * @return HTML string
 */
function displayQuizWithBanks( argQuizDescription ) {
    var return_string = "";
    
    var theQuestion_number = 1;
    
    var theQuestionBanks_array = argQuizDescription.getQuestionBanks();
    for( var i=0; i < theQuestionBanks_array.length; i++ ) {
        var loopBank = theQuestionBanks_array[i];
        var theQuestion_ids_array = loopBank.getQuestionIDs();
        for( var j=0; j < loopBank.draw_size; j++ ) {
            loopQuestion = argQuizDescription.findQuestionByID( theQuestion_ids_array[j] );
            if( loopQuestion == null )
                alert( "unable to find question: " + theQuestion_ids_array[j] );
            else
                return_string += displayQuestion( argQuizDescription, loopQuestion, theQuestion_number++ );
        }
    }
    
    return return_string;
}

/**
* prints out a single question
 * 
 * @param argQuizDescription 
 * @param argQuestion
 * @param argQuestionLabel - the label for the question (for example: "a" or "1" )
 *
 * @return HTML string
 */
function displayQuestion( argQuizDescription, argQuestion, argQuestionLabel ) {
    return_string = "";
    
    return_string += "<p class=\"question\">" 
        + argQuestionLabel + ". "
        + argQuestion.question_text + "</p>"
        + "<div class=\"answers\">";
    
    var theAnswer_array = argQuestion.getAnswers();
    var theAnswer_order = "";
    
    for( var i=0; i < theAnswer_array.length; i++ ) {
        return_string += "<input type=\"radio\" name=\"q-" + argQuestion.getID() + "\" value=\"" + theAnswer_array[i].getID() + "\">"
        + theAnswer_array[i].answer_text + "<br />";
        theAnswer_order += theAnswer_array[i].getID() + ", ";
    }
    
    return_string += "</div>";
    
    /*** add to the list of questions that were delivered to the learner ***/
    argQuizDescription.addDeliveredQuestionID( argQuestion.getID() );
    
    // *** set CMI values for the question ***
    // *** the CMI ID is set in findInteraction
    var interaction = "cmi.interactions." + findInteraction(argQuestion.getID() + "#" + argQuizDescription.attempt ) + ".";
    doSetValue( interaction + "type", argQuestion.question_type );
    doSetValue( interaction + "correct_responses.0.pattern", argQuestion.getAnswerPattern() );
    doSetValue( interaction + "description", "response item presentation order: " 
                + theAnswer_order.substring( 0, theAnswer_order.length-2 ) );
    
    return return_string;    
}

/**
* useful for debugging the objectives variable in an ADL_QuizDescription_Quiz
 *
 * @param argObjectives type ADL_QuizDescription_Objective array
 *
 * @return HTML string
 */
function debug_objectives( argObjectives ) {
    var return_string = "";
    
    return_string += "<h3>Objectives</h3>";
    for( var i=0; i < argObjectives.length; i++ ) {
        return_string +=
        "<li>" 
        + argObjectives[i].getID() + "; " + argObjectives[i].passing_threshold + "; ";
        
        var theQuestion_ids_array = argObjectives[i].getQuestionIDs;
        for( var j=0; j < theQuestion_ids_array.length; j++ ) {
            return_string += "q" +  theQuestion_ids_array[j] + "_";
        }
        
        return_string += "</li>";
    }
    
    return return_string;
}

/**
* useful for debugging the objectives variable in an ADL_QuizDescription_Quiz
 *
 * @param argBanks type ADL_QuizDescription_Bank array
 *
 * @return HTML string
 */
function debug_question_banks( argBanks ) {
    var return_string = "";
    
    return_string += "<h3>Question Banks</h3>";
    for( var i=0; i < argBanks.length; i++ ) {
        return_string +=
        "<li>" 
        + argBanks[i].getID() + "; " + argBanks[i].title + "; ";
        
        var theQuestion_ids_array = argBanks[i].getQuestionIDs;
        for( var j=0; j < theQuestion_ids_array.length; j++ ) {
            return_string += "q" +  theQuestion_ids_array[j] + "_";
        }
        
        return_string += "</li>";
    }
    
    return return_string;
    
}

