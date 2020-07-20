/*** XML ELEMENT NAMES ***/

var TAG_QUIZ_NO_BANKS = "quiz_without_banks";
var TAG_QUIZ_WITH_BANKS = "quiz_with_banks";
var TAG_QUIZ_PROPERTIES = "quiz_properties";
var TAG_QUIZ_TITLE = "quiz_title";
var TAG_QUIZ_DESCRIPTION = "quiz_description";
var TAG_QUESTION = "question";
var TAG_QUESTION_REFERENCE = "questionref";
var TAG_QUESTION_REFERENCE_URL = "url";
var ATT_QUESTION_ID = "qid";
var ATT_QUESTION_TYPE = "type"
var ATT_RANDOMIZE_ANSWERS = "randomize_answers";
var ATT_RANDOMIZE_QUESTIONS = "randomize_questions";
var TAG_QUETION_TEXT = "q_text";
var TAG_ANSWER = "answer";
var ATT_CORRECT = "correct";
var TAG_QUESTION_BANK = "question_bank";
var ATT_QUESTION_BANK_SIZE = "draw_size";
var TAG_QUESTION_BANK_TITLE = "title";
var TAG_QUESTION_BANK_QID = "question_id";
var TAG_OBJECTIVE = "objective";
var TAG_QUESTION_OBJECTIVE_TITLE = "title";
var ATT_OBJECTIVE_LOCAL_ID = "local_id";
var TAG_OBJECTIVE_THRESHOLD = "passing_threshold";
var TAG_OBJECTIVE_QUESTION = "covered_by_question";


var TAG_TRUE = "t";
var TAG_FALSE = "f";
var ADL_QD_TRUE = "t";
var ADL_QD_FALSE = "f";
var QUESTION_TYPE_MC = "multiple_choice";
var QUESTION_TYPE_TF = "true_false";

/**
* parses an XMLDocument and returns an ADL_QuizDescription_Quiz object with all the quiz information
*
* @param argXMLDoc type XMLDocument
* 
* @return ADL_QuizDescription_Quiz
*/
function makeQuizDescriptorFromXML( argXMLDoc ) {
	var theLocal_quiz = new ADL_QuizDescription_Quiz();
    
    var theXML_quiz_definitions =  argXMLDoc.getElementsByTagName( TAG_QUIZ_NO_BANKS );
    if( theXML_quiz_definitions != null && theXML_quiz_definitions.length > 0 ) {
        theLocal_quiz.quiz_type = ADL_QUIZ_TYPE_NO_BANKS;
    } else {
        theXML_quiz_definitions  =  argXMLDoc.getElementsByTagName( TAG_QUIZ_WITH_BANKS );
        if( theXML_quiz_definitions != null && theXML_quiz_definitions.length > 0 ) {
            theLocal_quiz.quiz_type = ADL_QUIZ_TYPE_BANKS;
        } 
    }
    
    var theXML_quiz_properties = argXMLDoc.getElementsByTagName( TAG_QUIZ_PROPERTIES );
    if( theXML_quiz_properties != null ) {
        /*** see if we should randomize questions ***/
        var theAtt_question_randomization = theXML_quiz_properties[0].getAttribute( ATT_RANDOMIZE_QUESTIONS );
        if( theAtt_question_randomization != null && theAtt_question_randomization == TAG_TRUE ) {
            theLocal_quiz.randomize_questions = ADL_QD_TRUE;
        }

        /*** see if we should randomize answers ***/
        var theAtt_answer_randomization = theXML_quiz_properties[0].getAttribute( ATT_RANDOMIZE_ANSWERS );
        if( theAtt_answer_randomization && theAtt_answer_randomization == TAG_TRUE ) {
            theLocal_quiz.randomize_answers = ADL_QD_TRUE;
        }
    }
    
    theLocal_quiz.title = getFirstXMLNodeValue( argXMLDoc, TAG_QUIZ_TITLE );
    theLocal_quiz.description = getFirstXMLNodeValue( argXMLDoc, TAG_QUIZ_DESCRIPTION );
    
    var theXML_questions = argXMLDoc.getElementsByTagName( TAG_QUESTION );
    for( var i=0; i < theXML_questions.length; i++ ) {
        theQuestion = parseQuestion( theLocal_quiz, theXML_questions[i] );
        theLocal_quiz.addQuestion( theQuestion );
    }
    
    var theXML_question_references = argXMLDoc.getElementsByTagName( TAG_QUESTION_REFERENCE );
    for( var i=0; i < theXML_question_references.length; i++ ) {
        parseQuestionReference( theLocal_quiz, theXML_question_references[i] );
    }
    
    var theXML_objectives = argXMLDoc.getElementsByTagName( TAG_OBJECTIVE );
    for( var i=0; i < theXML_objectives.length; i++ ) {
        theObjective = parseObjective( theXML_objectives[i] );
        theLocal_quiz.addObjective( theObjective );
    }

    if( theLocal_quiz.quiz_type == ADL_QUIZ_TYPE_BANKS ) {
        var theXML_question_banks =  argXMLDoc.getElementsByTagName( TAG_QUESTION_BANK );
        for( var i=0; i < theXML_question_banks.length; i++ ) {
            theBank = parseQuestionBank( theLocal_quiz, theXML_question_banks[i] );
            theLocal_quiz.addQuestionBank( theBank );
        }
    }
    
    return theLocal_quiz;
}

/**
* parses an XMLElement and returns an ADL_QuizDescription_Question object with all the information about the question
*
* @param argQuizDescription type ADL_QuizDescription_Quiz
* @param argXMLQuestion type XMLElement - with root note TAG_QUESTION
* 
* @return ADL_QuizDescription_Question
*/
function parseQuestion( argQuizDescription, argXMLQuestion ) {
    
    var theQuestion = new ADL_QuizDescription_Question();
    
    /*** get question id ***/
    theQuestion.setID( argXMLQuestion.getAttribute( ATT_QUESTION_ID ) );
    
    /*** get question type ***/
    var theAtt_question_type = argXMLQuestion.getAttribute( ATT_QUESTION_TYPE );
    if( theAtt_question_type == QUESTION_TYPE_MC ) {
        theQuestion.question_type = SCORM_QUESTION_TYPE_MC;
    } else if( theAtt_question_type == QUESTION_TYPE_TF ) {
        theQuestion.question_type = SCORM_QUESTION_TYPE_TF;
    }
    
    /*** get answer randomization (optional) ***/
    theQuestion.randomize_answers = argQuizDescription.randomize_answers; // use the Quiz by default
    var theAtt_answer_randomization = argXMLQuestion.getAttribute( ATT_RANDOMIZE_ANSWERS );
    if( theAtt_answer_randomization != null ) {
        if( theAtt_answer_randomization == TAG_TRUE )
            theQuestion.randomize_answers = ADL_QD_TRUE;
        else if( theAtt_answer_randomization == TAG_FALSE )
            theQuestion.randomize_answers = ADL_QD_FALSE;
    }
    if( theQuestion.question_type == SCORM_QUESTION_TYPE_TF ) // never randomize true-false
        theQuestion.randomize_answers = ADL_QD_FALSE;
    
    /*** get question text ***/
    theQuestion.question_text = getFirstXMLNodeValue( argXMLQuestion, TAG_QUETION_TEXT );
    
    /*** get all answers ***/
    var theXML_answers = argXMLQuestion.getElementsByTagName( TAG_ANSWER );
    for( var i=0; i < theXML_answers.length; i++ ) {
        theAnswer = new ADL_QuizDescription_QuestionAnswer();
        theAnswer.setID( i );
        theAnswer.answer_text = theXML_answers[i].firstChild.nodeValue;
        
        var theAtt_is_correct =  theXML_answers[i].getAttribute( ATT_CORRECT );
        if( theAtt_is_correct != null && theAtt_is_correct == TAG_TRUE ) {
            theAnswer.answer_correct = ADL_QD_TRUE;
        }
        
        theQuestion.addAnswer( theAnswer );
    }
    
    return theQuestion;
}

/**
* parses an XMLElement and returns an ADL_QuizDescription_Question object with all the information about the question
 *
 * @param argQuizDescription type ADL_QuizDescription_Quiz
 * @param argXMLQuestionRef type XMLElement - with root note TAG_QUESTION_REFERENCE
 * 
 * @return ADL_QuizDescription_Question
 */
function parseQuestionReference( argQuizDescription, argXMLQuestionRef ) {
    
    var theFile_name = getFirstXMLNodeValue( argXMLQuestionRef, TAG_QUESTION_REFERENCE_URL );

    var theQuestion_xml_document = getXMLFile( theFile_name );
    var theXML_questions = theQuestion_xml_document.getElementsByTagName( TAG_QUESTION );
    for( var i=0; i < theXML_questions.length; i++ ) {
        theQuestion = parseQuestion( argQuizDescription, theXML_questions[i] );
        argQuizDescription.addQuestion( theQuestion );
    }

}

/**
* parses an XMLElement and returns an ADL_QuizDescription_Objective object with all the information about the objective
*
* @param argXMLObjective type XMLElement - with root note TAG_OBJECTIVE
* 
* @return ADL_QuizDescription_Objective
*/
function parseObjective( argXMLObjective ) {
    var theObjective = new ADL_QuizDescription_Objective();
    
    theObjective.title = getFirstXMLNodeValue( argXMLObjective, TAG_QUESTION_OBJECTIVE_TITLE );

    
    theObjective.setID( argXMLObjective.getAttribute( ATT_OBJECTIVE_LOCAL_ID ) );
    theObjective.threshold = getFirstXMLNodeValue( argXMLObjective, TAG_OBJECTIVE_THRESHOLD );
    
    var theXML_questions = argXMLObjective.getElementsByTagName( TAG_OBJECTIVE_QUESTION );
    for( var i = 0; i < theXML_questions.length; i++ ) {
        theObjective.addQuestionID( theXML_questions[i].firstChild.nodeValue );
    }
    
    return theObjective;
}


/**
* parses an XMLElement and returns an ADL_QuizDescription_Bank object with all the information about the question bank
 *
 * @param argQuizDescription type ADL_QuizDescription_Quiz
 * @param argXMLBank type XMLElement - with root note TAG_QUESTION_BANK
 * 
 * @return ADL_QuizDescription_Objective
 */
function parseQuestionBank( argQuizDescription, argXMLBank ) {
    var theBank = new ADL_QuizDescription_Bank();
    
    theBank.title = getFirstXMLNodeValue( argXMLBank, TAG_QUESTION_BANK_TITLE );
    
    /*** see if we should randomize questions ***/
    theBank.randomize_questions = argQuizDescription.randomize_questions;
    var theAtt_question_randomization = argXMLBank.getAttribute( ATT_RANDOMIZE_QUESTIONS );
    if( theAtt_question_randomization != null ) {
        if( theAtt_question_randomization == TAG_TRUE )
            theBank.randomize_questions = ADL_QD_TRUE;
        else if( theAtt_question_randomization == TAG_FALSE )
            theBank.randomize_questions = ADL_QD_FALSE;
    }
    
    var theXML_questions = argXMLBank.getElementsByTagName( TAG_QUESTION_BANK_QID );
    for( var i = 0; i < theXML_questions.length; i++ ) {
        theBank.addQuestionID( theXML_questions[i].firstChild.nodeValue );
    }
    
    /*** see how many questions to draw ***/
    theBank.draw_size = theBank.getQuestionIDs().length;
    var theAtt_question_bank_size = argXMLBank.getAttribute( ATT_QUESTION_BANK_SIZE );
    if( theAtt_question_bank_size != null ) {
        theBank.draw_size = theAtt_question_bank_size;
    }
    
    return theBank;
}

