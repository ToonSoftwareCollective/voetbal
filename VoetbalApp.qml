import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: voetbalApp

	property url 		tileUrl : "VoetbalTile.qml"
	property url 		thumbnailIcon: "qrc:/tsc/doorcam.png"
	property 			VoetbalTile voetbalTile
	property int 		i
	property variant 	items: ["","","","","","","","","",""]

	signal matchesUpdated()	

	function init() {
		registry.registerWidget("tile", tileUrl, this, "voetbalTile", {thumbLabel: qsTr("Voetbal"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"});
	}


    function getURL() {
    var xhr2 = new XMLHttpRequest();
		xhr2.open("GET", "https://www.goal.com/nl/live-scores", true); //check the feeds from the webpage
		xhr2.onreadystatechange = function() {
			if (xhr2.readyState == XMLHttpRequest.DONE) {
				if (xhr2.status == 200) {
							//console.log(xhr2.responseText);
							/*
								<div class="match-row  match-row--status-fix"> <div class="match-row__data"><div class="match-row__status">  
								<span class="match-row__date">01-11-20 (12:15 CET)</span> </div> 
								<table class="match-row__teams " width="94%"> <tr> <td width="48%"> 
								<a class="match-row__link" href="/nl/wedstrijd/heracles-almelo-v-fc-utrecht/ck7y8j64697sk0msbs66kvzoq"   > 
								<b class="match-row__goals">0</b> </a> </td> <td rowspan="2" width="4%">-</td> <td width="48%"> 
								<a class="match-row__link" href="/nl/wedstrijd/heracles-almelo-v-fc-utrecht/ck7y8j64697sk0msbs66kvzoq"   > 
								<b class="match-row__goals">0</b> </a> </td> </tr> <tr> <td class="match-row__team-home "> 
								<a class="match-row__link" href="/nl/wedstrijd/heracles-almelo-v-fc-utrecht/ck7y8j64697sk0msbs66kvzoq"   > 
								<span class="match-row__team-name">Heracles Almelo</span> </a> </td> <td class="match-row__team-away "> 
								<a class="match-row__link" href="/nl/wedstrijd/heracles-almelo-v-fc-utrecht/ck7y8j64697sk0msbs66kvzoq"   > 
								<span class="match-row__team-name">FC Utrecht</span> </a> </td> </tr> </table> </div>  </div>                                         
							 */
							var n100 = 1;
							for (var i = 0; i < items.length; i++) items[i] =""

							var found = 2;
						
							var n200 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">') + 1;
							var n210 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">',n200);
							
							var competitionblock = xhr2.responseText.substring(n200, n210);
							console.log("competitionblock :  "  + competitionblock);
							i=0;
							
							while(found>1)
							{		
								found = competitionblock.indexOf('match-row__date', n100);
								if (found>1){
									var n1 = competitionblock.indexOf('match-row__date', n100) + 17;
									
									var n2 = competitionblock.indexOf('(', n1) + 1;
									var n3 = competitionblock.indexOf('CET',n2);
									var eventdate = competitionblock.substring(n1, n2);
									var vday = eventdate.substring(0, 2);
									var vmonth = eventdate.substring(3, 6);
									var vyear = eventdate.substring(6, 8);
									
									var eventtime = competitionblock.substring(n2, n3);
									
									var n10 = competitionblock.indexOf('match-row__goals',n3) + 18;
									var n11 = competitionblock.indexOf('</',n10);
									var homescore = competitionblock.substring(n10, n11);	
									
									var n13 = competitionblock.indexOf('match-row__goals',n11) + 18;
									var n14 = competitionblock.indexOf('</',n13);
									var outscore = competitionblock.substring(n13, n14);	
									
									var n20 = competitionblock.indexOf('match-row__team-name',n13) + 22;
									var n21 = competitionblock.indexOf('</',n20);
									var homeplayer = competitionblock.substring(n20, n21);	
									
									var n25 = competitionblock.indexOf('match-row__team-name',n21) + 22;
									var n26 = competitionblock.indexOf('</',n25);
									var outplayer = competitionblock.substring(n25, n26);
									
									//items[i] = vday + "-" + vmonth + "-" + vyear + "---" + eventtime + " " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer;
									items[i] = eventtime + " " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer;
									
									console.log("nummer " + i + "- " + items[i])
									i=i+1;
									n100 = n26;
								}
	
							}
							matchesUpdated()
									
				}
			}
		}//end of xhr2.readystate
		xhr2.send();
		
 

	}
	
	Timer {
		id: voetbalTimer
		interval: 10000
		repeat: true
		running: true
		triggeredOnStart: true
		onTriggered: {getURL();}
	}


}

