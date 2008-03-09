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
	import org.puremvc.as3.demos.flex.rails.indexcards.model.vo.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.utils.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.events.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.view.components.*;

	public class IndexCardMediator extends Mediator
	{
		public static const NAME:String = 'IndexCardMediator';
		
		public function IndexCardMediator(viewComponent:IndexCardViewer)
		{
			super(NAME, viewComponent);
			
			indexCardProxy = facade.retrieveProxy(IndexCardProxy.NAME) as IndexCardProxy;
			
			sortRubberBands();
			
			_cardsInView = indexCardProxy.indexCardCollection;
			
			indexCardViewer.addEventListener(indexCardViewer.selectCardEventType, onUserSelectsCard);
			indexCardViewer.addEventListener(indexCardViewer.selectSubjectEventType, onUserSelectsSubject);
			indexCardViewer.addEventListener(indexCardViewer.scrollCardEventType, onUserScrollsCards);
			indexCardViewer.addEventListener(indexCardViewer.updateCardEventType, onUserUpdateRequest);
			indexCardViewer.addEventListener(indexCardViewer.createCardEventType, onUserCreateRequest);
			indexCardViewer.addEventListener(indexCardViewer.deleteCardEventType, onUserDeleteRequest);
			indexCardViewer.indexCardCollection = setManagedAssociations();
			indexCardViewer.subjectCollection = indexCardProxy.subjectCollection; 
			indexCardViewer.rubberBandCollection = _subjectArray[indexCardProxy.subjectCollection.getItemAt(0).name];
			
			setCardParameters();
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
					indexCardViewer.indexCardCollection = setManagedAssociations();
					break;
				case ApplicationFacade.RUBBER_BANDS_LOADED:
					indexCardViewer.rubberBandCollection = indexCardProxy.rubberBandCollection;
					break;
				case ApplicationFacade.SUBJECTS_LOADED:
					indexCardViewer.subjectCollection = indexCardProxy.subjectCollection; 
					break;
			}
		}
		
		private function setManagedAssociations():ArrayCollection
		{
			var cards:ArrayCollection = indexCardProxy.indexCardCollection;
			for(var i:uint = 0; i < cards.length; i++)
			{
				var card:Object = cards.getItemAt(i);
				var rubberBand:Object = CollectionUtils.getItemById(indexCardProxy.rubberBandCollection, card.rubberBandId);
				card.rubberBand = rubberBand.name;
				card.subject = CollectionUtils.getItemById(indexCardProxy.subjectCollection, rubberBand.subjectId).name;
			}
			return cards;
		}
		
		private function onUserSelectsCard(event:Event):void
		{
			var card:IndexCard = indexCardProxy.indexCardCollection.getItemAt(indexCardViewer.indexCardIndex) as IndexCard;
			_indexCardId = card.id;
			_rubberBandId = card.rubberBandId;
			indexCardViewer.rubberBandCollection = _subjectArray[card.subject];
			var rubberBand:RubberBand = CollectionUtils.getItemById(indexCardViewer.rubberBandCollection, _rubberBandId) as RubberBand;
			indexCardViewer.rubberBandIndex = indexCardViewer.rubberBandCollection.getItemIndex(rubberBand);
			_subjectId = rubberBand.subjectId;
			var subject:Subject = CollectionUtils.getItemById(indexCardProxy.subjectCollection, _subjectId) as Subject;
			indexCardViewer.subjectIndex = indexCardProxy.subjectCollection.getItemIndex(subject);
		}
		
		private function onUserSelectsSubject(event:Event):void
		{
			var subject:Subject = CollectionUtils.getItemById(indexCardProxy.subjectCollection, indexCardViewer.subjectId) as Subject;
			indexCardViewer.rubberBandCollection = _subjectArray[subject.name];
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
			}
			setCardParameters();
		}
		
		private function setCardParameters():void
		{
			indexCardViewer.currentCard = _currentIndex+1;
			indexCardViewer.cardCount = _cardsInView.length;
			indexCardViewer.isFirstCard = false;
			indexCardViewer.isLastCard = false;
			if(_currentIndex == 0) indexCardViewer.isFirstCard = true;
			if(_currentIndex == _cardsInView.length-1) indexCardViewer.isLastCard = true;
			indexCardViewer.card = _cardsInView.getItemAt(_currentIndex); 
		}
		
		private function onUserUpdateRequest(event:Event):void
		{
			indexCardProxy.updateIndexCard(indexCardViewer);
		}
		
		private function onUserCreateRequest(event:Event):void
		{
			indexCardProxy.createIndexCard(indexCardViewer);
		}
		
		private function onUserDeleteRequest(event:Event):void
		{
			indexCardProxy.deleteIndexCard(indexCardViewer.indexCardId);
		}
		
		// TBD, should be moved into a command. - CLH
		private function sortRubberBands():void
		{
			var subjects:ArrayCollection = indexCardProxy.subjectCollection;
			var rubberBands:ArrayCollection = indexCardProxy.rubberBandCollection;
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
		
		protected function get indexCardViewer():IndexCardViewer
		{
			return viewComponent as IndexCardViewer;
		}
		
		private var indexCardProxy:IndexCardProxy;
		 
		private var _indexCardId:int;
		private var _rubberBandId:int;
		private var _subjectId:int;
		private var _subjectArray:Array = [];
		private var _cardsInView:ArrayCollection = new ArrayCollection();
		private var _currentIndex:uint = 0;
	}
}