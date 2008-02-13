/*
 PureMVC Flex/Rails Demo – Index Cards 
 Copyright (c) 2008 Jim Robson <jim.robson@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.rails.indexcards.controller
{
	import org.puremvc.patterns.command.MacroCommand;

	public class ApplicationStartupCommand extends MacroCommand
	{
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(org.puremvc.as3.demos.flex.rails.indexcards.controller.SubjectCommand);
			addSubCommand(org.puremvc.as3.demos.flex.rails.indexcards.controller.RubberBandCommand);
			addSubCommand(org.puremvc.as3.demos.flex.rails.indexcards.controller.IndexCardCommand);
		}
		
	}
}