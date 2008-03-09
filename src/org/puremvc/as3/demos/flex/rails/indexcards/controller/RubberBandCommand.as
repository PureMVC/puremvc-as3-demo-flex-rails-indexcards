/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.*;

	public class RubberBandCommand extends SimpleCommand
	{
		
		override public function execute( notification:INotification ):void
		{
			var rubberBandProxy:RubberBandProxy = facade.retrieveProxy(RubberBandProxy.NAME) as RubberBandProxy;
			switch( notification.getName() )
			{
				case ApplicationFacade.STARTUP:
					rubberBandProxy.loadRubberBands();
					break;
				case ApplicationFacade.RUBBER_BANDS_VIEW:
					facade.registerMediator( new RubberBandMediator(notification.getBody() as BandEditPanel));
					break;
			}
		}
		
	}
}