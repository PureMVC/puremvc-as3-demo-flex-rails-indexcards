/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards
{
	import org.puremvc.as3.demos.flex.rails.indexcards.controller.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.*;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		// Notification name constants
        public static const STARTUP:String 					= "startup";
        public static const SHUTDOWN:String 				= "shutdown";
		public static const LOGOUT:String 					= "logout";
		public static const LOGIN:String 					= "login";
		public static const INDEX_CARD_LOAD:String          = "indexCardLoad";
		public static const INDEX_CARDS_LOADED:String		= "indexCardsLoaded";
		public static const	INDEX_CARDS_VIEW:String			= "indexCardsView";
		public static const RUBBER_BANDS_LOADED:String		= "rubberBandsLoaded";
		public static const RUBBER_BANDS_VIEW:String 		= "rubberBandsView";
		public static const SUBJECTS_LOADED:String			= "subjectsLoaded";
		public static const SUBJECTS_VIEW:String			= "subjectsView";
		public static const STUDY_VIEW:String				= "studyView";
		
		/**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance() : ApplicationFacade 
		{
            if (instance == null) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }

        /**
         * Registers Commands with the Controller 
         */
        override protected function initializeController() : void 
        {
            super.initializeController(); 
            registerCommand(STARTUP, ApplicationStartupCommand);
            registerCommand(LOGIN, ApplicationLoginCommand);
            registerCommand(INDEX_CARDS_VIEW, IndexCardCommand);
            registerCommand(RUBBER_BANDS_VIEW, RubberBandCommand);
            registerCommand(SUBJECTS_VIEW, SubjectCommand);
        }
        
         /**
         * Overrides the retrieveProxy method to evaluate for null values
         */
        override public function retrieveProxy (proxyName:String):IProxy {
        	var proxy:IProxy;
        	if(model.retrieveProxy(proxyName) != null)
        	{
        		proxy = model.retrieveProxy(proxyName);
        	}
        	else
        	{
        		proxy = createProxy(proxyName);
        	}
        	return proxy;
		}
        
        /**
         * Starts the application
         */
        public function startup(app:IndexCards):void
		{
		    sendNotification(STARTUP, app);
		} 
		
		/**
		 * Registers the navigation controls on login
		 */
		public function login(app:IndexCards):void
		{
			registerMediator(new NavigationMediator(app));
		}
		
		
		// Instantiates and registers proxies on demand
		private function createProxy(proxyName:String):IProxy 
		{
			var proxy:IProxy;
			switch(proxyName)
			{
				case IndexCardProxy.NAME:
					proxy = new IndexCardProxy;
					break;
				case RubberBandProxy.NAME:
					proxy = new RubberBandProxy;
					break;
				case SubjectProxy.NAME:
					proxy = new SubjectProxy;
					break;
			}
			// Register the proxy and return it
			registerProxy(proxy);
			return model.retrieveProxy(proxyName);
		}
	}
}