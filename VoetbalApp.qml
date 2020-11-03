import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: voetbalApp

	property url 		tileUrl : "VoetbalTile.qml"
	property url 		thumbnailIcon: "qrc:/tsc/doorcam.png"
	property 			VoetbalTile voetbalTile
	property			VoetbalConfigScreen voetbalConfigScreen
	property url 		voetbalConfigScreenUrl : "VoetbalConfigScreen.qml"

	property int 		i
	property variant 	items: ["","","","","","","","","",""]
	property variant 	oldscoretotal: [0,0,0,0,0,0,0,0,0,0]

	property  string	selectedteams : ""
	property  int		sizeoftilefont

	
	property variant voetbalSettingsJson : {
		'favoriteTeams': ""
	}

	signal matchesUpdated()	
	
	FileIO {
		id: voetbalSettingsFile
		source: "file:///mnt/data/tsc/voetbal_userSettings.json"
 	}

	Component.onCompleted: {
		try {
			voetbalSettingsJson = JSON.parse(voetbalSettingsFile.read());

			selectedteams = voetbalSettingsJson['favoriteTeams'];
		} catch(e) {
		}
	}


	function init() {
		registry.registerWidget("tile", tileUrl, this, "voetbalTile", {thumbLabel: qsTr("Voetbal"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", voetbalConfigScreenUrl, this, "voetbalConfigScreen");
	}


    function getURL() {
    var xhr2 = new XMLHttpRequest();
		xhr2.open("GET", "https://www.goal.com/nl/live-scores", true); //check the feeds from the webpage
		xhr2.onreadystatechange = function() {
			if (xhr2.readyState == XMLHttpRequest.DONE) {
				if (xhr2.status == 200) {
							//console.log(xhr2.responseText);
							console.log(selectedteams);
							/*
								div class="competition-wrapper"> 
								<a href="/nl/keuken-kampioen-divisie/1gwajyt0pk2jm5fx5mu36v114"   class="competition-title" > 
								<span class="competition-name">Keuken Kampioen Divisie</span> </a> 
								</div> <div class="match-row-list">   
								<div class="match-row  match-row--status-pla"> 
								<div class="match-row__data"> 
								<div class="match-row__status">  
								<span class="match-row__state">R</span>  
								<span class="match-row__date">03-11-20 (18:45 CET)
								</span> </div> <table class="match-row__teams " width="94%"> <tr> <td width="48%"> 
								<a class="match-row__link" href="/nl/wedstrijd/fc-dordrecht-v-jong-fc-utrecht/64916srq7pq9h0hn2hvjo9zze"   > 
								<b class="match-row__goals">0</b> </a> </td> <td rowspan="2" width="4%">-</td> 
								<td width="48%"> <a class="match-row__link" href="/nl/wedstrijd/fc-dordrecht-v-jong-fc-utrecht/64916srq7pq9h0hn2hvjo9zze"   > 
								<b class="match-row__goals">0</b> </a> </td> </tr> <tr> <td class="match-row__team-home "> 
								<a class="match-row__link" href="/nl/wedstrijd/fc-dordrecht-v-jong-fc-utrecht/64916srq7pq9h0hn2hvjo9zze"   > 
								<span class="match-row__team-name">FC Dordrecht</span> </a> </td> <td class="match-row__team-away "> 
								<a class="match-row__link" href="/nl/wedstrijd/fc-dordrecht-v-jong-fc-utrecht/64916srq7pq9h0hn2hvjo9zze"   > 
								<span class="match-row__team-name">Jong FC Utrecht</span> </a> </td> </tr> </table> </div>  </div>   </div> </div>  
								<div class="competition-matches">                                        
							 */
							var n100 = 1;
							for (var i = 0; i < items.length; i++) items[i] =""

							var found = 2;
						
							var n200 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">') + 1;
							var n210 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">',n200);
							
							var competitionblock = xhr2.responseText.substring(n200, n210);
							//console.log("competitionblock :  "  + competitionblock);
							i=0;
							sizeoftilefont=20;
							calculatedfontzize-20;

							while(found>1)
							{		
								found = competitionblock.indexOf('match-row__date', n100);
								if (found>1){

									var n101 = competitionblock.indexOf('match-row__state', n100) + 17;
									var n102 = competitionblock.indexOf('</',n101);
									var eventstatus = competitionblock.substring(n101, n102);

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
									
									//console.log("nummer " + i + "- " + items[i])
									var calculatedfontzize = isNxt? parseInt(600/items[i].length):parseInt(500/items[i].length);

									if (sizeoftilefont > calculatedfontzize){
										sizeoftilefont=calculatedfontzize;
									}

									i=i+1;
									n100 = n26;

									var newscoretotal = parseInt(homescore) + parseInt(outscore);
									if (newscoretotal == 0) {oldscoretotal[i]=0}

									if ((oldscoretotal[i] != newscoretotal) && (newscoretotal>0)){   //new goal scored this match
									//if (oldscoretotal[i] < newscoretotal){   //new goal scored this match
											var teamsarray = selectedteams.split(';');
											console.log("ongelijk");

											for(var x = 0;x < teamsarray.length;x++){
												var teamcheck = teamsarray[x].toLowerCase();
												var combiteam = homeplayer + outplayer;
												if((combiteam.toLowerCase().indexOf(teamcheck) != -1)  && teamcheck.length > 2){
													console.log("Goal in favorite team")
													////SPECIAL ACTION WHEN GOAL HERE!!!!!!
													break;
												}
											}
										oldscoretotal[i] = newscoretotal
									}
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

	function saveSettings() {
 		var setJson = {
			"favoriteTeams" : selectedteams
		}
  		var doc = new XMLHttpRequest();
   		doc.open("PUT", "file:///mnt/data/tsc/voetbal_userSettings.json");
   		doc.send(JSON.stringify(setJson));
	}
}

