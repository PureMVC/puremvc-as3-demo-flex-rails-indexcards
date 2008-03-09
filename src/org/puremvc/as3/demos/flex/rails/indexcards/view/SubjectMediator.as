/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import flash.events.Event;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.*;

	public class SubjectMediator extends Mediator
	{
		public static const NAME:String = "SubjectMediator";
		
		public function SubjectMediator( viewComponent:SubjectEditPanel )
		{
			super(NAME, viewComponent);
			
			subjectProxy = facade.retrieveProxy( SubjectProxy.NAME ) as SubjectProxy;
			
			subjectEditPanel.addEventListener(subjectEditPanel.updateSubjectEventType, onUserUpdateRequest);
			subjectEditPanel.addEventListener(subjectEditPanel.createSubjectEventType, onUserCreateRequest);
			subjectEditPanel.addEventListener(subjectEditPanel.deleteSubjectEventType, onUserDeleteRequest);
			subjectEditPanel.subjectCollection = subjectProxy.subjectCollection; 
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.SUBJECTS_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.SUBJECTS_LOADED:
					subjectEditPanel.subjectCollection = subjectProxy.subjectCollection; 
					break;
			}
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			subjectProxy.updateSubject(subjectEditPanel);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			subjectProxy.createSubject(subjectEditPanel);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			subjectProxy.deleteSubject(subjectEditPanel.subjectId);
		}
		
		protected function get subjectEditPanel():SubjectEditPanel
		{
			return viewComponent as SubjectEditPanel;
		}
		
		private var subjectProxy:SubjectProxy; 
		
	}
}