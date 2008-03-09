/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.events.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.utils.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	

	public class NavigationMediator extends Mediator
	{
		
		public static const NAME:String = "NavigationMediator";
		
		public function NavigationMediator( viewComponent:IndexCards )
		{
			super( NAME, viewComponent );
			app.addEventListener(NavigationEvent.NAVIGATE,onNavEvent);
		}
		
		private function onNavEvent(event:NavigationEvent):void
		{
			var component:Object = event.viewComponent;
			var viewType:String = component.VIEW_TYPE;
			switch(viewType)
			{
				case Constants.INDEX_CARD_VIEW_TYPE:
					sendNotification(ApplicationFacade.INDEX_CARDS_VIEW, component, viewType); 
					break;
				case Constants.RUBBER_BAND_VIEW_TYPE:
					sendNotification(ApplicationFacade.RUBBER_BANDS_VIEW, component, viewType);
					break;
				case Constants.SUBJECT_VIEW_TYPE:
					sendNotification(ApplicationFacade.SUBJECTS_VIEW, component, viewType);
					break;
				case Constants.STUDY_VIEW_TYPE:
					sendNotification(ApplicationFacade.STUDY_VIEW, component, viewType);
					break;
			}
		}
		
		protected function get app():IndexCards
		{
			return viewComponent as IndexCards;
		}
				
	}
}