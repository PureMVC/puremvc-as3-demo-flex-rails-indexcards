/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.model.utils
{
	public class URL
	{
		// URL Components
		private static const Stub:String =             "http://localhost:3000/";
		private static const IndexCardDir:String =     "cards/";
		private static const RubberBandDir:String =    "rubber_bands/"
		private static const SubjectDir:String =       "subjects/";
		private static const UserDir:String =          "users/";
		private static const CreateExt:String =        "create";
		private static const ListExt:String =          "list";
		private static const UpdateExt:String =        "update";
		private static const DeleteExt:String =        "delete";
		
		
		// Index Card URLs
		public static const INDEX_CARD_CREATE:String =    Stub + IndexCardDir + CreateExt;
		public static const INDEX_CARD_LIST:String =      Stub + IndexCardDir + ListExt;
		public static const INDEX_CARD_UPDATE:String =    Stub + IndexCardDir + UpdateExt;
		public static const INDEX_CARD_DELETE:String =    Stub + IndexCardDir + DeleteExt;
		
		// Rubber Band URLs
		public static const RUBBER_BAND_CREATE:String =   Stub + RubberBandDir + CreateExt;
		public static const RUBBER_BAND_LIST:String =     Stub + RubberBandDir + ListExt;
		public static const RUBBER_BAND_UPDATE:String =   Stub + RubberBandDir + UpdateExt;
		public static const RUBBER_BAND_DELETE:String =   Stub + RubberBandDir + DeleteExt;
		
		// Subject URLs
		public static const SUBJECT_CREATE:String =       Stub + SubjectDir + CreateExt;
		public static const SUBJECT_LIST:String =         Stub + SubjectDir + ListExt;
		public static const SUBJECT_UPDATE:String =       Stub + SubjectDir + UpdateExt;
		public static const SUBJECT_DELETE:String =       Stub + SubjectDir + DeleteExt;
		
	}
}