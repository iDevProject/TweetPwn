#import "iTunes.h"
#import "TweetPwn.h"
%class TMComposeWindowController
%class TMComposeWindow
%class TMButton
// Coming Soon.
/*
%hook TMTextView
- (void) keyDown:(NSEvent *)event {
if([[self delegate] isKindOfClass:[$TMComposeWindowController class]]){
if([event keyCode]==48){
NSLog(@"Got a tab keyevent", [event keyCode]);
NSTextStorage *storage = [self textStorage];
[storage beginEditing];
NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Ohaitar!"];
[storage appendAttributedString:string];
[string release];
[storage endEditing];
[[self delegate] textDidChange:nil];
return;
}
}
%orig;
}
%end
*/

%hook TMComposeWindowController

%new(@v)
- (void)nowPlaying:(id)arg1
{
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

	if (![iTunes isRunning])
	{
		//Your a tool
		NSAlert* alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"Dismiss"];
		[alert setMessageText:@"iTunes isn't running"];
		[alert setInformativeText:@"So, don't be stupid. You aren't playing anything."];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert beginSheetModalForWindow:[self composeWindow] modalDelegate:nil didEndSelector:NULL contextInfo:nil];
		[alert release];
		return;
	}
	
	NSLog(@"#nowplaying %@ by %@", [[iTunes currentTrack] name], [[iTunes currentTrack] artist]);
	
	id track = [[iTunes currentTrack] name];
	id artist = [[iTunes currentTrack] artist];
	
	if (track == nil && artist == nil)
	{
		//Your a tool
		NSAlert* alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"Dismiss"];
		[alert setMessageText:@"*Cough*"];
		[alert setInformativeText:@"Don't be stupid. iTunes is running but you aren't playing anything."];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert beginSheetModalForWindow:[self composeWindow] modalDelegate:nil didEndSelector:NULL contextInfo:nil];
		[alert release];
		return;
	}
	if (track == nil)
	{
		track = @"Unknown";
	}
	if (artist == nil)
	{
		artist = @"Unknown";
	}	
	[[[self composeWindow] textView] setString:[NSString stringWithFormat:@"#nowplaying %@ by %@ ", track, artist, nil]];
	[self textDidChange:nil];
	return;
}

- (void)showWindow:(id)arg1
{
	%orig;
	NSRect frame = {{80, 2}, {57, 40}};
	id button=[[objc_getClass("TMButton") alloc] initWithFrame:frame];
	[button setTitle:@"#♫"];
	[button setTarget:self];
	[button setAction:@selector(nowPlaying:)];
	[button setBezelStyle:NSTexturedRoundedBezelStyle];
	[[[self composeWindow] contentView] addSubview:button];
}
%end
