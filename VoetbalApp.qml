//11-2020
//by oepi-loepi and ToonzDev


import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0
import BxtClient 1.0
import "VoetbalScraperAD.js" as AD
import "VoetbalScraperVZ.js" as VZ

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
		
		property url 		scraperUrlAD : "https://www.ad.nl/voetbalcenter/live"
		property url 		scraperUrlVZ : "https://www.voetbalzone.nl/actuele_wedstrijden.asp"
		property url		scraperUrl : scraperUrlAD
		

		//property url 		scraperUrl :"http://localhost/tsc/competitie.html"
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
		property variant 	matchstates: ["","","","","","","","","",""]
	
		property variant 	deviceStatusInfo: ({})
		property variant 	hueScenes: []
		property variant 	lampstatus: []
		property variant 	oldlamps: []
		property  string    selectedlampsbyuuid : ""
		property  string    selectedlampsbyname  : ""
		property  string    selectedscenebyuuid : ""
		property  string    selectedscenebyname  : ""
		property  string 	bridgeuuid
		
		property string 	scraperChoice : "AD"

		
		property  string	scoringTeam : ""
		property  string	selectedteams : ""
		property  string	selectedteamsEK : ""
		property  string	teamsCLandEL : ""
		
		property  string	eventtime : ""
		property  string	homeplayer : ""
		property  string	outplayer : ""
		property  string	homescore : ""
		property  string	outscore : ""
		//property  string	matchTime : ""

		property string matchstate						
		property bool found
		property int matchnumber

		property  string 	compmodus : "club"
		property  string 	timeStr
		property  int		sizeoftilefont
		property  int		notificationtime: 10000
		property  int		lampNotificationtime:6000
		property  int 		scrapeInterval:10000
		property  int 		calculatedfontzize
		
//options to show testtime on tile		
//property  string	tileButtonInterval
		
		property bool		isFirstRun: true
		property bool 		showmatchesontile: false
		property bool 		isDemoMode: false
		property bool 		isInNotificationMode: false
		property bool 		favscored: false
		property bool 		scoreOwnLightMode: false
		property bool		sonosfound: false
		property bool       goalscored: false
		property bool		matchJustEnded: false
		property bool       matchJustStarted: false
		
		property bool 		snoozevisible: false
		property bool 		snooze: false
		
		
		property  string	firstlinescreentext : ""
		property  string	secondlinescreentext : ""
		
		property string    	oldlampString  : ""

		property bool oldanimationRunning: false
		property bool oldisVisibleinDimState: true
		property int oldanimationInterval : 1000
		property string oldqmlAnimationURL :  ""
		property string oldqmlAnimationText : ""
		property string oldstaticImageT1 : ""
    		property string oldstaticImageT2 : ""
		property string oldstaticImageT1dim : ""
        	property string oldstaticImageT2dim : ""
		
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
			'scoreOwnLightMode': "",
			'scraperChoice': "AD"
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
			
			try {
				voetbalSettingsJson = JSON.parse(voetbalSettingsFile.read())
				scraperChoice =  voetbalSettingsJson['scraperChoice']
				
				if (scraperChoice == "AD"){
					scraperUrl = scraperUrlAD
				}
				if (scraperChoice == "VZ"){
					scraperUrl = scraperUrlVZ
				}
				
			} catch(e) {
				scraperChoice = "AD"
				scraperUrl = scraperUrlAD
				//console.log ("1-1 " + scraperUrl);
			}
			
			checkSonos()
			console.log ("2 " + scraperUrl);
			getFirstData()
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

		function getFirstData() {
			if (isDemoMode){
				selectedUrl = demoUrl
			}else{
				selectedUrl = scraperUrl
			}
			
			if (scraperChoice == "AD"){
				AD.getFirstURL(selectedUrl)
			}
			if (scraperChoice == "VZ"){
				VZ.getFirstURL(selectedUrl)
			}
		}
		
		
		function getData() {
			//console.log("getData")	
			if (isDemoMode){
				selectedUrl = demoUrl
			}else{
				selectedUrl = scraperUrl
			}
			if (scraperChoice == "AD"){
				AD.getURL(selectedUrl)
			}
			if (scraperChoice == "VZ"){
				VZ.getURL(selectedUrl)
			}
			VZ.getURL(selectedUrl)

		}
		
		function doTakeActions(){
//set a new timer for the scraper
																		
			if (matchstate == "WAITING"){
					var hrs =  parseInt(eventtime.substring(0,2))
					var mins = parseInt(eventtime.substring(3,5))
					var timehrs =  parseInt(timeStr.substring(0,2))
					var timemins = parseInt(timeStr.substring(3,5))
					var msecondstToGo = 1000*(((hrs-timehrs-1)*3600) + ((mins-timemins+55)*60)) //secondstogo to new match - 5 minutes
					//console.log("msecondstToGo : " + msecondstToGo + " to : " + eventtime)										
					if (msecondstToGo>0){
						if (scrapeInterval>msecondstToGo){
							//console.log("****TIME TO NEW MATCH ************")
							scrapeInterval = parseInt(msecondstToGo) //timer calculated 5 minutes before match
							//console.log("scrapeInterval : " + scrapeInterval)
						}
					}
					if (msecondstToGo<=10000 & msecondstToGo>-6600000){  //5 mins before, 110 mins after start
							//console.log("****5 MINS BEFORE TILL 30 MINS AFTER START *************")
							scrapeInterval = 10000//timer 10s minutes before match
							matchstate == "PLAY"  //set the match state to play 5 minutes before start of match
							//console.log("scrapeInterval : " + scrapeInterval)
					}
				}
			
			if (matchstate == "PLAY"){
				//console.log("******PLAY********")
				scrapeInterval = 10000  //10s during match
			}
			
			if (matchstate == "END"){
				//console.log("******END********")
				timestatus[matchnumber] = "einde"
			} 
			
			//console.log("scrapeInterval : " + scrapeInterval)
//add the match to the tile														
			
			items[matchnumber] = homeplayer + " " + homescore  + "-" + outscore + " " + outplayer
			//console.log("items[matchnumber] : " + items[matchnumber])
			showmatchesontile = true
			timestatus[matchnumber] = eventtime
			
//match just started?						
			if (matchstates[matchnumber] == "WAITING" && matchstate == "PLAY" ){
				matchJustStarted = true
			}else{
				matchJustStarted = false
			}
//match just ended?																				
			if (matchstates[matchnumber] == "PLAY" && matchstate == "END" ){
				matchJustEnded = true
			}else{
				matchJustEnded = false
			}

			matchstates[matchnumber] = matchstate
//calculate the fontsize for the tile													
			var calculatedfontzize = isNxt? parseInt(520/(items[matchnumber].length + 5)):parseInt(400/(items[matchnumber].length + 5))
			//console.log("items[matchnumber] : " + items[matchnumber])
			//console.log("items[matchnumber].length : " + items[matchnumber].length)
			
			//console.log("calculatedfontzize : " + calculatedfontzize)
			//console.log("sizeoftilefont : " + sizeoftilefont)
			
			if (isNxt & sizeoftilefont>17) {sizeoftilefont = 17}
			if (!isNxt & sizeoftilefont<13) {sizeoftilefont = 13}
			if (sizeoftilefont > calculatedfontzize){
				sizeoftilefont=calculatedfontzize
			}
			//console.log("sizeoftilefont : " + sizeoftilefont)																							

//clubcompetition or landcompetion?		
			if (compmodus == "club"){
				var teamsarray = selectedteams.split(';')
			}else{
				var teamsarray = selectedteamsEK.split(';')
			}
			
			//check if one of the favourite teams is playing
			for(var x in teamsarray){
				var teamcheck = teamsarray[x].toLowerCase()
				var combiteam = homeplayer + outplayer
				combiteam = combiteam.toLowerCase()
				if((combiteam.indexOf(teamcheck) != -1)  && teamcheck.length > 2){
					if (matchstate == "PLAY"  & (sonosfound || selectedlampsbyuuid.length>2)){
						snoozevisible=true
					}
				}
			}

//check is there is a new goal
			var newscoretotal = parseInt(homescore) + parseInt(outscore)
			if (newscoretotal == 0) {oldscoretotal[matchnumber]=0}  //reset the oldscoretotal when the sum =0 (new match)
			
			//console.log("match score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
			//console.log("(newscoretotal : "  + newscoretotal)
			//console.log("(oldscoretotal[matchnumber] : "  + oldscoretotal[matchnumber])
			
			//console.log( homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
			
			if ((oldscoretotal[matchnumber] != newscoretotal) && (newscoretotal>0)){
				goalscored=true
			}else{
				goalscored=false
			}
			
				
			if ((goalscored || matchJustEnded || matchJustStarted) && !isInNotificationMode){   //notification wanted
				if ((oldhomescore[matchnumber] != homescore) && (homescore>0)){ //new goal scored this match by homeplayer
					scoringTeam = homeplayer
				}
				
				if ((oldoutscore[matchnumber] != outscore) && (outscore>0)){ //new goal scored this match by outplayer
					scoringTeam = outplayer
				}
				favscored=false

				if (!isFirstRun){
					
					console.log("voetbal new score: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
					//console.log("selectedteams: " + selectedteams)
					
//check if in the teams of the match where the goal fell one of the favourite teams is playing
					for(var x in teamsarray){
						var teamcheck = teamsarray[x].toLowerCase()
						//console.log("checking team: " + teamcheck)
						var combiteam = homeplayer + outplayer
						combiteam = combiteam.toLowerCase()
						//console.log("combi team: " + combiteam)
						if((combiteam.indexOf(teamcheck) != -1)  && teamcheck.length > 0){
//goal fell in a match where one of the favourite clubs is playing
//SPECIAL ACTION WHEN GOAL HERE!!!!!!																							
//BLINK LAMPS, CREATE SCREEN NOTIFICATION AND SONOS INTEGRATION				
							if (matchJustEnded){
								try{	
										//console.log("voetbal EINDSTAND!!!!!!!!!!!!!!!!!!!!!!!!: ")
										//console.log("Eindstand " + homeplayer + ' tegen ' + outplayer + ', is geworden ' + homescore + ' ' + outscore)
										//console.log("voetbal EINDSTAND!!!!!!!!!!!!!!!!!!!!!!!!: ")
										tscsignals.tscSignal("sonos", "Eindstand " + homeplayer + ' tegen ' + outplayer + ', is geworden ' + homescore + ' ' + outscore);
									} catch(e) {
									}
								matchJustEnded = false
							
							}
							
							if (matchJustStarted){
								try{	
										//console.log("voetbal BEGIN!!!!!!!!!!!!!!!!!!!!!!!!: ")
										//console.log("De voetbalwedstrijd " + homeplayer + ' tegen ' + outplayer + ' is begonnen')
										//console.log("voetbal BEGIN!!!!!!!!!!!!!!!!!!!!!!!!: ")
										tscsignals.tscSignal("sonos", "De voetbalwedstrijd " + homeplayer + ' tegen ' + outplayer + ' is begonnen')
									} catch(e) {
									}
								matchJustStarted = false
							}
							
							if (goalscored){
								isInNotificationMode = true
								createScreenNotification(homeplayer, outplayer, homescore, outscore)
								if (!snooze){
									blinkLamps()
									try{
										tscsignals.tscSignal("sonos", "Nieuwe tussenstand bij " + homeplayer + ' tegen ' + outplayer + ', het staat nu ' + homescore + ' ' + outscore);
									} catch(e) {
									}
								}
								goalscored = false
							}
							
						}//match of team fav in new score match
					}//for each teamsarray
				}//isFirstRun?

			} //oldscore!=newscore
			
			oldscoretotal[matchnumber] = newscoretotal
			oldhomescore[matchnumber]=homescore
			oldoutscore[matchnumber]=outscore
			matchnumber++

		}
		

		
		function createScreenNotification(homeplayer, outplayer, homescore, outscore){
		
			oldanimationRunning = animationscreen.animationRunning
			oldisVisibleinDimState = animationscreen.isVisibleinDimState
			oldanimationInterval = animationscreen.animationInterval
			oldqmlAnimationURL = animationscreen.qmlAnimationURL
			oldqmlAnimationText = animationscreen.qmlAnimationText
			oldstaticImageT1 = animationscreen.staticImageT1
    			oldstaticImageT2 = animationscreen.staticImageT2
			oldstaticImageT1dim = animationscreen.staticImageT1dim
       			oldstaticImageT2dim =animationscreen.staticImageT2dim
			
			animationscreen.animationRunning= false
				
			//console.log(" voetbal START To Write Notification: " + homeplayer + " " + homescore  + "-" + outscore + " " + outplayer)
			var setJson = {
				"teams" : homeplayer + " - " + outplayer,
				"score" : homescore + " - " + outscore
			}
			var doc = new XMLHttpRequest()
			doc.open("PUT", "file:///HCBv2/qml/apps/voetbal/newScore.json")
			doc.send(JSON.stringify(setJson))
			smallDelayTimer.running = true	
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
				for (var lampcount in lampstatus){
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
			for (var lampc in lampstatus.length) lampstatus[lampc] =""  //clear array
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
			for (var lcount in oldlampArray){
				var lampoldstatus = oldlampArray[lcount]
				var oldlampSplit=lampoldstatus.split(':')
				//console.log("New lamp States:  " + oldlampSplit[0] + "   restoring to old situation " + oldlampSplit[1])
				var msg = bxtFactory.newBxtMessage(BxtMessage.ACTION_INVOKE, oldlampSplit[0] , "SwitchPower", "SetTarget");
				msg.addArgument("NewTargetValue", oldlampSplit[1]);
				bxtClient.sendMsg(msg);
			}
		}
		
		Timer {
			id: voetbalClock   //clock to get data on a specific time and to calculate the time to next match
			interval: 30000 //30s interval
			repeat: true
			running: true
			triggeredOnStart: true
			onTriggered: {
				var now = new Date().getTime()
				timeStr = i18n.dateTime(now, i18n.time_yes)
				//console.log("time : " + timeStr)
				if (timeStr == "01:30" || timeStr == "1:30"){  //get new matches at 01:30
					//console.log("Trigger from clock ")
					for(var scrapenumber in matchstates){
						matchstates[scrapenumber]=""  //clear the matchstates array
					}
					getFirstData()
				} 
			}
		}
		
		Timer {
			id: voetbalTimer   //interval to scrape data
			interval: scrapeInterval
			repeat: true
			running: true
			triggeredOnStart: false
			onTriggered: {getData()}
		}
		
		Timer {
			id: smallDelayTimer   //delay to show the goal animation screen
			interval: 100
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				animationscreen.qmlAnimationURL= "file:///HCBv2/qml/apps/voetbal/VoetbalAnimation.qml"
				animationscreen.animationInterval= 100000
				animationscreen.isVisibleinDimState= true
				if (oldanimationRunning){
					animationscreen.staticImageT1 = oldstaticImageT1
					animationscreen.staticImageT2 = oldstaticImageT2
					animationscreen.staticImageT1dim = oldstaticImageT1dim
					animationscreen.staticImageT2dim = oldstaticImageT2
					
				}else{
					animationscreen.staticImageT1 = ""
					animationscreen.staticImageT2 = ""
					animationscreen.staticImageT1dim = ""
					animationscreen.staticImageT2dim = ""
				}
				animationscreen.animationRunning= true;
				goalTimer.running = true
				smallDelayTimer.running = false
			}
		}
		
		Timer {
			id: goalTimer   //delay to hide the new goal screen
			interval: notificationtime 
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				animationscreen.animationRunning= false
				animationscreen.qmlAnimationURL = ""
				smallDelayTimer2.running = true			
				goalTimer.running = false
			}
		}
		
		Timer {
			id: smallDelayTimer2  //delay to return to the old animation
			interval: 3000
			repeat: false
			running: false
			triggeredOnStart: false
			onTriggered: {
				if (oldanimationRunning){
					animationscreen.isVisibleinDimState = oldisVisibleinDimState
					animationscreen.animationInterval = oldanimationInterval
					animationscreen.qmlAnimationURL = oldqmlAnimationURL
					animationscreen.qmlAnimationText = oldqmlAnimationText
					animationscreen.staticImageT1 = oldstaticImageT1
					animationscreen.staticImageT2 = oldstaticImageT2
					animationscreen.staticImageT1dim = oldstaticImageT1dim
					animationscreen.staticImageT2dim = oldstaticImageT2dim
					animationscreen.animationRunning = true
				}else{
					animationscreen.animationRunning= false
					animationscreen.isVisibleinDimState= false
				}
				isInNotificationMode = false
				smallDelayTimer2.running = false
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
					for(var x1 in lampsarray){
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
				"scraperChoice" : scraperChoice,
				"Bridgeuuid" : bridgeuuid
			}
			var doc = new XMLHttpRequest()
			doc.open("PUT", "file:///mnt/data/tsc/voetbal_userSettings.json")
			doc.send(JSON.stringify(setJson))

			if (scraperChoice == "AD"){
					scraperUrl = scraperUrlAD
				}
			if (scraperChoice == "VZ"){
				scraperUrl = scraperUrlVZ
				}
			
			console.log ("2 " + scraperUrl);
			getFirstData()
			
		}
		
		
	}