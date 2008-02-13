/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.view.events
{
	import flash.events.Event;

	public class ItemScrollEvent extends Event
	{
		public static const SCROLL:String = "scroll";
		
		private var _scrollTo:String;
		
		public function ItemScrollEvent(type:String, scrollTo:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_scrollTo = scrollTo;
		}
		
		override public function clone():Event
		{
			return new ItemScrollEvent(type, scrollTo, bubbles, cancelable);
		}
		
		public function get scrollTo():String
		{
			return _scrollTo;
		}
		
	}
}