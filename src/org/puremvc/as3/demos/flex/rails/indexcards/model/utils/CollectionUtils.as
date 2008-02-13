/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.model.utils
{
	import mx.collections.ArrayCollection;
	
	
	public class CollectionUtils
	{
		public static function getItemById(ac:ArrayCollection,id:int):Object
		{
			var obj:Object;
			for(var i:int = 0; i < ac.length; i++)
			{
				if(id == ac.getItemAt(i).id)
				{
					obj = ac.getItemAt(i);
					break;
				}
			}
			return obj;
		}
		
		public static function getIndexById(ac:ArrayCollection,id:int):uint
		{
			return ac.getItemIndex(getItemById(ac,id));
		}
		
		public static function getIdByIndex(ac:ArrayCollection,index:int):int
		{
			return ac.getItemAt(index).id;
		}
		
	}
}