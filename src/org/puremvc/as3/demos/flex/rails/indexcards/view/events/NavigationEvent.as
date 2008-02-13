/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view.events
{
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		public static const NAVIGATE:String = "navigate";
		
		private var _viewComponent:Object;
		
		public function NavigationEvent(type:String, viewComponent:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_viewComponent = viewComponent;
		}
		
		override public function clone():Event
		{
			return new NavigationEvent(type, _viewComponent, bubbles, cancelable);
		}
		
		public function get viewComponent():Object
		{
			return _viewComponent;
		}
	}
}