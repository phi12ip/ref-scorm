/*** SIMPLE OBJECTS ***/

ADL_QUIZ_TYPE_BANKS    = "banks";
ADL_QUIZ_TYPE_NO_BANKS = "no_banks";
ADL_QUIZ_TYPE_UNKNOWN  = "unknown";

/***
*
* ADL_QuizDescription_Quiz
* 
***/
function ADL_QuizDescription_Quiz() {
    this.title               = "";
    this.description         = "";
    this.quiz_type           = ADL_QUIZ_TYPE_UNKNOWN;
    this.randomize_answers   = ADL_QD_FALSE;
    this.randomize_questions = ADL_QD_FALSE;
    this.attempt             = 0;
    this.passing_threshold   = 0.7;

    
    /*** public functions ***/
    this.findQuestionByID        = priv_findQuestionByID;
    this.addQuestion             = priv_QuizDescription_addQuestion;
    this.getQuestions            = priv_QuizDescription_getQuestions;
    
    this.addDeliveredQuestionID  = priv_QuizDescription_addDeliveredQuestionID;
    this.getDeliveredQuestionIDs = priv_QuizDescription_getDeliveredQuestionIDs;

    this.addObjective            = priv_QuizDescription_addObjective;
    this.getObjectives           = priv_QuizDescription_getObjectives;
    
    this.addQuestionBank         = priv_QuizDescription_addBank;
    this.getQuestionBanks        = priv_QuizDescription_getBanks;
    
    this.newAttempt              = priv_newAttempt;
    
    
    /*** pseudo-private variables ***/
    this.priv_questions              = new Array();
    this.priv_delivered_question_ids = new Array();
    this.priv_questions_by_ids       = new Array();
    this.priv_objectives             = new Array();
    this.priv_banks                  = new Array();

    return this;
} 

/***
*
* ADL_QuizDescription_Question
* 
***/
function ADL_QuizDescription_Question() {
    this.question_text     = "";
    this.question_type     = SCORM_QUESTION_TYPE_OTHER;
    this.randomize_answers = ADL_QD_FALSE;
    
    /*** public functions ***/
    this.setID = priv_setID;
    this.getID = priv_getID;
    
    this.getAnswers       = priv_QuestionDescription_getAnswers;
    this.addAnswer        = priv_QuestionDescription_addAnswer;
    this.getAnswerPattern = priv_QuestionDescription_getAnswerPattern;
    
    /*** pseudo-private variables ***/
    this.priv_id           = "";
    this.priv_answers      = new Array();

    return this;
}

/***
*
* ADL_QuizDescription_QuestionAnswer
* 
***/
function ADL_QuizDescription_QuestionAnswer() {
    this.answer_text    = "";
    this.answer_correct = ADL_QD_FALSE;
    
    /*** public functions ***/
    this.setID = priv_setID;
    this.getID = priv_getID;
    
    /*** pseudo-private variables ***/
    this.priv_id           = "";

    return this;
}

/***
*
* ADL_QuizDescription_Objective
* 
***/
function ADL_QuizDescription_Objective() {
    this.title = "";
    this.threshold = 0;
    
    /*** public functions ***/
    this.setID = priv_setID;
    this.getID = priv_getID;
    
    this.addQuestionID  = priv_addQuestionID;
    this.getQuestionIDs = priv_getQuestionIDs;
    
    /*** pseudo-private variables ***/
    this.priv_id = "";
    this.priv_question_ids = new Array();

    return this;
}

/***
*
* ADL_QuizDescription_Bank
*
***/
function ADL_QuizDescription_Bank() {
    this.title               = "";
    this.randomize_questions = ADL_QD_FALSE;
    this.draw_size            = 0;
    
    /*** public functions ***/
    this.setID = priv_setID;
    this.getID = priv_getID;

    this.addQuestionID  = priv_addQuestionID;
    this.getQuestionIDs = priv_getQuestionIDs;

    /*** pseudo-private variables ***/
    this.priv_id = "";
    this.priv_question_ids = new Array();

    return this;
}


/*** PRIVATE FUNCTIONS ***/

/**
 * private function for ADL_QuizDescription_Quiz
 */

function priv_findQuestionByID( argQuestionID ) {
    if( this.priv_questions_by_ids[ argQuestionID ] != null )
        return this.priv_questions_by_ids[ argQuestionID ];
    
    for( var i=0; i < this.priv_questions.length; i++ ) {
        if( this.priv_questions[i].getID() == argQuestionID ) {
            this.priv_questions_by_ids[ argQuestionID ] = this.priv_questions[i];
            return this.priv_questions[i];
        }
    }
    
    return null;
}

function priv_QuizDescription_addQuestion( argQuestionDescription ){
    this.priv_questions[ this.priv_questions.length ] = argQuestionDescription;
}

function priv_QuizDescription_getQuestions() {
    if( this.randomize_questions == ADL_QD_TRUE )
        randomizeArray( this.priv_questions );
    return this.priv_questions;
}

function priv_QuizDescription_addDeliveredQuestionID( argQuestionID ){
    this.priv_delivered_question_ids[ this.priv_delivered_question_ids.length ] = argQuestionID;
}

function priv_QuizDescription_getDeliveredQuestionIDs() {
    return this.priv_delivered_question_ids;
}

function priv_QuizDescription_addObjective( argObjectiveDescription ){
    this.priv_objectives[ this.priv_objectives.length ] = argObjectiveDescription;
}

function priv_QuizDescription_getObjectives() {
    return this.priv_objectives;
}

function priv_QuizDescription_addBank( argBankDescription ){
    this.priv_banks[ this.priv_banks.length ] = argBankDescription;
}

function priv_QuizDescription_getBanks() {
    return this.priv_banks;
}

/*** private function of ADL_QuizDescription_Question ***/
/**
 * returns the list of correct answers in the form "3" or "1:4" or "true" or "false"
 *
 * @return a string containing the list of correct answers
 */
function priv_QuestionDescription_getAnswerPattern() {
    var return_string = "";
    
    for( var i=0; i < this.priv_answers.length; i++ ) {
        if( this.priv_answers[i].answer_correct == ADL_QD_TRUE )
            return_string += this.priv_answers[i].getID() + ":";
    }
    
    if( return_string.length > 0 )
        return_string = return_string.substring( 0, return_string.length - 1 );
    
    if( this.question_type == SCORM_QUESTION_TYPE_TF ) {
        if( return_string == "0" ) 
            return_string = SCORM_QUESTION_TYPE_TF_TRUE;
        else 
            return_string = SCORM_QUESTION_TYPE_TF_FALSE;
    }
    
    return return_string;
}


function priv_QuestionDescription_addAnswer( argAnswerDescription ){
    this.priv_answers[ this.priv_answers.length ] = argAnswerDescription;
}

function priv_QuestionDescription_getAnswers() {
    if( this.randomize_answers == ADL_QD_TRUE )
        randomizeArray( this.priv_answers );
    return this.priv_answers;
}


/*** private functions for ADL_QuizDescription_Objective ***/
function priv_addQuestionID( argQuestionID ){
    this.priv_question_ids[ this.priv_question_ids.length ] = argQuestionID;
}

function priv_getQuestionIDs() {
    if( this.randomize_questions == ADL_QD_TRUE )
        randomizeArray( this.priv_question_ids );
    return this.priv_question_ids;
}

function priv_setID( argID ) {
    this.priv_id = argID;
}

function priv_getID() {
    return this.priv_id;
}

function priv_newAttempt() {
    this.attempt++;
    this.priv_delivered_question_ids = new Array();
}
