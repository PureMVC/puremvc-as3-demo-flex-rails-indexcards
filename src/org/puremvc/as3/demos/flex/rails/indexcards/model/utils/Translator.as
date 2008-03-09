/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.model.utils
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.demos.flex.rails.indexcards.model.vo.*;
	
	public class Translator
	{
		
		public static function subjectList(serverResponse:String):ArrayCollection
		{
			var xml:XML = new XML(serverResponse);
			var subjectList:XMLList = xml..subject;
			var ac:ArrayCollection = new ArrayCollection;
			for(var i:int=0; i < subjectList.length(); i++)
			{
				var item:XML = subjectList[i];
				var subject:Subject = new Subject;
				subject.id = item.id;
				subject.name = item.name;
				ac.addItem(subject);
			}
			return ac;
		}
		
		public static function rubberBandList(serverResponse:String):ArrayCollection
		{
			var xml:XML = new XML(serverResponse);
			var rubberBandList:XMLList = xml.children();
			var ac:ArrayCollection = new ArrayCollection;
			for(var i:int=0; i < rubberBandList.length(); i++)
			{
				var item:XML = rubberBandList[i];
				var rubberBand:RubberBand = new RubberBand;
				rubberBand.id = item.id;
				rubberBand.subjectId = item["subject-id"];
				rubberBand.name = item.name;
				ac.addItem(rubberBand);
			}
			return ac;
		}
		
		public static function indexCardList(serverResponse:String):ArrayCollection
		{
			var xml:XML = new XML(serverResponse);
			var cardList:XMLList = xml..card;
			var ac:ArrayCollection = new ArrayCollection;
			for(var i:int=0; i < cardList.length(); i++)
			{
				var item:XML = cardList[i];
				var card:IndexCard = new IndexCard;
				card.id = item.id;
				card.rubberBandId = item["rubber-band-id"];
				card.frontSide = item["front-side"];
				card.backSide = item["back-side"];
				ac.addItem(card);
			}
			return ac;
		}
		
	}
}