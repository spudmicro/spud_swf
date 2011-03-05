package com.adaptiveelearning.capi {

	/**
	 * Class defining constants for CAPI purposes
	 * 
	 * --------------------------
	 * Note: Make sure that the server side file CAPIConstants.java is exactly the same
	 *       It is required for tutorial testing and the constants must be with this to ensure
	 * 		 that server side testing is accurate
	 *       
	 */ 
	public class CAPIConstants {
		/**T
		 * CAPI components
		 */ 
		public static const AELP:String				 	= "aelp";
		public static const SESSION:String 				= "session";
		public static const CONTENT_STAGE:String 		= "stage";
		public static const ANIMATION_PANEL:String 		= "animation";
		public static const QUESTION_PANEL:String 		= "questionPanel";
		public static const CHECK_BUTTON:String			= "checkButton";
		
				  
		/**
		 * Constants defining the base paths for valid CAPI targets
		 */ 
		public static const AELP_TARGET_PATH:String 			= "aelp";//AELP;
		public static const SESSION_TARGET_PATH:String 			= "session";//AELP_TARGET_PATH + "." + SESSION;
		public static const STAGE_TARGET_PATH:String 			= "stage";//AELP_TARGET_PATH + "." + CONTENT_STAGE;
		
		// The Animation Panel and Question Panel are part of the stage
		public static const ANIMATION_TARGET_PATH:String 		= "stage.animation";
		public static const QUESTION_PANEL_TARGET_PATH:String 	= STAGE_TARGET_PATH + "." + QUESTION_PANEL;
		public static const CHECK_BUTTON_TARGET_PATH:String 	= STAGE_TARGET_PATH + "." + CHECK_BUTTON;
		
		
		/**
		 * Constants defined for CAPI properties of the teaching session
		 * NB: Ensure that all properties are specified in this array as this is used for verifying tutorials 
		 */
		public static const CUR_ATTEMPT_NUMBER:String 	= "curAttemptNumber";
		public static const CHECK_BUTTON_LABEL:String 	= "checkButtonLabel"; 
		
		public static const SESSION_CAPI_PROPERTIES:Array = [CUR_ATTEMPT_NUMBER,CHECK_BUTTON_LABEL];		
		
		
		
		/**
		 * Constants defined for CAPI properties of the Question Panel
		 * NB: Ensure that all properties are specified in this array as this is used for verifying tutorials 
		 */ 
		public static const SELECTED_CHOICE:String 				= "selectedChoice";
		public static const SELECTED_CHOICES:String 			= "selectedChoices";
		public static const NUMBEROF_SELECTED_CHOICES:String 	= "numberOfSelectedChoices";
		public static const USER_INPUT:String 					= "userInput";
		
		public static const QUESTION_PANEL_CAPI_PROPERTIES:Array = [SELECTED_CHOICE,
																	SELECTED_CHOICES,
																	NUMBEROF_SELECTED_CHOICES,
																	USER_INPUT]
		
		
		/**
		 * Constants defined for CAPI properties of Learning Objects
		 */
		 public static const SET_AELP_USERID:String = "setAELPUserID";
	}
}