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
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.interfaces.IProxy;
	import org.puremvc.patterns.facade.Facade;
	import org.puremvc.patterns.observer.Notification;
	
	public class ApplicationFacade extends Facade
	{
		// Notification name constants
        public static const APP_STARTUP:String 				= "appStartup";
        public static const APP_SHUTDOWN:String 			= "appShutdown";
		public static const APP_LOGOUT:String 				= "appLogout";
		public static const APP_LOGIN:String 				= "appLogin";
		public static const INDEX_CARD_LOAD:String          = "indexCardLoad";
		public static const INDEX_CARDS_LOADED:String		= "indexCardsLoaded";
		public static const	INDEX_CARDS_VIEW:String			= "indexCardsView";
		public static const RUBBER_BANDS_LOADED:String		= "rubberBandsLoaded";
		public static const RUBBER_BANDS_VIEW:String 		= "rubberBandsView";
		public static const SUBJECTS_LOADED:String			= "subjectsLoaded";
		public static const SUBJECTS_VIEW:String			= "subjectsView";
		public static const STUDY_VIEW:String				= "studyView";
		
		// Proxy name constants
		public static const INDEX_CARD_PROXY:String  		= IndexCardProxy.NAME;
		public static const RUBBER_BAND_PROXY:String		= RubberBandProxy.NAME;
		public static const SUBJECT_PROXY:String			= SubjectProxy.NAME;
		
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
            registerCommand(APP_STARTUP, org.puremvc.as3.demos.flex.rails.indexcards.controller.ApplicationStartupCommand);
            registerCommand(APP_LOGIN, org.puremvc.as3.demos.flex.rails.indexcards.controller.ApplicationLoginCommand);
            registerCommand(INDEX_CARDS_VIEW, org.puremvc.as3.demos.flex.rails.indexcards.controller.IndexCardCommand);
            registerCommand(RUBBER_BANDS_VIEW, org.puremvc.as3.demos.flex.rails.indexcards.controller.RubberBandCommand);
            registerCommand(SUBJECTS_VIEW, org.puremvc.as3.demos.flex.rails.indexcards.controller.SubjectCommand);
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
        public function startup(app:Object):void
		{
		    notifyObservers(new Notification(APP_STARTUP, app));
		} 
		
		/**
		 * Registers the navigation controls on login
		 */
		public function login(viewComponent:Object):void
		{
			registerMediator(new NavigationMediator(viewComponent));
		}
		
		
		// Instantiates and registers proxies
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
				default:
					// Do nothing
			}
			// Register the proxy and return it
			registerProxy(proxy);
			return model.retrieveProxy(proxyName);
		}
	}
}