/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view
{
	import org.puremvc.as3.demos.flex.rails.indexcards.ApplicationFacade;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.IndexCardProxy;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.utils.CollectionUtils;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.events.ItemScrollEvent;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.utils.Constants;
	import org.puremvc.as3.demos.flex.rails.indexcards.vo.*;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;

	public class IndexCardMediator extends Mediator
	{
		public static const NAME:String = 'IndexCardMediator';
		
		private var _facade:ApplicationFacade = ApplicationFacade.getInstance();
		private var _proxy:IndexCardProxy = _facade.retrieveProxy(ApplicationFacade.INDEX_CARD_PROXY) as IndexCardProxy;
		private var _indexCardId:int;
		private var _rubberBandId:int;
		private var _subjectId:int;
		private var _subjectArray:Array = [];
		private var _cardsInView:ArrayCollection;
		private var _currentIndex:uint = 0;
		
		public function IndexCardMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			sortRubberBands();
			_cardsInView = _proxy.indexCardCollection;
			viewComponent.addEventListener(viewComponent.selectCardEventType, onUserSelectsCard);
			viewComponent.addEventListener(viewComponent.selectSubjectEventType, onUserSelectsSubject);
			viewComponent.addEventListener(viewComponent.scrollCardEventType, onUserScrollsCards);
			viewComponent.addEventListener(viewComponent.updateCardEventType, onUserUpdateRequest);
			viewComponent.addEventListener(viewComponent.createCardEventType, onUserCreateRequest);
			viewComponent.addEventListener(viewComponent.deleteCardEventType, onUserDeleteRequest);
			viewComponent.indexCardCollection = setManagedAssociations();
			viewComponent.subjectCollection = _proxy.subjectCollection; 
			viewComponent.rubberBandCollection = _subjectArray[_proxy.subjectCollection.getItemAt(0).name];
			
			setCardParameters();
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.INDEX_CARDS_LOADED, 
					ApplicationFacade.RUBBER_BANDS_LOADED, 
					ApplicationFacade.SUBJECTS_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.INDEX_CARDS_LOADED:
					viewComponent.indexCardCollection = setManagedAssociations();
					break;
				case ApplicationFacade.RUBBER_BANDS_LOADED:
					viewComponent.rubberBandCollection = _proxy.rubberBandCollection;
					break;
				case ApplicationFacade.SUBJECTS_LOADED:
					viewComponent.subjectCollection = _proxy.subjectCollection; 
					break;
				default:
					// Do nothing
			}
		}
		
		private function setManagedAssociations():ArrayCollection
		{
			var cards:ArrayCollection = _proxy.indexCardCollection;
			for(var i:uint = 0; i < cards.length; i++)
			{
				var card:Object = cards.getItemAt(i);
				var rubberBand:Object = CollectionUtils.getItemById(_proxy.rubberBandCollection, card.rubberBandId);
				card.rubberBand = rubberBand.name;
				card.subject = CollectionUtils.getItemById(_proxy.subjectCollection, rubberBand.subjectId).name;
			}
			return cards;
		}
		
		private function onUserSelectsCard(event:Event):void
		{
			var card:IndexCard = _proxy.indexCardCollection.getItemAt(viewComponent.indexCardIndex) as IndexCard;
			_indexCardId = card.id;
			_rubberBandId = card.rubberBandId;
			viewComponent.rubberBandCollection = _subjectArray[card.subject];
			var rubberBand:RubberBand = CollectionUtils.getItemById(viewComponent.rubberBandCollection, _rubberBandId) as RubberBand;
			viewComponent.rubberBandIndex = viewComponent.rubberBandCollection.getItemIndex(rubberBand);
			_subjectId = rubberBand.subjectId;
			var subject:Subject = CollectionUtils.getItemById(_proxy.subjectCollection, _subjectId) as Subject;
			viewComponent.subjectIndex = _proxy.subjectCollection.getItemIndex(subject);
		}
		
		private function onUserSelectsSubject(event:Event):void
		{
			var subject:Subject = CollectionUtils.getItemById(_proxy.subjectCollection, viewComponent.subjectId) as Subject;
			viewComponent.rubberBandCollection = _subjectArray[subject.name];
		}
		
		private function onUserScrollsCards(event:ItemScrollEvent):void
		{
			switch(event.scrollTo)
			{
				case Constants.SCROLL_FIRST:
					_currentIndex = 0;
					break;
				case Constants.SCROLL_PREVIOUS:
					if(_currentIndex > 0) _currentIndex--;
					else _currentIndex = _cardsInView.length-1;
					break;
				case Constants.SCROLL_NEXT:
					_currentIndex++;
					if(_currentIndex == _cardsInView.length) _currentIndex = 0;
					break;
				case Constants.SCROLL_LAST:
					_currentIndex = _cardsInView.length-1;
					break;
				default:
					// Do nothing
			}
			setCardParameters();
		}
		
		private function setCardParameters():void
		{
			viewComponent.currentCard = _currentIndex+1;
			viewComponent.cardCount = _cardsInView.length;
			viewComponent.isFirstCard = false;
			viewComponent.isLastCard = false;
			if(_currentIndex == 0) viewComponent.isFirstCard = true;
			if(_currentIndex == _cardsInView.length-1) viewComponent.isLastCard = true;
			viewComponent.card = _cardsInView.getItemAt(_currentIndex); 
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			_proxy.updateIndexCard(viewComponent);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			_proxy.createIndexCard(viewComponent);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			_proxy.deleteIndexCard(viewComponent.indexCardId);
		}
		
		private function sortRubberBands():void
		{
			var subjects:ArrayCollection = _proxy.subjectCollection;
			var rubberBands:ArrayCollection = _proxy.rubberBandCollection;
			var subjectId:int = 0;
			var subjectName:String = "";
			for(var i:int = 0; i < subjects.length; i++)
			{
				subjectId = subjects.getItemAt(i).id;
				subjectName = subjects.getItemAt(i).name;
				var subjectBands:ArrayCollection = new ArrayCollection;
				for(var j:int = 0; j < rubberBands.length; j++)
				{
					if(rubberBands.getItemAt(j).subjectId == subjectId){
						subjectBands.addItem(rubberBands.getItemAt(j));
					}
				}
				_subjectArray[subjectName] = subjectBands;
			}
		}
		
	}
}