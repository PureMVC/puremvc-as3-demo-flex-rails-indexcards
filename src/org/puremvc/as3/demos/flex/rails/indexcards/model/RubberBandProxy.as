/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.model
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	import org.puremvc.as3.demos.flex.rails.indexcards.*;
	import org.puremvc.as3.demos.flex.rails.indexcards.model.utils.*;

	public class RubberBandProxy extends Proxy implements IProxy, IResponder
	{
		public static const NAME:String = "RubberBandProxy";
		
		public function RubberBandProxy()
		{
			super( NAME, null );
			
			subjectProxy = facade.retrieveProxy( SubjectProxy.NAME ) as SubjectProxy;
		}
		
		public function get rubberBandId():int
		{
			return _rubberBandId;
		}
		
		public function set rubberBandId(id:int):void
		{
			_rubberBandId = id;
			_rubberBandIndex = CollectionUtils.getIndexById(_rubberBandCollection,_rubberBandId);
			subjectProxy.subjectId = _rubberBandCollection.getItemAt(_rubberBandIndex).subjectId;
		}
		
		public function get rubberBandIndex():uint
		{
			return _rubberBandIndex;
		}
		
		public function set rubberBandIndex(index:uint):void
		{
			rubberBandId = CollectionUtils.getIdByIndex(_rubberBandCollection,index);
		}
		
		public function get subjectId():int{
			return subjectProxy.subjectId;
		}
		
		public function get subjectIndex():uint
		{
			return subjectProxy.subjectIndex;
		}
		
		public function get rubberBandCollection():ArrayCollection
		{
			return _rubberBandCollection;
		}
		
		public function get subjectCollection():ArrayCollection
		{
			return subjectProxy.subjectCollection;
		}		
		
		public function loadRubberBands():void
		{
			_currentUrl = URL.RUBBER_BAND_LIST;
			var service:HTTPService = new HTTPService;
			service.url = _currentUrl;
			var token:AsyncToken = service.send();
			token.addResponder(this);
		}
		
		public function updateRubberBand(band:Object):void
		{
			var dataObj:Object = buildDataObject(true,band);
			_currentUrl = URL.RUBBER_BAND_UPDATE;
			postRequest(dataObj);
		}
		
		public function createRubberBand(band:Object):void
		{
			var dataObj:Object = buildDataObject(false,band);
			_currentUrl = URL.RUBBER_BAND_CREATE;
			postRequest(dataObj);
		}
		
		public function deleteRubberBand(id:int):void
		{
			var dataObj:Object = new Object;
			dataObj['id'] = id;
			_currentUrl = URL.RUBBER_BAND_DELETE;
			var service:HTTPService = new HTTPService;
			service.url = _currentUrl;
			service.method = "POST";
			var token:AsyncToken = service.send(dataObj);
			token.addResponder(this);
		}
		
		public function result(data:Object):void
		{
			switch(_currentUrl)
			{
				case URL.RUBBER_BAND_LIST:
					_rubberBandCollection = Translator.rubberBandList(data.message.body);
					sendNotification(ApplicationFacade.RUBBER_BANDS_LOADED,this);
					break;
				case URL.RUBBER_BAND_UPDATE:
				case URL.RUBBER_BAND_CREATE:
				case URL.RUBBER_BAND_DELETE:
				default:
					loadRubberBands();
			}
		}
		
		public function fault(info:Object):void
		{
			var fault:FaultEvent = info as FaultEvent;
			trace("Fault invoked in SubjectProxy:")
			trace(fault.fault.faultString);
		}
		
		private function buildDataObject(isUpdate:Boolean, band:Object):Object
		{
			var dataObj:Object = new Object;
			if(isUpdate) dataObj['id'] = band.rubberBandId;
			dataObj['rubber_band[subject_id]'] = band.subjectId;
			dataObj['rubber_band[name]'] = band.rubberBandName;
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
		
		private var subjectProxy:SubjectProxy; 
		
		private var _currentUrl:String;
		private var _rubberBandId:int;
		private var _rubberBandIndex:uint;
		private var _rubberBandCollection:ArrayCollection = new ArrayCollection();
		
	}
}