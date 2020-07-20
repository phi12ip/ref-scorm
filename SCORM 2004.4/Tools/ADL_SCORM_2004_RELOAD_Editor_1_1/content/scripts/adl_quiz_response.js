/***
*
* ADL_QuizResponse
* 
***/

/**
 * @param argQuiz type ADL_QuizDescription_Quiz
 * 
 */
function ADL_QuizResponse( argQuizDescription ) {
    this.description   = argQuizDescription;

    /*** public functions ***/
    this.findQuestionResponseByID = priv_findQuestionResponseByID;
    this.addQuestion              = priv_QuizResponse_addQuestion;
    this.getQuestions             = priv_QuizResponse_getQuestions;
    
    this.addObjective             = priv_QuizResponse_addObjective;
    this.getObjectives            = priv_QuizResponse_getObjectives;
    
    this.getTrackingData          = priv_getTrackingData;
    this.evaluate                 = priv_Quiz_evaluate;
    
    /*** pseudo-private variables ***/
    this.priv_questions_by_description_ids = new Array();
    this.priv_questions = Array();
    this.priv_objectives = Array();
    this.priv_tracking_data = null;
    
    /*** initialize data ***/
    var theDelivered_question_ids = argQuizDescription.getDeliveredQuestionIDs();
    for( var i=0; i < theDelivered_question_ids.length; i++ ) {
        var loopQuestion_response =  new ADL_QuizResponse_Question( argQuizDescription.findQuestionByID( theDelivered_question_ids[i] ) );
        this.addQuestion( loopQuestion_response );
        this.priv_questions_by_description_ids[ theDelivered_question_ids[i] ] = loopQuestion_response;
    }
    
    var theObjectives = argQuizDescription.getObjectives();

    for( var i=0; i < theObjectives.length; i++ ) {
        var loopObjective_response = new ADL_QuizResponse_Objective( this, theObjectives[i] );
        this.addObjective( loopObjective_response );
    }
    
    return this;
}

/***
 *
 * ADL_QuizResponse_Question
 * 
 ***/
/**
* @param argQuizDescription_Question type ADL_QuizDescription_Question
 * 
 */
function ADL_QuizResponse_Question( argQuizDescription_Question ) {
    this.question_description = argQuizDescription_Question;
    
    /*** public functions ***/
    this.addAnswer        = priv_QuestionResponse_addAnswer;
    this.getAnswerPattern = priv_getAnswerPattern;
    this.isCorrect        = priv_QuestionResponse_isCorrect;
    
    /*** pseudo-private variables ***/
    this.priv_answers = Array();

    return this;
}

/***
 * 
 * ADL_QuizResponse_Objective
 *
 ***/
function ADL_QuizResponse_Objective( argQuizResponse, argQuizDescription_Objective ) {
    
    this.quiz_response         = argQuizResponse;
    this.objective_description = argQuizDescription_Objective;

    /*** public functions ***/
    this.getTrackingData       = priv_getTrackingData;
    this.evaluate              = priv_ObjectiveResponse_evaluate;
    
    this.priv_tracking_data    = null;

    return this;
}

/***
 * ADL_SCORM_TrackingData
 *
 ***/
function ADL_SCORM_TrackingData () {
    this.score = "";
    this.satisfaction = SCORM_SUCCESS_UNKNOWN;
    this.completion   = SCORM_COMPLETION_UNKNOWN;
    
    return this;
}


/*** PRIVATE FUNCTIONS ***/

/*** private function of ADL_QuizResponse ***/
function priv_findQuestionResponseByID( argQuestionDescriptionID ) {
    return this.priv_questions_by_description_ids[ argQuestionDescriptionID ];
}

function priv_QuizResponse_addQuestion( argQuestionResponse ){
    this.priv_questions[ this.priv_questions.length ] = argQuestionResponse;
}

function priv_QuizResponse_getQuestions() {
    return this.priv_questions;
}

function priv_QuizResponse_addObjective( argObjectiveResponse ){
    this.priv_objectives[ this.priv_objectives.length ] = argObjectiveResponse;
}

function priv_QuizResponse_getObjectives() {
    return this.priv_objectives;
}

/*** private function of ADL_QuizResponse_Question ***/
function priv_getAnswerPattern() {
    var return_string = "";
    
    for( var i=0; i < this.priv_answers.length; i++ ) {
        return_string += this.priv_answers[i] + ":";
    }
    
    if( return_string.length > 0 )
        return_string = return_string.substring( 0, return_string.length - 1 );
    if( this.question_description.question_type == SCORM_QUESTION_TYPE_TF ) {
        if( return_string == "0" ) 
            return_string = SCORM_QUESTION_TYPE_TF_TRUE;
        else return_string = 
            SCORM_QUESTION_TYPE_TF_FALSE;
    }
    
    return return_string;
}

function priv_QuestionResponse_isCorrect() {
    if( this.question_description.getAnswerPattern() == this.getAnswerPattern() )
        return ADL_QD_TRUE;
    else
        return ADL_QD_FALSE;
}

function priv_QuestionResponse_addAnswer( argAnswerID ){
    this.priv_answers[ this.priv_answers.length ] = argAnswerID;
}

function priv_ObjectiveResponse_evaluate() {
    // accumulate score over all questions
    var theCorrect_count = 0;
    
    // determine how many questions for this objective were correct
    var theQuestion_ids = this.objective_description.getQuestionIDs();
    
    for( var j=0; j < theQuestion_ids.length; j++ ) {
        var loopQuestion = this.quiz_response.findQuestionResponseByID( theQuestion_ids[j] );
        
        if( loopQuestion != null ) {
            if( loopQuestion.isCorrect() == ADL_QD_TRUE ) {
                theCorrect_count++;
            }
        } else {
            alert( "error finding question id " + theQuestion_ids[j] );
        }
    }
    
    // see if they passed the objective
    this.priv_tracking_data.score = theCorrect_count / theQuestion_ids.length;
    
    this.priv_tracking_data.satisfaction = SCORM_SUCCESS_FAILED;
    if( this.priv_tracking_data.score >= this.objective_description.threshold )
        this.priv_tracking_data.satisfaction = SCORM_SUCCESS_PASSED;
    
}

function priv_Quiz_evaluate() {
    var theCorrect_count = 0;    // count of correct answers
    var theQuestion_id_list = this.description.getDeliveredQuestionIDs();
    
    // score the questions
    for( var i=0; i < theQuestion_id_list.length; i++ ) {
        var loopQuestion_id = theQuestion_id_list[i];
        var theResponse_question = this.findQuestionResponseByID( loopQuestion_id );
        if( theResponse_question.isCorrect() == ADL_QD_TRUE ){
            theCorrect_count++;
        }
    }
    
    this.priv_tracking_data.score = (theCorrect_count/theQuestion_id_list.length).toFixed(2);
    
    // determine passed/failed
    this.priv_tracking_data.satisfaction = SCORM_SUCCESS_FAILED;
    if( this.priv_tracking_data.score >= this.description.passing_threshold )
        this.priv_tracking_data.satisfaction = SCORM_SUCCESS_PASSED;
        
}

function priv_getTrackingData() {
    if( this.priv_tracking_data != null )
        return this.priv_tracking_data;
        
    this.priv_tracking_data = new ADL_SCORM_TrackingData()
    this.evaluate();
    return this.priv_tracking_data;
}
