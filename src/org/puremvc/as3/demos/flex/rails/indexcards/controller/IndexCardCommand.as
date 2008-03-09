/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.IndexCardProxy;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.IndexCardMediator;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.IndexCardViewer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class IndexCardCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var indexCardProxy:IndexCardProxy = facade.retrieveProxy( IndexCardProxy.NAME ) as IndexCardProxy; 
			
			switch( notification.getName() )
			{
				case ApplicationFacade.STARTUP:
					// On startup, proceed to the next case and load the index cards:
				case ApplicationFacade.INDEX_CARD_LOAD:
					indexCardProxy.loadIndexCards();
					break;
				case ApplicationFacade.INDEX_CARDS_VIEW:
					facade.registerMediator(new IndexCardMediator(notification.getBody() as IndexCardViewer));
					break;
			}
		}
		
	}
}