//11-2020
//by oepi-loepi and ToonzDev


import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0
import BxtClient 1.0

App {
		id: voetbalApp

		property url 		tileUrl : "VoetbalTile.qml"
		property url 		thumbnailIcon: "qrc:/tsc/VoetbalIcon.png"
		property 		    VoetbalTile voetbalTile
		property		    VoetbalConfigScreen voetbalConfigScreen
		property url 		voetbalConfigScreenUrl : "VoetbalConfigScreen.qml"
		property		    VoetbalConfigScreen2 voetbalConfigScreen2
		property url 		voetbalConfigScreenUrl2 : "VoetbalConfigScreen2.qml"
		property		    VoetbalConfigScreen3 voetbalConfigScreen3
		property url 		voetbalConfigScreenUrl3 : "VoetbalConfigScreen3.qml"
		property		    VoetbalConfigScreen4 voetbalConfigScreen4
		property url 		voetbalConfigScreenUrl4 : "VoetbalConfigScreen4.qml"
		property url 		scraperUrl : "https://www.goal.com/nl/live-scores"
		//property url 		scraperUrl :"http://localhost/tsc/competitie.html"
		//property url 		scraperUrl : "https://www.goal.com/nl/uitslagen/2020-11-21"
		property url 		demoUrl : "http://localhost/tsc/competitie.html"
		property url 		selectedUrl : scraperUrl
		
		property string 	appURLString : "https://raw.githubusercontent.com/oepi-loepi/animation"
		property string     teamsCLandELURL : "https://raw.githubusercontent.com/ToonSoftwareCollective/toonanimations/main/teamnamesCL-EL.txt"

		property int 		i
		property variant 	items: ["","","","","","","","","",""]
		property variant 	timestatus: ["","","","","","","","","",""]
		property variant 	oldscoretotal: [0,0,0,0,0,0,0,0,0,0]
		property variant 	oldhomescore: [0,0,0,0,0,0,0,0,0,0]
		property variant 	oldoutscore: [0,0,0,0,0,0,0,0,0,0]
		
		property string 	newmatchstate: ""
		
		property variant 	deviceStatusInfo: ({})
		property variant 	hueScenes: []
		property variant 	lampstatus: []
		property variant 	oldlamps: []
		
		property  string	scoringTeam : ""
		property  string	selectedteams : ""
		property  string	selectedteamsEK : ""
		property  string	teamsCLandEL : ""
		property  string    selectedlampsbyuuid : ""
		property  string    selectedlampsbyname  : ""
		property  string    selectedscenebyuuid : ""
		property  string    selectedscenebyname  : ""
		property  string 	compmodus : "club"
		property  string 	bridgeuuid
		property  int		sizeoftilefont
		property  int		notificationtime: 10000
		property  int		lampNotificationtime:6000
		
		property bool		isFirstRun: true
		property bool 		showmatchesontile: false
		property bool 		isDemoMode: false
		property bool 		isInNotificationMode: false
		property bool 		favscored: false
		property bool 		scoreOwnLightMode: false
		property bool		sonosfound: false
		
		property bool 		snoozevisible: false
		property bool 		snooze: false
		
		
		property  string	firstlinescreentext : ""
		property  string	secondlinescreentext : ""
		
		property string    	oldlampString  : ""
		
		property bool goaltimerrunning : false
		
		property variant voetbalSettingsJson : {
			'notificationtime': 0,
			'lampNotificationtime': 0,
			'favoriteTeams': "",
			'favoriteTeamsEK': "",
			'Bridgeuuid': "",
			'LampUUID' : "",
			'LampName' : "",
			'SceneUUID': "",
			'SceneName': "",
			'scoreOwnLightMode': ""
		}
		property bool lampstate: false


		signal matchesUpdated()	
		
		FileIO {
			id: voetbalSettingsFile
			source: "file:///mnt/data/tsc/voetbal_userSettings.json"
		}

		Component.onCompleted: {
			try {
				voetbalSettingsJson = JSON.parse(voetbalSettingsFile.read())
				
				if (voetbalSettingsJson['scoreOwnLightMode'] == "Yes") {
					scoreOwnLightMode = true
				} else {
					scoreOwnLightMode = false
				}

				notificationtime = voetbalSettingsJson['notificationtime']
				lampNotificationtime = voetbalSettingsJson['lampNotificationtime']
				selectedteams = voetbalSettingsJson['favoriteTeams']
				selectedteamsEK = voetbalSettingsJson['favoriteTeamsEK']
				selectedlampsbyuuid = voetbalSettingsJson['LampUUID']
				selectedlampsbyname = voetbalSettingsJson['LampName']
				selectedscenebyuuid = voetbalSettingsJson['SceneUUID']
				selectedscenebyname = voetbalSettingsJson['SceneName']
				bridgeuuid = voetbalSettingsJson['Bridgeuuid']
			} catch(e) {
			}
			checkSonos()
		}

		function getTeamsCLandEL(){
			teamsCLandEL : ""
			var xmlhttp = new XMLHttpRequest()
			xmlhttp.onreadystatechange=function() {
				if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
					teamsCLandEL = xmlhttp.responseText
					//console.log("teamsCLandEL : " + teamsCLandEL)
				}
			}
			xmlhttp.open("GET",teamsCLandELURL, true)
			xmlhttp.send()
		}
		
		function checkSonos(){
			var doc = new XMLHttpRequest();
				doc.onreadystatechange = function() {
						if (doc.readyState == XMLHttpRequest.DONE) {
							var lampsfile = doc.responseText;
							if (doc.responseText.toLowerCase().indexOf('sonos')>-1){sonosfound = true }
						}
				}
			doc.open("GET", "file:////qmf/config/config_qt-gui.xml", true);
			doc.setRequestHeader("Content-Encoding", "UTF-8");
			doc.send();
		}
		
		
		Timer {
			id: getTeamsCLandELTimer   //interval to get the new teams from EL and CL
			interval: 86400000  //1 x per day
			repeat: true
			running: true
			triggeredOnStart: true
			onTriggered: {
				getTeamsCLandEL()
			}
		}
		
		function init() {
			registry.registerWidget("tile", tileUrl, this, "voetbalTile", {thumbLabel: qsTr("Voetbal"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
			registry.registerWidget("screen", voetbalConfigScreenUrl, this, "voetbalConfigScreen")
			registry.registerWidget("screen", voetbalConfigScreenUrl2, this, "voetbalConfigScreen2")
			registry.registerWidget("screen", voetbalConfigScreenUrl3, this, "voetbalConfigScreen3")
			registry.registerWidget("screen", voetbalConfigScreenUrl4, this, "voetbalConfigScreen4")
		}
		

		function getURL() {
				if (isDemoMode){
					selectedUrl = demoUrl
				}else{
					selectedUrl = scraperUrl
				}
				var xhr2 = new XMLHttpRequest();
				xhr2.open("GET", selectedUrl, true); //check the feeds from the webpage
				xhr2.onreadystatechange = function() {
					if (xhr2.readyState == XMLHttpRequest.DONE) {
						if (xhr2.status == 200) {
									//console.log("XHR READY :  ")
									//console.log("responsetext :  "  + xhr2.responseText)
									/*
										<div class="competition-wrapper"> 
										<a href="/nl/eredivisie/akmkihra9ruad09ljapsm84b3"   class="competition-title" > 
										<span class="competition-name">Eredivisie</span> 
										</a> </div> <div class="match-row-list">   
										<div class="match-row  match-row--status-pla"> 
										<div class="match-row__data"> <div class="match-row__status">  
										<span class="match-row__state">84&#039;</span>  
											(of : <span class="match-row__state">ES</span>)
											(of : <span class="match-row__state">UITG</span>)
											
										<span class="match-row__date">06-11-20 (20:00 CET)
										</span> </div> <table class="match-row__teams " width="94%"> <tr> 
										<td width="48%"> 
										<a class="match-row__link" href="/nl/wedstrijd/fortuna-sittard-v-pec-zwolle/cl0ccwbiy5tw0a2ojidetxsa2"   > 
										<b class="match-row__goals">2</b> </a> </td> 
										<td rowspan="2" width="4%">-</td> <td width="48%"> 
										<a class="match-row__link" href="/nl/wedstrijd/fortuna-sittard-v-pec-zwolle/cl0ccwbiy5tw0a2ojidetxsa2"   > 
										<b class="match-row__goals">2</b> </a> </td> </tr> <tr> <td class="match-row__team-home "> 
										<a class="match-row__link" href="/nl/wedstrijd/fortuna-sittard-v-pec-zwolle/cl0ccwbiy5tw0a2ojidetxsa2"   > 
										<span class="match-row__team-name">Fortuna Sittard</span> </a> </td> <td class="match-row__team-away "> 
										<a class="match-row__link" href="/nl/wedstrijd/fortuna-sittard-v-pec-zwolle/cl0ccwbiy5tw0a2ojidetxsa2"   > 
										<span class="match-row__team-name">PEC Zwolle</span> </a> </td> </tr> </table> </div>  </div>   </div> </div>  
										<div class="competition-matches">                                         
									 */
									for (var i = 0; i < items.length; i++) items[i] =""  //clear array
											
									sizeoftilefont=20
									calculatedfontzize-20
									showmatchesontile = false	
														
									var found = 2
									var matchnumber =0
									i=0
									snoozevisible: false

									var n201 = xhr2.responseText.indexOf('<div class=\"competition-matches\">') + 1
									var n202 = xhr2.responseText.indexOf('<div class=\"widget-footer\">',n201)
									var allmatches = xhr2.responseText.substring(n201, n202)

									var compwrapperarray = allmatches.split('<div class=\"competition-wrapper\">')
									//console.log("compwrapperarray.length: " + compwrapperarray.length)
									for(var competitioncount = 0;competitioncount < compwrapperarray.length;competitioncount++){
																						
														var competitionblock = compwrapperarray[competitioncount]
														//console.log("competitionblock :  "  + competitionblock)
														found = 2

														var eredivipointer = competitionblock.toLowerCase().indexOf('>eredi') 
														var ekpointer =competitionblock.toLowerCase().indexOf('>europees') 
														var wkpointer =competitionblock.toLowerCase().indexOf('>wereldkamp') 
														var olypointer =competitionblock.toLowerCase().indexOf('>olympische')
														var clpointer =competitionblock.toLowerCase().indexOf('>uefa cham')
														var elpointer =competitionblock.toLowerCase().indexOf('>uefa euro')
														
														if (eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 ||clpointer>1 ||elpointer>1){
																//console.log("competition found today ")
																if (eredivipointer>1 ||clpointer>1 ||elpointer>1 ){compmodus = "club"}
																if (ekpointer>1||wkpointer>1||olypointer>1){compmodus = "land"}
						
																//console.log("competitiemodus :  "  + compmodus)

																var matches = competitionblock.split('match-row__data')
																var matchcounter = matches.length
																//console.log("matchcounter :  "  + matchcounter)
																if (matchcounter>9){matchcounter = 9}
															    for(var i = 0; i  < matchcounter; i ++){
																	found = matches[i].indexOf('match-row__date')
																	if (found>1){

																		//console.log("matches[i], competitioncount :  "  + competitioncount)
																		var matchCLorEL = false
																		
																		var n101 = matches[i].indexOf('match-row__state') + 18
																		var n102 = matches[i].indexOf('</',n101)
																		var eventstatus = matches[i].substring(n101, n102)																	

																		//console.log("eventstatus :  "  + eventstatus)

																		var n1 = matches[i].indexOf('match-row__date') + 17
																		
																		var n2 = matches[i].indexOf('(', n1) + 1
																		var n3 = matches[i].indexOf('CET',n2)
																		var eventdate = matches[i].substring(n1, n2)
																		var vday = eventdate.substring(0, 2)
																		var vmonth = eventdate.substring(3, 6)
																		var vyear = eventdate.substring(6, 8)
																		var eventtime = matches[i].substring(n2, n3)
																		
																		newmatchstate = "WAITING"																		
																		if (eventstatus === "ES") {eventtime = "einde" ; newmatchstate = "END"}
																		if (eventstatus === "UITG") {eventtime = "uitg" ; newmatchstate = "WAITING"}
																		if (eventstatus === "R") {eventtime = "rust" ; newmatchstate = "PLAY"}
																		if (eventstatus.indexOf('&#')>0){
																			var n600= eventstatus.indexOf('&#')
																			eventtime = eventstatus.substring(0, n600) + "'"
																			newmatchstate = "PLAY"
																		}
																		
																		var n10 = matches[i].indexOf('match-row__goals') + 18
																		var n11 = matches[i].indexOf('</',n10)
																		var homescore = matches[i].substring(n10, n11)	
																		
																		var n13 = matches[i].indexOf('match-row__goals',n11) + 18
																		var n14 = matches[i].indexOf('</',n13)
																		var outscore = matches[i].substring(n13, n14)	
																		
																		var n20 = matches[i].indexOf('match-row__team-name',n13) + 22
																		var n21 = matches[i].indexOf('</',n20)
																		var homeplayer = matches[i].substring(n20, n21)
																		
																		var n25 = matches[i].indexOf('match-row__team-name',n21) + 22
																		var n26 = matches[i].indexOf('</',n25)
																		var outplayer = matches[i].substring(n25, n26)
																		
																		/////////////////////CHECK IF CL or EL TEAM HERE ///////////////////////////////////////////
																		//only add CL and EL when they are teams in the Dutch Competition
																		
																		if (clpointer>-1 || elpointer>-1){
																			var combiteam = homeplayer + outplayer
																			//combiteam = combiteam.toLowerCase()
																			var teamsCLandELarray = teamsCLandEL.split(';')
																			for(var y = 0;y < teamsCLandELarray.length;y++){
																				var teamcheck = teamsCLandELarray[y].toLowerCase()
																				//console.log("teamcheck : " + teamcheck )
																				if(combiteam.toLowerCase().indexOf(teamcheck) > -1){
																					matchCLorEL = true
																					//console.log("match found : " + homeplayer + " " + outplayer )
																				}
																			}
																		}
																		//console.log("matchCLorEL : " + matchCLorEL )
																		if (eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 || matchCLorEL){
																		
																			//add the match to the tile
																			
																			items[matchnumber] = homeplayer + " " + homescore  + "-" + outscore + " " + outplayer
																			showmatchesontile = true
																			timestatus[matchnumber] = eventtime
																			
																			
																		
																			//clubcompetition or landcompetion?
																					
																			if (compmodus == "club"){
																				var teamsarray = selectedteams.split(';')
																			}else{
																				var teamsarray = selectedteamsEK.split(';')
																			}
																			
																			//check if the state has been changed for a favourite match
																			for(var x = 0;x < teamsarray.length;x++){
																				var teamcheck = teamsarray[x].toLowerCase()
																				var combiteam = homeplayer + outplayer
																				combiteam = combiteam.toLowerCase()
																				if((combiteam.indexOf(teamcheck) != -1)  && teamcheck.length > 2){							
																					if (newmatchstate == "PLAY"  & (sonosfound || selectedlampsbyuuid.length>2)){snoozevisible=true}
																				}
																			}

																			//calculate the fontsize for the tile
																			var calculatedfontzize = isNxt? parseInt(520/(items[matchnumber].length + timestatus[matchnumber].length + 1)):parseInt(400/(items[matchnumber].length + timestatus[matchnumber].length + 1))
																			if (isNxt & sizeoftilefont>17) {sizeoftilefont = 17}
																			if (!isNxt & sizeoftilefont>13) {sizeoftilefont = 13}
																			if (sizeoftilefont > calculatedfontzize){
																				sizeoftilefont=calculatedfontzize
																			}

																			
																			//check is there is a new goal

																			var newscoretotal = parseInt(homescore) + parseInt(outscore)
																			if (newscoretotal == 0) {oldscoretotal[matchnumber]=0}  //reset the oldscoretotal when the sum =0 (new match)
																			
																			//console.log("match score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
																			//console.log("(oldscoretotal[matchnumber] : "  + oldscoretotal[matchnumber])
																			
																			if ((oldscoretotal[matchnumber] != newscoretotal) && (newscoretotal>0) && (!isInNotificationMode)){   //new goal scored this match
																				if ((oldhomescore[matchnumber] != homescore) && (homescore>0)){ //new goal scored this match by homeplayer
																					scoringTeam = homeplayer
																				}
																				
																				if ((oldoutscore[matchnumber] != outscore) && (outscore>0)){ //new goal scored this match by outplayer
																					scoringTeam = outplayer
																				}
																				favscored=false
									
																				if (!isFirstRun){
																					
																					//console.log("voetbal new score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
																					//console.log("selectedteams: " + selectedteams)
																					

																					//check if in the teams of the match where the goal fell one of the favourite teams is playing
																					for(var x = 0;x < teamsarray.length;x++){
																						var teamcheck = teamsarray[x].toLowerCase()
																						//console.log("checking team: " + teamcheck)
																						var combiteam = homeplayer + outplayer
																						combiteam = combiteam.toLowerCase()
																						//console.log("combi team: " + combiteam)
																						if((combiteam.indexOf(teamcheck) != -1)  && teamcheck.length > 2){
																							//goal fell in a match where one of the favourite clubs is playing
																							////SPECIAL ACTION WHEN GOAL HERE!!!!!!
																							
																							isInNotificationMode = true
																							
																							//////////////BLINK LAMPS, CREATE SCREEN NOTIFICATION AND SONOS INTEGRATION ///////////////////////
																							
																							createScreenNotification(homeplayer, outplayer, homescore, outscore)
																							
																							if (!snooze){
																								blinkLamps()
																								try{
																									tscsignals.tscSignal("sonos", homeplayer + ' tegen ' + outplayer + ' staat nu ' + homescore + ' ' + outscore);
																								} catch(e) {
																								}
																							}
																							
																							break;
																							
																						}//match of team fav in new score match
																					}//for each teamsarray
																				}//isFirstRun?
																				
																				oldscoretotal[matchnumber] = newscoretotal
																				oldhomescore[matchnumber]=homescore
																				oldoutscore[matchnumber]=outscore

																			} //oldscore!=newscore
																		}//eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 || matchCLorEL
																		
																		matchnumber++
																	}//row found
																}//end of while
														}//eredivisie, ek, wk, olympisch, cl or el found
									}  //next competion
								isFirstRun = false								
								matchesUpdated()
								
						}//xhr status = 200
					}//end of xhr2.readystate
				}//xhr onreadystate
					
				xhr2.send()
		}
		

		
		function createScreenNotification(homeplayer, outplayer, homescore, outscore){
			console.log(" voetbal START To Write Notification: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
			var setJson = {
				"teams" : homeplayer + " - " + outplayer,
				"score" : homescore + " - " + outscore
			}
			var doc = new XMLHttpRequest()
			doc.open("PUT", "file:///HCBv2/qml/apps/voetbal/newScore.json")
			doc.send(JSON.stringify(setJson))

			//console.log("Showing animation")
			goalTimer.running = true
			animationscreen.qmlAnimationURL= "file:///HCBv2/qml/apps/voetbal/VoetbalAnimation.qml"
			animationscreen.animationInterval= isNxt ? 100000 : 100000
			animationscreen.isVisibleinDimState= true
			animationscreen.animationRunning= true;
		}
		
		function blinkLamps(){
			favscored=false
			if (scoreOwnLightMode){
				var teamsarray2 = selectedteams.split(';')
				for(var sctem = 0;sctem  < teamsarray2.length;sctem ++){
					var teamcheck2 = teamsarray2[sctem].toLowerCase()
					scoringTeam = scoringTeam.toLowerCase()
					if((scoringTeam.indexOf(teamcheck2) != -1)  && teamcheck2.length > 2){
						favscored=true
					}	
				}
			}else{
				favscored=true
			}
			
			if (favscored){
				oldlampString = ""
				for (var lampcount = 0; lampcount < lampstatus.length; lampcount++){
					var lamp = lampstatus[lampcount]
					//console.log("Old lamp State:  " + lampstatus[lampcount])
					if (oldlampString.length<1){
						oldlampString = lampstatus[lampcount]
					}else{
						oldlampString += ";" + lampstatus[lampcount]
					}
				}	
				//console.log("oldlampString:  " + oldlampString)
				
				if(selectedlampsbyuuid.length>0){
					if (selectedscenebyuuid.length>0){ //select new special scene
						var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, bridgeuuid, null, "LoadScene");
						msg.addArgument("scene",  parseInt(selectedscenebyuuid));
						bxtClient.sendMsg(msg);
					}
					//console.log("Blinking started");
					lampblinkTimer.running = true
					lampTimer.running = true
				}
			}

		}
		

		function getLampStates(update){											
			for (var lampc = 0; lampc < lampstatus.length; lampc++) lampstatus[lampc] =""  //clear array
			x = 0
			var infoList = deviceStatusInfo;
			var infoNode = update.getChild("device", 0);
			while (infoNode && infoNode.name === "device") {
				var uuidNode = infoNode.getChild("DevUUID");
				var device = infoList[uuidNode.text];
				if (!device)
					device = {};
					var childNode = infoNode.child;
					while (childNode) {
						//console.log("childNode.name " + childNode.name);
						if (childNode.name == "DevUUID"){
							var lampname = childNode.text;
						}
						if (childNode.name == "CurrentState"){
							var lamponoff = childNode.text;
							lampstatus[x] = lampname + ":" + lamponoff;
							x = x + 1
						}
						//console.log("childNode.text " + childNode.text);
						childNode = childNode.sibling;
					}
				infoList[uuidNode.text] = device;
				infoNode = infoNode.next;
			}
			deviceStatusInfo = infoList;
		}
		
		
		BxtDiscoveryHandler {
			id: smartplugDiscoHandler
			deviceType: "happ_smartplug"
		}


		BxtDatasetHandler {
			id: deviceStatusInfoDataset
			dataset: "deviceStatusInfo"
			discoHandler: smartplugDiscoHandler
			onDatasetUpdate: getLampStates(update)
		}
		
		function restorelamps(){
			//console.log("oldlampString:  " + oldlampString)
			var oldlampArray=oldlampString.split(';')
			for (var lcount = 0; lcount <oldlampArray.length; lcount++){
				var lampoldstatus = oldlampArray[lcount]
				var oldlampSplit=lampoldstatus.split(':')
				//console.log("New lamp States:  " + oldlampSplit[0] + "   restoring to old situation " + oldlampSplit[1])
				var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, oldlampSplit[0] , "SwitchPower", "SetTarget");
				msg.addArgument("NewTargetValue", oldlampSplit[1]);
				bxtClient.sendMsg(msg);
			}
		}
		
		
		Timer {
			id: voetbalTimer   //interval to scrape data
			interval: showmatchesontile? 10000: isDemoMode? 10000: 3600000  //whan there are no matches, set timer to 10 min
			repeat: true
			running: true
			triggeredOnStart: true
			onTriggered: {getURL()}
		}
		
		Timer {
			id: goalTimer   //delay to hide the new goal screen
			interval: notificationtime 
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				animationscreen.animationRunning= false;
				animationscreen.isVisibleinDimState= false;
				isInNotificationMode = false			
				goalTimer.running = false
			}
		}

		Timer {
			id: lampblinkTimer   //lamp blink interval
			interval: 800   
			repeat: true
			running: false
			triggeredOnStart: false
			onTriggered: {
					var lampsarray = selectedlampsbyuuid.split(';')
					for(var x1 = 0;x1 < lampsarray.length;x1++){
						var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, lampsarray[x1] , "SwitchPower", "SetTarget");
						msg.addArgument("NewTargetValue", lampstate? "0": "1");
						bxtClient.sendMsg(msg);
					}
					lampstate = !lampstate
			}
		}

		Timer {
			id: lampTimer   //delay to stop blinking lamps
			interval: lampNotificationtime
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				lampblinkTimer.running = false
				if (selectedscenebyuuid.length>0){ //select new special scene
					var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, bridgeuuid, null, "LoadScene");
					msg.addArgument("scene",  parseInt("0"));
					bxtClient.sendMsg(msg);
				}
				lampTimer.running = false
				restorelamps()
			}
		}
		
		function saveSettings() {
			var tmpscoreOwnLightMode
			if (scoreOwnLightMode == true) {
				tmpscoreOwnLightMode= "Yes";
			} else {
				tmpscoreOwnLightMode = "No";
			}

			var setJson = {
				"favoriteTeams" : selectedteams,
				"favoriteTeamsEK" : selectedteamsEK,
				"notificationtime" : notificationtime,
				"lampNotificationtime" : lampNotificationtime,
				"LampUUID" 	: selectedlampsbyuuid,
				"LampName" 	: selectedlampsbyname,
				"SceneUUID" : selectedscenebyuuid,
				"SceneName" : selectedscenebyname,
				"scoreOwnLightMode" : tmpscoreOwnLightMode,
				"Bridgeuuid" : bridgeuuid
			}
			var doc = new XMLHttpRequest()
			doc.open("PUT", "file:///mnt/data/tsc/voetbal_userSettings.json")
			doc.send(JSON.stringify(setJson))
		}
		
		
	}