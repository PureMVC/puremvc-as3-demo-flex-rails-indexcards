/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.SubjectProxy;
	
	import flash.events.Event;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;

	public class SubjectMediator extends Mediator
	{
		
		public static const NAME:String = "SubjectMediator";
		
		private var _facade:ApplicationFacade = ApplicationFacade.getInstance();
		private var _proxy:SubjectProxy = _facade.retrieveProxy(ApplicationFacade.SUBJECT_PROXY) as SubjectProxy;
		
		public function SubjectMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			viewComponent.addEventListener(viewComponent.updateSubjectEventType, onUserUpdateRequest);
			viewComponent.addEventListener(viewComponent.createSubjectEventType, onUserCreateRequest);
			viewComponent.addEventListener(viewComponent.deleteSubjectEventType, onUserDeleteRequest);
			viewComponent.subjectCollection = _proxy.subjectCollection; 
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
					viewComponent.subjectCollection = _proxy.subjectCollection; 
					break;
				default:
					// do nothing
			}
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			_proxy.updateSubject(viewComponent);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			_proxy.createSubject(viewComponent);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			_proxy.deleteSubject(viewComponent.subjectId);
		}
		
	}
}