#include "lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);

Function setColorBands (String rgb, int start, int end);									//set bands color in range (1-16)				rgb value("0,255,127"), start position(4), end position(12)
Function setColorBandsOdd (String rgb);														//set odd bands color							rgb value("0,255,127")
Function setColorBandsEven (String rgb);													//set even bands color							rgb value("0,255,127")
Function setColorBandsGradient(int r, int g, int b, int stepr, int stepg, int stepb);		//set color bands to a gradient					red(0), green(255), blue(127), step red(10), step green(-5), step blue(+2)
Function setColorosc (String rgb);															//set oscilloscope color						rgb value("0,255,127")
Function setColoroscRange (String rgb, int start, int end);									//set oscilloscope color in range (1-5)			rgb value("0,255,127"), start position(1), end position(4)
Function setColoroscOdd (String rgb);														//set odd oscilloscope color					rgb value("0,255,127")
Function setColoroscEven (String rgb);														//set even oscilloscope color					rgb value("0,255,127")

Function darkDisplay(Boolean visible);

Global Container containerMain;
Global Container containerPL;
Global Layout layoutPL, layoutMainNormal, layoutMainShade;
Global Group NormalGroupMain, NormalGroupDisplay, ShadeGroupMain, ShadeGroupDisplay, TDSongTitleGroup;
Global Vis visualizer, /*visualizershade, visualizerpl, */visualizerwmp, visualizerwmps1, visualizerwmps2, visualizerwmps3;
Global Layer wmpblackness;
Global Button OAIDUBtnUE1, OAIDUBtnUE2, OAIDUBtnUE3;
Global GuiObject DisplayTime;
Global Status DisplayStatusIcons;
Global Text TDText;

Global PopUpMenu visMenu;
Global PopUpMenu specmenu;
Global PopUpMenu oscmenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu stylemenu;
Global PopUpMenu colmenu;
Global PopUpMenu wmpmenu;
Global PopUpMenu waxpmenu;

Global Int currentMode, a_falloffspeed, p_falloffspeed, a_coloring, v_color;
Global Boolean show_peaks, dark_display;
Global layer Trigger, HideForVic, TriggerBlocker, TriggerBlockerShade;

//OAIDU mess
Global GuiObject OAIDUo;
Global Layer OAIDUon, OAIDUoh, OAIDUod;
Global ToggleButton OAIDUa;
Global Button OAIDUi, OAIDUd, OAIDUu;


System.onScriptLoaded()
{ 
  containerMain = System.getContainer("main");
	layoutMainNormal = containerMain.getLayout("normal");
	NormalGroupMain = layoutMainNormal.findObject("player.normal.group.main");
	NormalGroupDisplay = NormalGroupMain.findObject("player.normal.group.display");
	TDSongTitleGroup = NormalGroupMain.findObject("player.timedisplay.songtitle");
	OAIDUBtnUE1 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry1");
  OAIDUBtnUE2 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry2");
  OAIDUBtnUE3 = NormalGroupDisplay.findObject("OAIDU.buttons.U.menuentry3");

	visualizer = NormalGroupDisplay.findObject("player.vis");
	
	visualizerwmp = NormalGroupDisplay.findObject("wmp.vis");
	visualizerwmps1 = NormalGroupDisplay.findObject("wmp.vis.shadow1");
	visualizerwmps2 = NormalGroupDisplay.findObject("wmp.vis.shadow2");
	visualizerwmps3 = NormalGroupDisplay.findObject("wmp.vis.shadow3");
	
	wmpblackness = NormalGroupDisplay.findObject("WMP");

	layoutMainShade = containerMain.getLayout("shade");
	ShadeGroupMain = layoutMainShade.findObject("player.shade.group.main");
	ShadeGroupDisplay = ShadeGroupMain.findObject("player.shade.group.display");
	//visualizershade = ShadeGroupDisplay.findObject("shade.vis");
		
  	containerPL = System.getContainer("PLEdit");
  	layoutPL = containerPL.getLayout("normalpl");
	//visualizerpl = layoutPL.findObject("shade.vis");

	Trigger = NormalGroupDisplay.findObject("player.vis.trigger");
	TriggerBlocker = layoutPL.findObject("player.vis.blocker");
	TriggerBlockerShade = ShadeGroupDisplay.findObject("player.vis.blocker");
	HideForVic = NormalGroupDisplay.findObject("hide.for.vic");

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmp.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmp.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmp.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps1.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps1.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps1.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps2.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps2.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps2.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps3.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps3.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps3.setXmlParam("falloff", integerToString(a_falloffspeed));
	/*
	visualizershade.setXmlParam("peaks", integerToString(show_peaks));
	visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
	visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));
	*/
	//display stuff
	DisplayTime = NormalGroupDisplay.getObject("display.time");
	DisplayStatusIcons = NormalGroupDisplay.getObject("status");
	TDText = TDSongTitleGroup.getObject("player.timedisplay.text");

	//oaidu stuff
	OAIDUo = NormalGroupDisplay.getObject("OAIDU.buttons.O.m");
	OAIDUon = NormalGroupDisplay.getObject("oaidu.button.o.n");
	OAIDUoh = NormalGroupDisplay.getObject("oaidu.button.o.h");
	OAIDUod = NormalGroupDisplay.getObject("oaidu.button.o.d");

	OAIDUa = NormalGroupDisplay.getObject("OAIDU.buttons.A");
	OAIDUi = NormalGroupDisplay.getObject("OAIDU.buttons.I");
	OAIDUd = NormalGroupDisplay.getObject("OAIDU.buttons.D");
	OAIDUu = NormalGroupDisplay.getObject("OAIDU.buttons.U");

	darkDisplay(dark_display);

	

	refreshVisSettings ();
}
/*
visualizerpl.onSetVisible(int on) {
	if (on) refreshVisSettings ();
}

visualizershade.onSetVisible(int on) {
	if (on) refreshVisSettings ();
}
*/
refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	dark_display = getPrivateInt(getSkinName(), "Dark Display", 0);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff", 2);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 0);
	v_color = getPrivateInt(getSkinName(), "Visualizer Color themes", 2);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmp.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmp.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmp.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps1.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps1.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps1.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps2.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps2.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps2.setXmlParam("falloff", integerToString(a_falloffspeed));
	
	visualizerwmps3.setXmlParam("peaks", integerToString(show_peaks));
	visualizerwmps3.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerwmps3.setXmlParam("falloff", integerToString(a_falloffspeed));
	/*
	visualizershade.setXmlParam("peaks", integerToString(show_peaks));
	visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));	

	visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
	visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));
	*/
	if (a_coloring == 0)
	{
		visualizer.setXmlParam("coloring", "Normal");
		//visualizershade.setXmlParam("coloring", "Normal");
		//visualizerpl.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 1)
	{
		visualizer.setXmlParam("coloring", "Normal");
		//visualizershade.setXmlParam("coloring", "Normal");
		//visualizerpl.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 2)
	{
		visualizer.setXmlParam("coloring", "Fire");
		//visualizershade.setXmlParam("coloring", "Fire");
		//visualizerpl.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		visualizer.setXmlParam("coloring", "Line");
		//visualizershade.setXmlParam("coloring", "Line");
		//visualizerpl.setXmlParam("coloring", "Line");
	}
	
		if(v_color == 0 || v_color == 1){
			//luna
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "49,106,197");
			visualizer.setXmlParam("colorbandpeak", "49,106,197");
			setColorOsc("49,106,197");

			visualizer.setXmlParam("fps", "30");
		}
		else if (v_color == 2)
		{
			//winamp color
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_color == 3)		//bars
		{
			visualizerwmp.setXmlParam("mode", "1");
			visualizerwmp.setXmlParam("alpha","255");
			visualizerwmp.setXmlParam("falloff","2");
			visualizerwmp.setXmlParam("peakfalloff","1");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizer.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("colorallbands", "0,176,32");
			visualizerwmp.setXmlParam("colorbandpeak", "32,32,255");
			visualizerwmp.setXmlParam("bandwidth","wide");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "24");
		}
		else if (v_color == 4)		//ocean mist
		{
			visualizer.setXmlParam("alpha","0");
			
			visualizerwmp.setXmlParam("alpha","255");
			
			visualizerwmps1.setXmlParam("alpha","128");
			visualizerwmps2.setXmlParam("alpha","64");
			visualizerwmps3.setXmlParam("alpha","32");
			
			visualizerwmps1.setXmlParam("falloff", "2");
			visualizerwmps2.setXmlParam("falloff", "1");
			visualizerwmps3.setXmlParam("falloff", "0");
			
			visualizerwmps1.setXmlParam("peakfalloff", "1");
			visualizerwmps2.setXmlParam("peakfalloff", "0");
			visualizerwmps3.setXmlParam("peakfalloff", "0");
			
			visualizerwmp.setXmlParam("colorallbands", "0,0,255");
			visualizerwmp.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmp.setXmlParam("bandwidth","thin");
			visualizerwmp.setXmlParam("peakfalloff","1");
			
			visualizerwmp.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("mode", "1");
			visualizerwmps2.setXmlParam("mode", "1");
			visualizerwmps3.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps1.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmps2.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps2.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmps3.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps3.setXmlParam("colorbandpeak", "255,255,255");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "25");
		}
		else if (v_color == 5)		//fire storm
		{
			visualizer.setXmlParam("alpha","0");
			
			visualizerwmp.setXmlParam("alpha","255");
			
			visualizerwmps1.setXmlParam("alpha","128");
			visualizerwmps2.setXmlParam("alpha","64");
			visualizerwmps3.setXmlParam("alpha","32");
			
			visualizerwmps1.setXmlParam("falloff", "2");
			visualizerwmps2.setXmlParam("falloff", "1");
			visualizerwmps3.setXmlParam("falloff", "0");
			
			visualizerwmps1.setXmlParam("peakfalloff", "1");
			visualizerwmps2.setXmlParam("peakfalloff", "0");
			visualizerwmps3.setXmlParam("peakfalloff", "0");
			
			visualizerwmp.setXmlParam("colorallbands", "255,165,0");
			visualizerwmp.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmp.setXmlParam("bandwidth","thin");
			visualizerwmp.setXmlParam("peakfalloff","1");
			
			visualizerwmps1.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps1.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmps2.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps2.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmps3.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps3.setXmlParam("colorbandpeak", "255,0,0");
			
			visualizerwmp.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("mode", "1");
			visualizerwmps2.setXmlParam("mode", "1");
			visualizerwmps3.setXmlParam("mode", "1");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "25");
		}
		else if (v_color == 6)		//scope
		{
			visualizer.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("alpha","255");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizerwmp.setXmlParam("colorosc1","160,255,160");
			visualizerwmp.setXmlParam("colorosc2","160,255,160");
			visualizerwmp.setXmlParam("colorosc3","160,255,160");
			visualizerwmp.setXmlParam("colorosc4","160,255,160");
			visualizerwmp.setXmlParam("colorosc5","160,255,160");
			
			visualizerwmp.setXmlParam("mode", "2");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "24");
		}
		else if(v_color == 7){
			//olive green
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "147,160,112");
			visualizer.setXmlParam("colorbandpeak", "153,84,10");
			setColorOsc("147,160,112");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 8){
			//silver
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "178,180,191");
			visualizer.setXmlParam("colorbandpeak", "178,180,191");
			setColorOsc("178,180,191");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 9){
			//luna - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");

			setColorBandsGradient(3,84,227,4,4,2);

			visualizer.setXmlParam("colorbandpeak", "61,149,255");
			setColorOscOdd("3,84,227");
			setColorOscEven("61,149,255");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 10){
			//olive green - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			setColorBandsGradient(165,179,125,4,4,4);

			visualizer.setXmlParam("colorbandpeak", "231,240,197");
			setColorOscOdd("165,179,125");
			setColorOscEven("231,240,197");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 11){
			//silver - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			setColorBandsGradient(165,164,190,6,6,4);

			visualizer.setXmlParam("colorbandpeak", "252,252,252");
			setColorOscOdd("165,164,190");
			setColorOscEven("252,252,252");

			visualizer.setXmlParam("fps", "30");
		}
	setVis (currentMode);
	darkDisplay(dark_display);
}

Trigger.onLeftButtonDown (int x, int y)
{
	currentMode++;

	if (currentMode == 6)
	{
		currentMode = 0;
	}

	setVis	(currentMode);
	complete;
}



Trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	specmenu = new PopUpMenu;
	oscmenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	colmenu = new PopUpMenu;
	waxpmenu = new PopUpMenu;
	wmpmenu= new PopUpMenu;

	visMenu.addCommand("Presets:", 999, 0, 1);
	visMenu.addCommand("No Visualization", 100, currentMode == 0, 0);
	
	visMenu.addSubMenu(colmenu, "Visualizer Style");
	waxpmenu.addCommand("Luna", 500, v_color == 0, 0);
	waxpmenu.addCommand("Luna (Gradient)", 509, v_color == 9, 0);
	waxpmenu.addCommand("Olive Green", 507, v_color == 7, 0);
	waxpmenu.addCommand("Olive Green (Gradient)", 510, v_color == 10, 0);
	waxpmenu.addCommand("Silver", 508, v_color == 8, 0);
	waxpmenu.addCommand("Silver (Gradient)", 511, v_color == 11, 0);
	colmenu.addCommand("Winamp/WACUP", 502, v_color == 2, 0);
	colmenu.addSubMenu(waxpmenu, "WinampXP");
	colmenu.addSubMenu(wmpmenu, "Windows Media Player");
	wmpmenu.addCommand("Bars", 503, v_color == 3, 0);
	wmpmenu.addCommand("Ocean Mist", 504, v_color == 4, 0);
	wmpmenu.addCommand("Fire Storm", 505, v_color == 5, 0);
	wmpmenu.addCommand("Scope", 506, v_color == 6, 0);
	
	specmenu.addCommand("Thick Bands", 1, currentMode == 1, 0);
	specmenu.addCommand("Thin Bands", 2, currentMode == 2, 0);
	visMenu.addSubMenu(specmenu, "Spectrum Analyzer");

	oscmenu.addCommand("Lines", 3, currentMode == 3, 0);
	oscmenu.addCommand("Dots", 4, currentMode == 4, 0);
	oscmenu.addCommand("Solid", 5, currentMode == 5, 0);
	visMenu.addSubMenu(oscmenu, "Oscilloscope");

	visMenu.addSeparator();
	visMenu.addCommand("Options:", 102, 0, 1);

	visMenu.addCommand("Dark Display", 103, dark_display == 2, 0);
	visMenu.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	
	visMenu.addSubMenu(pksmenu, "Peak Falloff Speed");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	
	visMenu.addSubMenu(anamenu, "Analyzer Falloff Speed");
	stylemenu.addCommand("Normal", 400, a_coloring == 0, 0);
	stylemenu.addCommand("Fire", 402, a_coloring == 2, 0);
	stylemenu.addCommand("Line", 403, a_coloring == 3, 0);
	
	visMenu.addSubMenu(stylemenu, "Analyzer Coloring");
	
	visMenu.addSeparator();
	
	visMenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 404, 0,0);
	visMenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 405, 0,0);
	visMenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 406, 0,0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete specmenu;
	delete oscmenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete colmenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		visualizer.setXmlParam("peaks", integerToString(show_peaks));
		//visualizershade.setXmlParam("peaks", integerToString(show_peaks));
		//visualizerpl.setXmlParam("peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a == 103)
	{
		dark_display = (dark_display - 1) * (-1);
		darkDisplay(dark_display);		//yeah i know
		setPrivateInt(getSkinName(), "Dark Display", dark_display);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		//visualizershade.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		//visualizerpl.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		//visualizershade.setXmlParam("falloff", integerToString(a_falloffspeed));
		//visualizerpl.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

	else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			visualizer.setXmlParam("coloring", "Normal");
			//visualizershade.setXmlParam("coloring", "Normal");
			//visualizerpl.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			visualizer.setXmlParam("coloring", "Normal");
			//visualizershade.setXmlParam("coloring", "Normal");
			//visualizerpl.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			visualizer.setXmlParam("coloring", "Fire");
			//visualizershade.setXmlParam("coloring", "Fire");
			//visualizerpl.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			visualizer.setXmlParam("coloring", "Line");
			//visualizershade.setXmlParam("coloring", "Line");
			//visualizerpl.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}
		
  else if (a == 404)
  {
    OAIDUBtnUE1.Leftclick ();
  }
  else if (a == 405)
  {
    OAIDUBtnUE2.Leftclick ();
  }
  else if (a == 406)
  {
    OAIDUBtnUE3.Leftclick ();
  }

	else if (a >= 500 && a <= 511)
	{
		v_color = a - 500;
		if(v_color == 0 || v_color == 1){
			//default blue color
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "49,106,197");
			visualizer.setXmlParam("colorbandpeak", "49,106,197");
			setColorOsc("49,106,197");
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_color == 2)
		{
			//winamp color
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_color == 3)		//bars
		{
			visualizerwmp.setXmlParam("mode", "1");
			visualizerwmp.setXmlParam("alpha","255");
			visualizerwmp.setXmlParam("falloff","2");
			visualizerwmp.setXmlParam("peakfalloff","1");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizer.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("colorallbands", "0,176,32");
			visualizerwmp.setXmlParam("colorbandpeak", "32,32,255");
			visualizerwmp.setXmlParam("bandwidth","wide");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "24");
		}
		else if (v_color == 4)		//ocean mist
		{
			visualizer.setXmlParam("alpha","0");
			
			visualizerwmp.setXmlParam("alpha","255");
			
			visualizerwmps1.setXmlParam("alpha","128");
			visualizerwmps2.setXmlParam("alpha","64");
			visualizerwmps3.setXmlParam("alpha","32");
			
			visualizerwmps1.setXmlParam("falloff", "2");
			visualizerwmps2.setXmlParam("falloff", "1");
			visualizerwmps3.setXmlParam("falloff", "0");
			
			visualizerwmps1.setXmlParam("peakfalloff", "1");
			visualizerwmps2.setXmlParam("peakfalloff", "0");
			visualizerwmps3.setXmlParam("peakfalloff", "0");
			
			visualizerwmp.setXmlParam("colorallbands", "0,0,255");
			visualizerwmp.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmp.setXmlParam("bandwidth","thin");
			visualizerwmp.setXmlParam("peakfalloff","1");
			
			visualizerwmp.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("mode", "1");
			visualizerwmps2.setXmlParam("mode", "1");
			visualizerwmps3.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps1.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmps2.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps2.setXmlParam("colorbandpeak", "255,255,255");
			visualizerwmps3.setXmlParam("colorallbands", "0,0,255");
			visualizerwmps3.setXmlParam("colorbandpeak", "255,255,255");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "25");
		}
		else if (v_color == 5)		//fire storm
		{
			visualizer.setXmlParam("alpha","0");
			
			visualizerwmp.setXmlParam("alpha","255");
			
			visualizerwmps1.setXmlParam("alpha","128");
			visualizerwmps2.setXmlParam("alpha","64");
			visualizerwmps3.setXmlParam("alpha","32");
			
			visualizerwmps1.setXmlParam("falloff", "2");
			visualizerwmps2.setXmlParam("falloff", "1");
			visualizerwmps3.setXmlParam("falloff", "0");
			
			visualizerwmps1.setXmlParam("peakfalloff", "1");
			visualizerwmps2.setXmlParam("peakfalloff", "0");
			visualizerwmps3.setXmlParam("peakfalloff", "0");
			
			visualizerwmp.setXmlParam("colorallbands", "255,165,0");
			visualizerwmp.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmp.setXmlParam("bandwidth","thin");
			visualizerwmp.setXmlParam("peakfalloff","1");
			
			visualizerwmps1.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps1.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmps2.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps2.setXmlParam("colorbandpeak", "255,0,0");
			visualizerwmps3.setXmlParam("colorallbands", "255,165,0");
			visualizerwmps3.setXmlParam("colorbandpeak", "255,0,0");
			
			visualizerwmp.setXmlParam("mode", "1");
			
			visualizerwmps1.setXmlParam("mode", "1");
			visualizerwmps2.setXmlParam("mode", "1");
			visualizerwmps3.setXmlParam("mode", "1");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "25");
		}
		else if (v_color == 6)		//scope
		{
			visualizer.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("alpha","255");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizerwmp.setXmlParam("colorosc1","160,255,160");
			visualizerwmp.setXmlParam("colorosc2","160,255,160");
			visualizerwmp.setXmlParam("colorosc3","160,255,160");
			visualizerwmp.setXmlParam("colorosc4","160,255,160");
			visualizerwmp.setXmlParam("colorosc5","160,255,160");
			
			visualizerwmp.setXmlParam("mode", "2");

			setColorosc("160,255,160");
			visualizer.setXmlParam("fps", "24");
		}
		else if(v_color == 7){
			//olive green
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "147,160,112");
			visualizer.setXmlParam("colorbandpeak", "153,84,10");
			setColorOsc("147,160,112");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 8){
			//silver
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			visualizer.setXmlParam("colorallbands", "178,180,191");
			visualizer.setXmlParam("colorbandpeak", "178,180,191");
			setColorOsc("178,180,191");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 9){
			//luna - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");

			setColorBandsGradient(3,84,227,4,4,2);

			visualizer.setXmlParam("colorbandpeak", "61,149,255");
			setColorOscOdd("3,84,227");
			setColorOscEven("61,149,255");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 10){
			//olive green - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			setColorBandsGradient(165,179,125,4,4,4);

			visualizer.setXmlParam("colorbandpeak", "231,240,197");
			setColorOscOdd("165,179,125");
			setColorOscEven("231,240,197");

			visualizer.setXmlParam("fps", "30");
		}
		else if(v_color == 11){
			//silver - gradient
			visualizer.setXmlParam("alpha","255");
			
			visualizerwmp.setXmlParam("alpha","0");
			visualizerwmp.setXmlParam("mode","0");
			visualizerwmps1.setXmlParam("alpha","0");
			visualizerwmps1.setXmlParam("mode","0");
			visualizerwmps2.setXmlParam("alpha","0");
			visualizerwmps2.setXmlParam("mode","0");
			visualizerwmps3.setXmlParam("alpha","0");
			visualizerwmps3.setXmlParam("mode","0");
			
			setColorBandsGradient(165,164,190,6,6,4);

			visualizer.setXmlParam("colorbandpeak", "252,252,252");
			setColorOscOdd("165,164,190");
			setColorOscEven("252,252,252");

			visualizer.setXmlParam("fps", "30");
		}
		setPrivateInt(getSkinName(), "Visualizer Color themes", v_color);
	}

}

//sets every ColorBand in a range to a color
setColorBands(String rgb, int start, int end)
{
	for(int i=start; i<=end; i++){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//sets every odd ColorBand to a color
setColorBandsOdd(String rgb)
{
	for(int i=1; i<=15; i=i+2){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//sets every even ColorBand to a color
setColorBandsEven(String rgb)
{
	for(int i=2; i<=16; i=i+2){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//makes a gradient using rgb values and steps for each color
setColorBandsGradient(int r, int g, int b, int stepr, int stepg, int stepb)
{
	String grad = integerToString(r) +","+ integerToString(g) +","+ integerToString(b);
	for(int i=1; i<=16; i++){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", grad);
		r=r+stepr; g=g+stepg; b=b+stepb;
		grad = integerToString(r) +","+ integerToString(g) +","+ integerToString(b);
	}
}

//sets every colorosc to a color
setColorosc(String rgb)
{
	for(int i=1; i<=5; i++){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every colorosc in a range color
setColoroscRange(String rgb, int start, int end)
{
	for(int i=start; i<=end; i++){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every odd colorosc to a color
setColoroscOdd(String rgb)
{
	for(int i=1; i<=5; i=i+2){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every even colorosc to a color
setColoroscEven(String rgb)
{
	for(int i=2; i<=4; i=i+2){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

darkDisplay(Boolean visible){
	if(visible){
		//dark display on

		wmpblackness.setXmlParam("alpha","255");
		DisplayTime.setXmlParam("color","WHITE");

		DisplayStatusIcons.setXmlParam("stopBitmap","status.icon.stop.dark");
		DisplayStatusIcons.setXmlParam("playBitmap","status.icon.play.dark");
		DisplayStatusIcons.setXmlParam("pauseBitmap","status.icon.pause.dark");

		TDText.setXmlParam("text","");
		
		OAIDUo.setXmlParam("normal","OAIDU.buttons.O.n.dark");
		OAIDUo.setXmlParam("hover","OAIDU.buttons.O.n.dark");
		OAIDUo.setXmlParam("down","OAIDU.buttons.O.n.dark");

		OAIDUon.setXmlParam("image","OAIDU.buttons.O.n.dark");
		OAIDUoh.setXmlParam("image","OAIDU.buttons.O.n.dark");
		OAIDUod.setXmlParam("image","OAIDU.buttons.O.n.dark");
		
		OAIDUa.setXmlParam("image","OAIDU.buttons.A.dark.1.");
		OAIDUa.setXmlParam("hoverimage","OAIDU.buttons.A.dark.1.");
		OAIDUa.setXmlParam("downimage","OAIDU.buttons.A.dark.1.");
		
		OAIDUi.setXmlParam("image","OAIDU.buttons.I.n.dark");

		OAIDUd.setXmlParam("image","OAIDU.buttons.D.n.dark");

		OAIDUu.setXmlParam("image","OAIDU.buttons.U.n.dark");
	}
	else{
		//dark display off

		wmpblackness.setXmlParam("alpha","0");
		DisplayTime.setXmlParam("color","BLACK");

		DisplayStatusIcons.setXmlParam("stopBitmap","status.icon.stop");
		DisplayStatusIcons.setXmlParam("playBitmap","status.icon.play");
		DisplayStatusIcons.setXmlParam("pauseBitmap","status.icon.pause");

		TDText.setXmlParam("text","Time Display");

		OAIDUo.setXmlParam("normal","OAIDU.buttons.O.n");
		OAIDUo.setXmlParam("hover","OAIDU.buttons.O.n");
		OAIDUo.setXmlParam("down","OAIDU.buttons.O.n");

		OAIDUon.setXmlParam("image","OAIDU.buttons.O.n");
		OAIDUoh.setXmlParam("image","OAIDU.buttons.O.n");
		OAIDUod.setXmlParam("image","OAIDU.buttons.O.n");
		
		OAIDUa.setXmlParam("image","OAIDU.buttons.A.1.");
		OAIDUa.setXmlParam("hoverimage","OAIDU.buttons.A.1.");
		OAIDUa.setXmlParam("downimage","OAIDU.buttons.A.1.");
		
		OAIDUi.setXmlParam("image","OAIDU.buttons.I.n");

		OAIDUd.setXmlParam("image","OAIDU.buttons.D.n");

		OAIDUu.setXmlParam("image","OAIDU.buttons.U.n");
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		HideForVic.show();
		visualizer.setMode(0);
		//visualizershade.setMode(0);
		//visualizerpl.setMode(0);
	}
	else if (mode == 1)
	{
		visualizer.setXmlParam("bandwidth", "wide");
		//visualizershade.setXmlParam("bandwidth", "wide");
		//visualizerpl.setXmlParam("bandwidth", "wide");
		HideForVic.show();
		visualizer.setMode(1);
		//visualizershade.setMode(1);
		//visualizerpl.setMode(1);
	}
	else if (mode == 2)
	{
		visualizer.setXmlParam("bandwidth", "thin");
		//visualizershade.setXmlParam("bandwidth", "thin");
		//visualizerpl.setXmlParam("bandwidth", "thin");
		HideForVic.show();
		visualizer.setMode(1);
		//visualizershade.setMode(1);
		//visualizerpl.setMode(1);
	}
	else if (mode == 3)
	{
		visualizer.setXmlParam("oscstyle", "solid");
		//visualizershade.setXmlParam("oscstyle", "solid");
		//visualizerpl.setXmlParam("oscstyle", "solid");
		HideForVic.hide();
		visualizer.setMode(2);
		//visualizershade.setMode(2);
		//visualizerpl.setMode(2);
	}
	else if (mode == 4)
	{
		visualizer.setXmlParam("oscstyle", "dots");
		//visualizershade.setXmlParam("oscstyle", "dots");
		//visualizerpl.setXmlParam("oscstyle", "dots");
		HideForVic.hide();
		visualizer.setMode(2);
		//visualizershade.setMode(2);
		//visualizerpl.setMode(2);
	}
	else if (mode == 5)
	{
		visualizer.setXmlParam("oscstyle", "lines");
		//visualizershade.setXmlParam("oscstyle", "lines");
		//visualizerpl.setXmlParam("oscstyle", "lines");
		HideForVic.hide();
		visualizer.setMode(2);
		//visualizershade.setMode(2);
		//visualizerpl.setMode(2);
	}
	currentMode = mode;
}


TriggerBlocker.onLeftButtonDblClk(int x, int y)
{
  OAIDUBtnUE1.Leftclick ();
}

TriggerBlockerShade.onLeftButtonDblClk(int x, int y)
{
  OAIDUBtnUE1.Leftclick ();
}