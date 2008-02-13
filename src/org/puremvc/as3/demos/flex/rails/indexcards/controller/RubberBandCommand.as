/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.RubberBandProxy;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.RubberBandMediator;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.command.SimpleCommand;

	public class RubberBandCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			var proxy:RubberBandProxy = facade.retrieveProxy(ApplicationFacade.RUBBER_BAND_PROXY) as RubberBandProxy;
			switch(notification.getName())
			{
				case ApplicationFacade.APP_STARTUP:
					proxy.loadRubberBands();
					break;
				case ApplicationFacade.RUBBER_BANDS_VIEW:
					facade.registerMediator(new RubberBandMediator(notification.getBody()));
					break;
				default:
					// do nothing
			}
		}
		
	}
}