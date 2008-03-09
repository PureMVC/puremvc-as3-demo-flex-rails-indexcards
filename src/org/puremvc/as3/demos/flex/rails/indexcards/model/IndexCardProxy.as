/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.model
{
	import mx.rpc.IResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.FaultEvent;
	import mx.collections.ArrayCollection;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.utils.*;

	public class IndexCardProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "IndexCardProxy";
		
		public function IndexCardProxy()
		{
			super(NAME, null);
			rubberBandProxy = facade.retrieveProxy( RubberBandProxy.NAME ) as RubberBandProxy;
		}
		
		public function get indexCardCollection():ArrayCollection
		{
			return _indexCardCollection;
		}
		
		public function get indexCardId():int
		{
			return _indexCardId;
		}
		
		public function set indexCardId(id:int):void
		{
			_indexCardId = id;
			_indexCardIndex = CollectionUtils.getIndexById(_indexCardCollection,_indexCardId);
			rubberBandProxy.rubberBandId = _indexCardCollection.getItemAt(_indexCardIndex).id;
		}
		
		public function get indexCardIndex():uint
		{
			return _indexCardIndex;
		}
		
		public function get rubberBandCollection():ArrayCollection
		{
			return rubberBandProxy.rubberBandCollection;
		}
		
		public function get subjectCollection():ArrayCollection
		{
			return rubberBandProxy.subjectCollection;
		}
		
		public function get rubberBandId():int
		{
			return rubberBandProxy.rubberBandId;
		}
		
		public function get rubberBandIndex():uint
		{
			return rubberBandProxy.rubberBandIndex;
		}
		
		public function get subjectId():int
		{
			return rubberBandProxy.subjectId;
		}
		
		public function get subjectIndex():uint
		{
			return rubberBandProxy.subjectIndex;
		}
		
		public function setIdFromIndex(index:int):void
		{
			indexCardId =  _indexCardCollection.getItemAt(index).id as int;
		}
		
		
		public function loadIndexCards():void
		{
			_currentUrl = URL.INDEX_CARD_LIST;
			var service:HTTPService = new HTTPService();
			service.url = _currentUrl;
			var token:AsyncToken = service.send();
			token.addResponder(this);
		}
		
		public function updateIndexCard(card:Object):void
		{
			var dataObj:Object = buildDataObject(true, card);
			_currentUrl = URL.INDEX_CARD_UPDATE;
			postRequest(dataObj);
		}
		
		public function createIndexCard(card:Object):void
		{
			var dataObj:Object = buildDataObject(false, card);
			_currentUrl = URL.INDEX_CARD_CREATE;
			postRequest(dataObj);
		}
		
		public function deleteIndexCard(id:int):void
		{
			var dataObj:Object = new Object;
			dataObj['id'] = id;
			_currentUrl = URL.INDEX_CARD_DELETE;
			var service:HTTPService = new HTTPService();
			service.url = _currentUrl;
			service.method = "POST";
			var token:AsyncToken = service.send(dataObj);
			token.addResponder(this);
		}
		
		public function result(data:Object):void
		{	
			switch(_currentUrl){
				case URL.INDEX_CARD_LIST:
					_indexCardCollection = Translator.indexCardList(data.message.body);
					sendNotification(ApplicationFacade.INDEX_CARDS_LOADED, this);
					break;
				case URL.INDEX_CARD_CREATE:
				case URL.INDEX_CARD_UPDATE:
				case URL.INDEX_CARD_DELETE:
				default:
					loadIndexCards();
			}
		}
		
		public function fault(info:Object):void
		{
			var fault:FaultEvent = info as FaultEvent;
			trace("Fault invoked in IndexCardProxy:")
			trace(fault.fault.faultString);
		}
		
		private function buildDataObject(isUpdate:Boolean, card:Object):Object
		{
			var dataObj:Object = new Object;
			if(isUpdate) dataObj['id'] = card.indexCardId;
			dataObj['card[rubber_band_id]'] = card.rubberBandId;
			dataObj['card[front_side]'] = card.frontSide;
			dataObj['card[back_side]'] = card.backSide;
			return dataObj;
		}
		
		private function postRequest(dataObj:Object):void
		{
			var service:HTTPService = new HTTPService;
			service.url = _currentUrl;
			service.method = "POST";
			var token:AsyncToken = service.send(dataObj);
			token.addResponder(this);
		}
		
		private var rubberBandProxy:RubberBandProxy;
		
		private var _currentUrl:String;
		private var _indexCardId:int;
		private var _indexCardIndex:uint;
		private var _indexCardCollection:ArrayCollection = new ArrayCollection();
	}
}