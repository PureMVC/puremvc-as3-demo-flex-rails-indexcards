/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import flash.events.Event;
	import mx.collections.ArrayCollection;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.utils.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.*;

	public class RubberBandMediator extends Mediator
	{
		public static const NAME:String = "RubberBandMediator";

		public function RubberBandMediator( viewComponent:BandEditPanel )
		{
			super( NAME, viewComponent );
			
			rubberBandProxy = facade.retrieveProxy(RubberBandProxy.NAME)as RubberBandProxy;
			
			bandEditPanel.addEventListener(bandEditPanel.updateBandEventType, onUserUpdateRequest);
			bandEditPanel.addEventListener(bandEditPanel.createBandEventType, onUserCreateRequest);
			bandEditPanel.addEventListener(bandEditPanel.deleteBandEventType, onUserDeleteRequest);
			bandEditPanel.rubberBandCollection = setManagedAssociations();
			bandEditPanel.subjectCollection = rubberBandProxy.subjectCollection; 
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
					bandEditPanel.rubberBandCollection = setManagedAssociations();
					break;
				case ApplicationFacade.SUBJECTS_LOADED:
					bandEditPanel.subjectCollection = rubberBandProxy.subjectCollection;
					break;
			}
		}
		
		private function setManagedAssociations():ArrayCollection
		{
			var bands:ArrayCollection = rubberBandProxy.rubberBandCollection;
			for(var i:uint=0; i < bands.length; i++)
			{
				var band:Object = bands.getItemAt(i);
				var subject:Object = CollectionUtils.getItemById(rubberBandProxy.subjectCollection, band.subjectId);
				band.subject = subject.name;
			}
			return bands;
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			rubberBandProxy.updateRubberBand(bandEditPanel);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			rubberBandProxy.createRubberBand(bandEditPanel);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			rubberBandProxy.deleteRubberBand(bandEditPanel.rubberBandId);
		}
		
		protected function get bandEditPanel():BandEditPanel
		{
			return viewComponent as BandEditPanel;
		}

		private var rubberBandProxy:RubberBandProxy;

	}
}