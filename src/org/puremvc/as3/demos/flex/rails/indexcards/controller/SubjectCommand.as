/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.SubjectProxy;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.SubjectMediator;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.command.SimpleCommand;

	public class SubjectCommand extends SimpleCommand
	{
		
		override public function execute(notification:INotification):void
		{
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			var proxy:SubjectProxy = facade.retrieveProxy(ApplicationFacade.SUBJECT_PROXY) as SubjectProxy;
			switch(notification.getName())
			{
				case ApplicationFacade.APP_STARTUP:
					proxy.loadSubjects();
					break;
				case ApplicationFacade.SUBJECTS_VIEW:
					facade.registerMediator(new SubjectMediator(notification.getBody()));
					break;
				default:
				 // do nothing
			}
		}
		
	}
}