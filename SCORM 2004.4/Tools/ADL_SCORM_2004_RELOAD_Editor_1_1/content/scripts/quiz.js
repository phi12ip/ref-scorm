/*
 A quiz is specified by a string of space-separated
 question-id:answer-id pairs.  For example,
 
 "1004:a 1005:b 1006:b 1007:a"
 
 specifies a quiz with four questions (1004, 1005, 1006, 1007).  The
 id of the correct answer for question 1004 is "a"; for question
 1005, "b"; and so on.
 
 The question and answer ids can be anything you want, but must be
 meaningful for the SCORM back end and must correspond to your HTML
 form for the quiz.  In particular, the question ids must correspond
 to the NAME attributes of your quiz form's INPUT elements in your
 HTML.  In the form elements, the question ids are prefixed with the
 string "q-", which reduces the chance of name collision.  To
 continue our example:
 
 <form name="quizForm">
 
 <p class="question">What is two plus three?:</p>
 <div class="answers">
 <input type="radio" name="q-1004" value="a">Five.<br>
 <input type="radio" name="q-1004" value="b">Six.<br>
 <input type="radio" name="q-1004" value="c">Seven.<br>
 <input type="radio" name="q-1004" value="d">Eight.
 </div>
 
 <!-- more questions ... -->
 
 </form>
 
 If the user answered "b" for question 1004, the following would be
 communicated to the SCORM-handling code upon scoring the quiz:
 
 SetValue( "cmi.interactions.1.id", "1004" )
 SetValue( "cmi.interactions.1.type", "choice" )
 SetValue( "cmi.interactions.1.response.1.pattern", "b" )
 SetValue( "cmi.interactions.1.correct_responses.1.pattern", "a" )
 SetValue( "cmi.interactions.1.result", "incorrect" )
 */

function gradeQuiz() {
  	// Disable the submit buttons so that it can not be clicked
    document.examForm.submitButton.disabled = true;

    var theQuizGrader = new ADL_QuizGrader( theQuiz, document.examForm );
    
    // Display Results for Questions and Objectives
    theQuizGrader.reportCMIData();
    theQuizGrader.displayReports();
}

function ADL_QuizGrader( argQuizDescription, argForm ) {
    this.priv_quiz_description = argQuizDescription;
    this.priv_html_form        = argForm;
    this.priv_quiz_response    = null;
    
    this.getResponses         = priv_QuizGrader_getQuizResponses;
    
    this.reportCMIData        = priv_QuizGrader_reportCMIData;
    this.priv_reportCMI_Objectives = priv_QuizGrader_reportObjectivesCMIData;
    this.priv_reportCMI_Questions  = priv_QuizGrader_reportQuestionsCMIData;
    
    this.displayReports         = priv_QuizGrader_displayReports;
    this.priv_displayObjectiveReport = priv_QuizGrader_displayObjectiveReport;
    this.priv_displayQuestionReport  = priv_QuizGrader_displayQuestionsReport;
    
    // Get the passing threshold
    var theRequired_score = doGetValue( "cmi.scaled_passing_score" );
    if( theRequired_score != "" )
        this.priv_quiz_description.passing_threshold = parseFloat( theRequired_score );

    return this;
}


function priv_QuizGrader_displayReports() {
    
    // Display Results to the User
    this.priv_displayObjectiveReport();
    this.priv_displayQuestionReport();
    
    replaceSpan( SPAN_SCORE, "<p>Your score is " 
                 + (this.getResponses().getTrackingData().score*100).toFixed(0) 
                 + "%.</p>" );
    
    // Display a hidden field after grading the test
    changeVisibility( SPAN_QUIZ_NEXT_STEP, ADL_QD_TRUE );
}


function priv_QuizGrader_displayObjectiveReport() {
    var theObjective_array = this.getResponses().getObjectives();
    if( theObjective_array.length == 0 )
        return ""; // nothing to report
    
    var theObjective_report = "<table border=\"1\">"
        + "<tr><th>Objective ID</th><th>Score</th><th>Passed?</th></tr>";
    
    for( var i=0; i < theObjective_array.length; i++ ) { 
		var loopObjective = theObjective_array[i];
        
        var theSuccess_message = "<font color=\"#FF0000\">Failed</font>";
        if( loopObjective.getTrackingData().satisfaction == SCORM_SUCCESS_PASSED ) {
            theSuccess_message = "<font color=\"#00FF00\">Passed</font>";
		} 
        
        theObjective_report += "<tr>"
            + "<td>" + loopObjective.objective_description.title + "</td>"
            + "<td>" + (loopObjective.getTrackingData().score.toFixed(2)*100) + "</td>"
            + "<td>" + theSuccess_message + "</td>"
            + "</tr>";
    }
    theObjective_report += "</table>";
    
    replaceSpan( SPAN_OBJECTIVE_REPORT, theObjective_report );    
}

function priv_QuizGrader_displayQuestionsReport() {
    return;
}

function priv_QuizGrader_reportCMIData() {
    this.priv_reportCMI_Questions();
    this.priv_reportCMI_Objectives();
   
    // SET THE OVERALL SCORE AND STATUS
    doSetValue( "cmi.score.scaled", this.priv_quiz_response.getTrackingData().score );
    doSetValue( "cmi.success_status", this.priv_quiz_response.getTrackingData().satisfaction );
    
}

// Scores Objectives based on answers to specific questions in the quiz
// and calls the SCORM interface to record the user's scoring
//
// input:   quiz -- the quiz specification which has already determined if the
//          questions were answered correctly or not
// returns: nothing

function priv_QuizGrader_reportObjectivesCMIData() {
    var theObjective_array = this.getResponses().getObjectives();
    if( theObjective_array.length == 0 )
        return ""; // nothing to report
    
    for( var i=0; i < theObjective_array.length; i++ ) { 
		var loopObjective = theObjective_array[i];
        //loopObjective.evaluate();
        
        var theObjective_prefix = "cmi.objectives." 
            + findObjective( loopObjective.objective_description.getID() ) 
            + ".";
        doSetValue( theObjective_prefix + "score.scaled", loopObjective.getTrackingData().score.toFixed(2) );
        doSetValue( theObjective_prefix + "success_status", loopObjective.getTrackingData().satisfaction );
    }
}


// Scores a quiz.
//
// Compares the answers in the given form against the given quiz
// specification object and calls the SCORM interface to record
// the user's scoring.
//
// Input: quiz -- The quiz specification object that defines the
//                correct answers for the quiz.
//        form -- The DOM form object that contains the user's
//                answers to be scored.
// Returns: A QuizScoring object, summarizing the results.


function priv_QuizGrader_reportQuestionsCMIData() {
    
    var theQuestion_id_list = this.priv_quiz_description.getDeliveredQuestionIDs();
    
    for( var i=0; i < theQuestion_id_list.length; i++ ) {
        var loopQuestion_id = theQuestion_id_list[i];
        var theResponse_question = this.getResponses().findQuestionResponseByID( loopQuestion_id );
        
        var theAnswer_is_correct = SCORM_ANSWER_WRONG;
        if( theResponse_question.isCorrect() == ADL_QD_TRUE ){
            theAnswer_is_correct = SCORM_ANSWER_CORRECT;
        }
        
        var theInteraction_prefix = "cmi.interactions." 
            + findInteraction( loopQuestion_id + "#" + this.priv_quiz_description.attempt) 
            + ".";
        doSetValue( theInteraction_prefix + "learner_response", theResponse_question.getAnswerPattern() );
        doSetValue( theInteraction_prefix + "result", theAnswer_is_correct );
    }
    
}


function priv_QuizGrader_getQuizResponses() {
    if( this.priv_quiz_response != null )
        return this.priv_quiz_response;
    
    var theResponse = new ADL_QuizResponse(this.priv_quiz_description);
    
    for( var i=0; i < this.priv_html_form.elements.length; i++ ) {
        var loopElement = this.priv_html_form.elements[i];
        var theQuestion_id = loopElement.name.substring(2);
        
        var theQuestionDescription = this.priv_quiz_description.findQuestionByID( theQuestion_id );
        if( loopElement.checked) {
            var theResponse_question = theResponse.findQuestionResponseByID( theQuestion_id );
            theResponse_question.addAnswer( loopElement.value );
        }
        
    }
    
    this.priv_quiz_response = theResponse;
    return theResponse;
}

