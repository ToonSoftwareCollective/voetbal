import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0
import BxtClient 1.0

App {
		id: voetbalApp

		property url 		tileUrl : "VoetbalTile.qml"
		property url 		thumbnailIcon: "qrc:/tsc/doorcam.png"
		property 		    VoetbalTile voetbalTile
		property		    VoetbalConfigScreen voetbalConfigScreen
		property url 		voetbalConfigScreenUrl : "VoetbalConfigScreen.qml"

		property int 		i
		property variant 	items: ["","","","","","","","","",""]
		property variant 	oldscoretotal: [0,0,0,0,0,0,0,0,0,0]
		
		property variant 	deviceStatusInfo: ({})
		property variant 	hueScenes: []
		property variant 	lampstatus: []
		property variant 	oldlampstatus: []
		

		property  string	selectedteams : ""
		property  string    selectedlampsbyuuid : ""
		property  string    selectedlampsbyname  : ""
		property  string    selectedscenebyuuid : ""
		property  string    selectedscenebyname  : ""
		property  string 	bridgeuuid
		property  int		sizeoftilefont
		property  int		notificationtime: 10000

		property  string	firstlinescreentext : "skjfdsjkfjk - sdfhsdjhfjsdhfj"
		property  string	secondlinescreentext : "0 - 1"
		
		property bool goaltimerrunning : false
		
		property variant voetbalSettingsJson : {
			'notificationtime': 0,
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
		}


		function getURL() {
			var xhr2 = new XMLHttpRequest();
			xhr2.open("GET", "https://www.goal.com/nl/live-scores", true); //check the feeds from the webpage
			xhr2.onreadystatechange = function() {
				if (xhr2.readyState == XMLHttpRequest.DONE) {
					if (xhr2.status == 200) {
								/*
									div class="competition-wrapper"> 
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
												

												var calculatedfontzize = isNxt? parseInt(590/items[i].length):parseInt(500/items[i].length)
												if (sizeoftilefont > calculatedfontzize){
													sizeoftilefont=calculatedfontzize
												}
												
												i=i+1
												n100 = n26

												var newscoretotal = parseInt(homescore) + parseInt(outscore)
												if (newscoretotal == 0) {oldscoretotal[i]=0}

												if ((oldscoretotal[i] != newscoretotal) && (newscoretotal>0)){   //new goal scored this match
														
														console.log("voetbal new score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
														var teamsarray = selectedteams.split(';')
														for(var x = 0;x < teamsarray.length;x++){
															var teamcheck = teamsarray[x].toLowerCase()
															var combiteam = homeplayer + outplayer
															if((combiteam.toLowerCase().indexOf(teamcheck) != -1)  && teamcheck.length > 2){
																///////////////////////////////////////
																////SPECIAL ACTION WHEN GOAL HERE!!!!!!
																
																	var str1 = "{\"teams\" : \"";
																	var str2 = homeplayer + " - " + outplayer;
																	var str3 = "\", \"score\":\"";
																	var str4 = homescore + " - " + outscore;
																	var str5 = "\"}";
																	var res = str1.concat(str2, str3, str4, str5);
																	var doc2 = new XMLHttpRequest();
																	doc2.open("PUT", "file:///HCBv2/qml/apps/voetbal/newScore.json");
																	doc2.send(res);
																	
																	oldlampstatus = lampstatus
																	
																	if(selectedlampsbyuuid.length>0){
																		if (selectedscenebyuuid.length>0) //select new special scene
																			var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, bridgeuuid, null, "LoadScene");
																			msg.addArgument("scene",  parseInt(selectedscenebyuuid));
																			bxtClient.sendMsg(msg);
																			console.log("Blinking started");
																		}
																		lampblinkTimer.running = true
																		//lampTimer.running = true
																	}
																	
																	animationscreen.qmlAnimationURL= "file:///HCBv2/qml/apps/voetbal/VoetbalAnimation.qml"
																	animationscreen.animationInterval= isNxt ? 100000 : 100000
																	animationscreen.isVisibleinDimState= true	
																	animationscreen.animationRunning= true;
																	goalTimer.running = true
																	
																///////////////////////////////////////
																
																break;
															}
														}
													oldscoretotal[i] = newscoretotal
												}
											}
								}
							}
						matchesUpdated()		
					}
				}//end of xhr2.readystate
			xhr2.send()
		}
		
		function getLampStates(update){
			for (var i = 0; i < lampstatus.length; i++) items[i] =""  //clear array
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
			for(var xx = 0;xx < lampstatus.length;xx++){
					//console.log(lampstatus[xx])
			}
		}
		
		
		BxtDiscoveryHandler {
			id: smartplugDiscoHandler
			deviceType: "happ_smartplug"
			//onDiscoReceived: smartplugUuid = deviceUuid
		}


		BxtDatasetHandler {
			id: deviceStatusInfoDataset
			dataset: "deviceStatusInfo"
			discoHandler: smartplugDiscoHandler
			onDatasetUpdate: getLampStates(update)
		}
		
		function restorelamps(){
			console.log("Restoring lamps to old status")
			for (var i = 0; i < oldlampstatus.length; i++){
				var lamp1 = oldlampstatus[i]
				var lampArray=lamp1.split(':')
						console.log("Restoring lamp " + lampArray[0] + " to old status")
						console.log(lampArray[0])
						console.log(lampArray[1])	
						var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, lampArray[0] , "SwitchPower", "SetTarget");
						msg.addArgument("NewTargetValue", (parseInt(lampstate) == 0)? "0": "1");
						bxtClient.sendMsg(msg);
			}
		}
		
		Timer {
			id: voetbalTimer   //interval to scrape data
			interval: 10000
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
				lampblinkTimer.running = false
				if (selectedscenebyuuid.length>0){ //select scene 0 as standard scene
					var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, bridgeuuid, null, "LoadScene")
					msg.addArgument("scene", 0)
					bxtClient.sendMsg(msg)
				}
				restorelamps()
				goalTimer.running = false
			}
		}

		Timer {
			id: lampblinkTimer   //lamp blink interval
			interval: 300   
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
					if (lampstate){
						console.log("Blink On");
						}
					lampstate = !lampstate
			}
		}

		Timer {
			id: lampTimer   //delay to stop blinking lamps
			interval: 6000  
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				lampblinkTimer.running = false
				if (selectedscenebyuuid.length>0){ //select scene 0 as standard scene
					var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, bridgeuuid, null, "LoadScene")
					msg.addArgument("scene", 0)
					bxtClient.sendMsg(msg)
				}
				restorelamps()
				lampTimer.running = false
			}
		}
		
		function saveSettings() {
			var setJson = {
				"favoriteTeams" : selectedteams,
				"notificationtime" : notificationtime,
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
