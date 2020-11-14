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
		property url 		scraperUrl : "https://www.goal.com/nl/live-scores"
		property url 		demoUrl : "http://oepiloepi.eu/competitie.html"
		property url 		selectedUrl : scraperUrl
		

		property int 		i
		property variant 	items: ["","","","","","","","","",""]
		property variant 	oldscoretotal: [0,0,0,0,0,0,0,0,0,0]
		
		property variant 	deviceStatusInfo: ({})
		property variant 	hueScenes: []
		property variant 	lampstatus: []
		property variant 	oldlamps: []
		

		property  string	selectedteams : ""
		property  string        selectedlampsbyuuid : ""
		property  string        selectedlampsbyname  : ""
		property  string        selectedscenebyuuid : ""
		property  string        selectedscenebyname  : ""
		property  string 	bridgeuuid
		property  int		sizeoftilefont
		property  int		notificationtime: 10000
		property  int		lampNotificationtime:6000
		
		property bool		isFirstRun: true
		property bool 		showmatchesontile: false
		property bool 		isDemoMode: false
		property bool 		isInNotificationMode: false

		
		property  string	firstlinescreentext : "skjfdsjkfjk - sdfhsdjhfjsdhfj"
		property  string	secondlinescreentext : "0 - 1"
		
		property  string        oldlampString  : ""
		
		property bool goaltimerrunning : false
		
		property variant voetbalSettingsJson : {
			'notificationtime': 0,
			'lampNotificationtime': 0,
			'favoriteTeams': "",
			'Bridgeuuid': "",
			'LampUUID' : "",
			'LampName' : "",
			'SceneUUID': "",
			'SceneName': ""
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
				notificationtime = voetbalSettingsJson['notificationtime']
				lampNotificationtime = voetbalSettingsJson['lampNotificationtime']
				selectedteams = voetbalSettingsJson['favoriteTeams']
				selectedlampsbyuuid = voetbalSettingsJson['LampUUID']
				selectedlampsbyname = voetbalSettingsJson['LampName']
				selectedscenebyuuid = voetbalSettingsJson['SceneUUID']
				selectedscenebyname = voetbalSettingsJson['SceneName']
				bridgeuuid = voetbalSettingsJson['Bridgeuuid']
			} catch(e) {
			}
		}


		function init() {
			registry.registerWidget("tile", tileUrl, this, "voetbalTile", {thumbLabel: qsTr("Voetbal"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
			registry.registerWidget("screen", voetbalConfigScreenUrl, this, "voetbalConfigScreen")
			registry.registerWidget("screen", voetbalConfigScreenUrl2, this, "voetbalConfigScreen2")
			registry.registerWidget("screen", voetbalConfigScreenUrl3, this, "voetbalConfigScreen3")
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
									var n100 = 1
									for (var i = 0; i < items.length; i++) items[i] =""  //clear array
															
									var found = 2
									var n200 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">') + 1
									var n210 = xhr2.responseText.indexOf('<div class=\"competition-wrapper\">',n200)
									var competitionblock = xhr2.responseText.substring(n200, n210)
									
									//console.log("competitionblock :  "  + competitionblock)
									
									i=0
									sizeoftilefont=20
									calculatedfontzize-20
									var found99 =  competitionblock.indexOf('>Eredi')
									if (found99>1){
																			
											while ((found>1)&& (i<9)){ //max 9 wedstrijden	
												found = competitionblock.indexOf('match-row__date', n100)
												if (found>1){

													var n101 = competitionblock.indexOf('match-row__state', n100) + 17
													var n102 = competitionblock.indexOf('</',n101)
													var eventstatus = competitionblock.substring(n101, n102)

													var n1 = competitionblock.indexOf('match-row__date', n100) + 17
													
													var n2 = competitionblock.indexOf('(', n1) + 1
													var n3 = competitionblock.indexOf('CET',n2)
													var eventdate = competitionblock.substring(n1, n2)
													var vday = eventdate.substring(0, 2)
													var vmonth = eventdate.substring(3, 6)
													var vyear = eventdate.substring(6, 8)
													var eventtime = competitionblock.substring(n2, n3)
													
													var n10 = competitionblock.indexOf('match-row__goals',n3) + 18
													var n11 = competitionblock.indexOf('</',n10)
													var homescore = competitionblock.substring(n10, n11)	
													
													var n13 = competitionblock.indexOf('match-row__goals',n11) + 18
													var n14 = competitionblock.indexOf('</',n13)
													var outscore = competitionblock.substring(n13, n14)	
													
													var n20 = competitionblock.indexOf('match-row__team-name',n13) + 22
													var n21 = competitionblock.indexOf('</',n20)
													var homeplayer = competitionblock.substring(n20, n21)
													
													var n25 = competitionblock.indexOf('match-row__team-name',n21) + 22
													var n26 = competitionblock.indexOf('</',n25)
													var outplayer = competitionblock.substring(n25, n26)
													
													items[i] = eventtime + " " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer
													

													var calculatedfontzize = isNxt? parseInt(560/items[i].length):parseInt(420/items[i].length)
													if (sizeoftilefont > calculatedfontzize){
														sizeoftilefont=calculatedfontzize
													}
													
													if ((items[0].length)>2){
														showmatchesontile = true
													}else{
														showmatchesontile = false
													}
													
													i=i+1
													n100 = n26

													var newscoretotal = parseInt(homescore) + parseInt(outscore)
													if (newscoretotal == 0) {oldscoretotal[i]=0}
													
													//console.log("match score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
													
													if ((oldscoretotal[i] != newscoretotal) && (newscoretotal>0) && (!isInNotificationMode)){   //new goal scored this match
			
														if (!isFirstRun){
															
															//console.log("voetbal new score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
															//console.log("selectedteams: " + selectedteams)
															var teamsarray = selectedteams.split(';')
															//console.log("teamsarray.length: " + teamsarray.length)
															for(var x = 0;x < teamsarray.length;x++){
																var teamcheck = teamsarray[x].toLowerCase()
																//console.log("checking team: " + teamcheck)
																var combiteam = homeplayer + outplayer
																combiteam = combiteam.toLowerCase()
																//console.log("combi team: " + combiteam)
																if((combiteam.indexOf(teamcheck) != -1)  && teamcheck.length > 2){
																	///////////////////////////////////////
																	////SPECIAL ACTION WHEN GOAL HERE!!!!!!
																	
																	isInNotificationMode = true
																	
																	//console.log("START To Write: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
																	
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
																	
																	/*oldlamps = lampstatus
																	for (var lampcount = 0; lampcount < oldlamps.length; lampcount++){
																		var oldlamp = oldlamps[lampcount]
																		var oldlampArray += oldlamp.split(':')
																		//console.log("Old lamp State:  " + oldlampArray[0] + "   was in old situation " + oldlampArray[1])
																	}
																	
																	*/
																		
																		var setJson = {
																			"teams" : homeplayer + " - " + outplayer,
																			"score" : homescore + " - " + outscore
																		}
																		var doc = new XMLHttpRequest()
																		doc.open("PUT", "file:///HCBv2/qml/apps/voetbal/newScore.json")
																		doc.send(JSON.stringify(setJson))
		
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
																		
																		goalTimer.running = true
																		animationscreen.qmlAnimationURL= "file:///HCBv2/qml/apps/voetbal/VoetbalAnimation.qml"
																		animationscreen.animationInterval= isNxt ? 100000 : 100000
																		animationscreen.isVisibleinDimState= true	
																		animationscreen.animationRunning= true;
																																		
																	///////////////////////////////////////
																	
																	break;
																	
																}//match of team forund in new score match
															}//for each teamsarray
														
														}//isFirstRun?
														
														oldscoretotal[i] = newscoretotal
													
													} //oldscore!=newscore
												}//row found
											}//end of while
									}//eredivisie found
								isFirstRun = false	
								matchesUpdated()
								
						}//xhr status = 200
					}//end of xhr2.readystate
				}//xhr onreadystate
					
				xhr2.send()
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
			var setJson = {
				"favoriteTeams" : selectedteams,
				"notificationtime" : notificationtime,
				"lampNotificationtime" : lampNotificationtime,
				"LampUUID" 	: selectedlampsbyuuid,
				"LampName" 	: selectedlampsbyname,
				"SceneUUID" : selectedscenebyuuid,
				"SceneName" : selectedscenebyname,
				"Bridgeuuid" : bridgeuuid
			}
			var doc = new XMLHttpRequest()
			doc.open("PUT", "file:///mnt/data/tsc/voetbal_userSettings.json")
			doc.send(JSON.stringify(setJson))
		}
	}