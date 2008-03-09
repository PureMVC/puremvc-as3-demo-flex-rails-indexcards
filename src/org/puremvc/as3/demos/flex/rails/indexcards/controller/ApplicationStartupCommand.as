/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class ApplicationStartupCommand extends MacroCommand
	{
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(SubjectCommand);
			addSubCommand(RubberBandCommand);
			addSubCommand(IndexCardCommand);
		}
		
	}
}