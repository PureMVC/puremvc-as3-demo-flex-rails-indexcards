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
	

	public class SubjectProxy extends Proxy implements IProxy, IResponder
	{
		
		public static const NAME:String = "SubjectProxy";
		
		public function SubjectProxy()
		{
			super( NAME, null );
		}
		
		public function get subjectId():int 
		{
			return _subjectId;
		}
		
		public function set subjectId(id:int):void
		{
			_subjectId = id;
			_subjectIndex = CollectionUtils.getIndexById(_subjectCollection,_subjectId);
		}
		
		public function get subjectIndex():uint
		{
			return _subjectIndex;
		}
		
		public function set subjectIndex(index:uint):void
		{
			subjectId = CollectionUtils.getIdByIndex(_subjectCollection,index);
		}
		
		public function get subjectCollection():ArrayCollection
		{
			return _subjectCollection;
		}
		
		public function loadSubjects():void
		{
			_currentUrl = URL.SUBJECT_LIST;
			var service:HTTPService = new HTTPService();
			service.url = _currentUrl;
			var token:AsyncToken = service.send();
			token.addResponder(this);
		}
		
		public function updateSubject(subject:Object):void
		{
			var dataObj:Object = buildDataObject(true,subject);
			_currentUrl = URL.SUBJECT_UPDATE;
			postRequest(dataObj);
		}
		
		public function createSubject(subject:Object):void
		{
			var dataObj:Object = buildDataObject(false,subject);
			_currentUrl = URL.SUBJECT_CREATE;
			postRequest(dataObj);
		}
		
		public function deleteSubject(id:int):void
		{
			var dataObj:Object = new Object;
			dataObj['id'] = id;
			_currentUrl = URL.SUBJECT_DELETE;
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
				case URL.SUBJECT_LIST:
					_subjectCollection = Translator.subjectList(data.message.body);
					sendNotification(ApplicationFacade.SUBJECTS_LOADED,this);
					break;
				case URL.SUBJECT_UPDATE:
				case URL.SUBJECT_CREATE:
				case URL.SUBJECT_DELETE:
				default:
					loadSubjects();
			}
		}
		
		public function fault(info:Object):void
		{
			var fault:FaultEvent = info as FaultEvent;
			trace("Fault invoked in SubjectProxy:")
			trace(fault.fault.faultString);
		}
		
		private function buildDataObject(isUpdate:Boolean, subject:Object):Object
		{
			var dataObj:Object = new Object;
			if(isUpdate) dataObj['id'] = subject.subjectId;
			dataObj['subject[name]'] = subject.subjectName;
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

		private var _currentUrl:String;
		private var _subjectId:int;
		private var _subjectIndex:uint;
		private var _subjectCollection:ArrayCollection = new ArrayCollection();
		
	}
}