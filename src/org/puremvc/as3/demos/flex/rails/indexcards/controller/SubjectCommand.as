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

	public class SubjectCommand extends SimpleCommand
	{
		
		override public function execute( notification:INotification ):void
		{
			var subjectProxy:SubjectProxy = facade.retrieveProxy( SubjectProxy.NAME ) as SubjectProxy;
			switch(notification.getName())
			{
				case ApplicationFacade.STARTUP:
					subjectProxy.loadSubjects();
					break;
				case ApplicationFacade.SUBJECTS_VIEW:
					facade.registerMediator( new SubjectMediator(notification.getBody() as SubjectEditPanel));
					break;
			}
		}
		
	}
}