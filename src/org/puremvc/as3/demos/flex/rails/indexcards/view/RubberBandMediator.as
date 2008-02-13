/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.RubberBandProxy;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.utils.CollectionUtils;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;

	public class RubberBandMediator extends Mediator
	{
		public static const NAME:String = "RubberBandMediator";
		
		private var _facade:ApplicationFacade = ApplicationFacade.getInstance();
		private var _proxy:RubberBandProxy = _facade.retrieveProxy(ApplicationFacade.RUBBER_BAND_PROXY)as RubberBandProxy;
		
		
		public function RubberBandMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			viewComponent.addEventListener(viewComponent.updateBandEventType, onUserUpdateRequest);
			viewComponent.addEventListener(viewComponent.createBandEventType, onUserCreateRequest);
			viewComponent.addEventListener(viewComponent.deleteBandEventType, onUserDeleteRequest);
			viewComponent.rubberBandCollection = setManagedAssociations();
			viewComponent.subjectCollection = _proxy.subjectCollection; 
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.RUBBER_BANDS_LOADED, 
					ApplicationFacade.SUBJECTS_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.RUBBER_BANDS_LOADED:
					viewComponent.rubberBandCollection = setManagedAssociations();
					break;
				case ApplicationFacade.SUBJECTS_LOADED:
					viewComponent.subjectCollection = _proxy.subjectCollection;
					break;
				default:
					// do nothing
			}
		}
		
		private function setManagedAssociations():ArrayCollection
		{
			var bands:ArrayCollection = _proxy.rubberBandCollection;
			for(var i:uint=0; i < bands.length; i++)
			{
				var band:Object = bands.getItemAt(i);
				var subject:Object = CollectionUtils.getItemById(_proxy.subjectCollection, band.subjectId);
				band.subject = subject.name;
			}
			return bands;
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			_proxy.updateRubberBand(viewComponent);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			_proxy.createRubberBand(viewComponent);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			_proxy.deleteRubberBand(viewComponent.rubberBandId);
		}
		
	}
}