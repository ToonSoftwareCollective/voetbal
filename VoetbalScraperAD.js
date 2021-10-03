function getFirstURL(selectedUrl) {
	//console.log("getFirstURL AD")		
	var xhr2 = new XMLHttpRequest();
	xhr2.open("GET", selectedUrl, true); //check the feeds from the webpage
	xhr2.onreadystatechange = function() {
	console.log(xhr2.readyState)		
		if (xhr2.readyState == XMLHttpRequest.DONE) {
		console.log(xhr2.status)		
			if (xhr2.status == 200) {
						//console.log("XHR READY :  ")
						//console.log("voetbal responsetext :  "  + xhr2.responseText)
						getData()
			}
		}

	}
	xhr2.send()
}

function getURL(selectedUrl) {
	//console.log("getURL")	
	//console.log("selectedUrl : " + selectedUrl)	
	var xhr2 = new XMLHttpRequest();
	xhr2.open("GET", selectedUrl, true); //check the feeds from the webpage
	xhr2.onreadystatechange = function() {
		if (xhr2.readyState == XMLHttpRequest.DONE) {
			if (xhr2.status == 200) {
						//console.log("XHR READY :  ")
						//console.log("voetbal responsetext :  "  + xhr2.responseText)
						
//check if it is a valid url and if the page load has succeeded									
						//ad.nl
						if(xhr2.responseText.toLowerCase().indexOf("ad.nl") > -1){

//Reset match vars when a new scrape is starting
							for (var i in items){ 
								items[i] =""   //clear array
							}  
																	
							sizeoftilefont=20
							calculatedfontzize-20
							showmatchesontile = false
							matchstate = ""
												
							found = 2
							matchnumber =0
							i=0
							snoozevisible = false
							
//set standard interval	
							scrapeInterval = 14400000		
							for(var scrapenumber in matchstates){
								if (matchstates[scrapenumber]==="PLAY"){
									scrapeInterval = 10000
									//console.log("a match is still playing so interval is short ")
								}
							}
							//console.log("scrapeInterval : " + scrapeInterval + "  current time : " + timeStr)

//Check from the response if there are any competitions
							//var n201 = xhr2.responseText.indexOf('<div class=\"sportcenter__holder\">')
							var n201 = xhr2.responseText.indexOf('<div class=\"sportcenter__match-table\">')
							//console.log("n201 : " + n201 )
							var n202 = xhr2.responseText.indexOf('<footer class=\"page-main-footer\"',n201)
							//console.log("n202 : " + n202 )
							var allmatches = xhr2.responseText.substring(n201, n202)
							//console.log("allmatches : " + allmatches )
							var compwrapperarray = allmatches.split('<div class=\"sportcenter__match-table\">')
							//console.log("compwrapperarray.length: " + compwrapperarray.length)

//for each competion
							for(var competitioncount in compwrapperarray){								
												var competitionblock = compwrapperarray[competitioncount]
												//console.log("competitionblock :  "  + competitionblock)
												found = 2
												var eredivipointer = competitionblock.toLowerCase().indexOf('eredivisie') 
												//var eredivipointer = competitionblock.toLowerCase().indexOf('premier') 
												var ekpointer =competitionblock.toLowerCase().indexOf('europees') 
												var wkpointer =competitionblock.toLowerCase().indexOf('wereldkamp') 
												var olypointer =competitionblock.toLowerCase().indexOf('olympische')
												var clpointer =competitionblock.toLowerCase().indexOf('champions league')
												var elpointer =competitionblock.toLowerCase().indexOf('europa league')
												var totopointer =competitionblock.toLowerCase().indexOf('toto knvb-be')
												var keukenpointer =competitionblock.toLowerCase().indexOf('keuken kampioen')
												
//if selected competition is a selected Dutch competition
												if (eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 ||clpointer>1 ||elpointer>1 ||totopointer>1 ){
													//console.log("competition found today ! ")
													if (eredivipointer>1 ||clpointer>1 ||elpointer>1 ||totopointer>1 ){compmodus = "club"}
													if (ekpointer>1||wkpointer>1||olypointer>1){compmodus = "land"}
		
//for each match in the competition
													var matches = competitionblock.split('<a class=\"sportcenter__match-item link')
													for(var i in matches){
													    //console.log(matches[i])
														//found = matches[i].indexOf('sportcenter__match-item')
														//found = 2
														if (matches[i].indexOf('sportcenter__match-item')>-1){
															//console.log("sportcenter__match-item found ")
															if (matchnumber>9){matchnumber = 9}
															//console.log("matches[i], competitioncount :  "  + competitioncount)
															var matchCLorEL = false

															var n20 = matches[i].indexOf('<div class=\"sportcenter__match-item__side is-home-side\">') + '<div class=\"sportcenter__match-item__side is-home-side\">'.length
															var n21 = matches[i].indexOf('<span class=\"sportcenter__match-item__side-title\">', n20) + '<span class=\"sportcenter__match-item__side-title\">'.length
															var n22 = matches[i].indexOf('</span>',n21)
															homeplayer = matches[i].substring(n21, n22).trim()
															//console.log("homeplayer :  "  + homeplayer)
															
															var n30 = matches[i].indexOf('<div class=\"sportcenter__match-item__side is-away-side\">') + '<div class=\"sportcenter__match-item__side is-away-side\">'.length
															var n31 = matches[i].indexOf('<span class=\"sportcenter__match-item__side-title\">', n30) + '<span class=\"sportcenter__match-item__side-title\">'.length
															var n32 = matches[i].indexOf('</span>',n31)
															outplayer = matches[i].substring(n31, n32).trim()
															//console.log("outplayer :  "  + outplayer)
															
/*
Wedstrijd bezig

	<div class="sportcenter__match-item__timer">
		<div class="sportcenter__match-item__timer-description">
			
			<div class="sportcenter__match-item__timer-description__time">
				<span>39&#39;</span>
			</div>
			
		</div>
		<div class="sportcenter__match-item__timer-score is-score">
			<div class="sportcenter__match-item__timer-score-card">
				<span>0-0</span>
			</div>
		</div>
	</div>

Rust

<div class="sportcenter__match-item__timer">
		<div class="sportcenter__match-item__timer-description">
			
			<div class="sportcenter__match-item__timer-description__time">
				<span>RUST</span>
			</div>
			
		</div>
		<div class="sportcenter__match-item__timer-score is-score">
			<div class="sportcenter__match-item__timer-score-card has-score-home">
				<span>1-0</span>
			</div>
		</div>
	</div>


Wachten op wedstrijd

<div class="sportcenter__match-item__timer">
		<div class="sportcenter__match-item__timer-description">
			<div class="sportcenter__match-item__timer-description__status">
				<span></span>
			</div>
			
			
		</div>
		<div class="sportcenter__match-item__timer-score is-time">
			<div class="sportcenter__match-item__timer-score-card">
				<span>18:45</span>
			</div>
		</div>
	</div>


*/
															
															
															var matchTime = ""
															if (matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score is-time\">')>-1){
															//we are waiting for a match, time is given
																var n40 = matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score is-time\">') + '<div class=\"sportcenter__match-item__timer-score is-time\">'.length
																var n41 = matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score-card', n40) + '<div class=\"sportcenter__match-item__timer-score-card'.length
																var n42 = matches[i].indexOf('<span>', n41) + '<span>'.length
																var n43 = matches[i].indexOf('</span>',n42)
																matchTime = matches[i].substring(n42, n43).trim()
																//console.log("matchTime :  "  + matchTime)
															
															}
															
															eventtime = matchTime
															
															var score="999-999"
															if (matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score is-score\">')>-1){
															//score is given
																var n60 = matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score is-score\">') + '<div class=\"sportcenter__match-item__timer-score is-score\">'.length
																var n61 = matches[i].indexOf('<div class=\"sportcenter__match-item__timer-score', n60) + '<div class=\"sportcenter__match-item__timer-score'.length
																var n62 = matches[i].indexOf('<span>', n61) + '<span>'.length
																var n63 = matches[i].indexOf('</span>',n62)
																score = matches[i].substring(n62, n63).trim()
																//console.log("score :  "  + score)
															}
															
															var timeDescr=""
															if (matches[i].indexOf('<div class=\"sportcenter__match-item__timer-description__time\">')>-1){
															//score is given
																var n70 = matches[i].indexOf('<div class=\"sportcenter__match-item__timer-description__time\">') + '<div class=\"sportcenter__match-item__timer-description__time\">'.length
																var n71 = matches[i].indexOf('<span>', n70) + '<span>'.length
																var n72 = matches[i].indexOf('</span>', n71)
																timeDescr = matches[i].substring(n71, n72).trim()
																//console.log("timeDescr :  "  + timeDescr)
																if (timeDescr.indexOf('&#')>-1){
																	timeDescr = timeDescr.split('&#39;')[0]
																}
															}

															matchstate = "WAITING"
															//homescore = "0"
															//outscore =  "0"
															
															//console.log("homeplayer :  "  + homeplayer)
															//console.log("outplayer :  "  + outplayer)
															//console.log("matchTime :  "  + matchTime)
															//console.log("score :  "  + score)
															//console.log("timeDescr :  "  + timeDescr)
															
															
															if(score=="999-999" & eventtime.length>1){
																matchstate = "WAITING"
																homescore = " "																						
																outscore = " "
																//console.log("Waiting")
															}else{
																if (matches[i].indexOf('&#')>-1){
																	matchstate = "PLAY"
																	eventtime = timeDescr
																	//console.log("Playing")
																}else if(matches[i].indexOf('RUST')>-1){
																	matchstate = "PLAY"
																	eventtime = "rust"
																}else{
																	matchstate = "END"
																	eventtime = "einde"
																	//console.log("Ended")
																}
																var scoreArray = score.split("-")
																homescore = parseInt(scoreArray[0].trim())
																//console.log("homescore :  "  + homescore)																						
																outscore = parseInt(scoreArray[1].trim())	
																//console.log("outscore :  "  + outscore)
															}
															
															
//only add CL and EL matches when they are teams playing in the Dutch Competition																
															if (clpointer>-1 || elpointer>-1){
																var combiteam = homeplayer + outplayer
																combiteam = combiteam.toLowerCase()
																var teamsCLandELarray = teamsCLandEL.split(';')
																for(var teamnumber in teamsCLandELarray){
																	var teamcheck = teamsCLandELarray[teamnumber].toLowerCase()
																	//console.log("teamcheck : " + teamcheck )
																	if((combiteam.toLowerCase().indexOf(teamcheck) > -1) && teamcheck.length > 0){
//when the teamname is short make an exact match																				
																		if((teamcheck.length < 3 & (homeplayer.toLowerCase()==teamcheck  || outplayer.toLowerCase()==teamcheck)) || (teamcheck.length >= 3 )){
																			matchCLorEL = true
																			//console.log("match found : " + matchnumber + " / " + homeplayer + " " + outplayer )
																		}
																	}
																}
															}
															
															//console.log("matchCLorEL : " + matchCLorEL )
//when it is a valid match, do actions
															if (eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 ||totopointer>1 || matchCLorEL){
																doTakeActions()
															}

															}//row found
														}//end of while

													}//eredivisie, ek, wk, olympisch, cl or el found
										}  //next competion
									}//it is a valid scrape
								isFirstRun = false								
								matchesUpdated()

//options to show testtime on tile
//var now2 = new Date().getTime()
//var timeStr2 = i18n.dateTime(now2, i18n.time_yes)
//tileButtonInterval = scrapeInterval/1000 + "s from " + timeStr2
						}//xhr status = 200
					}//end of xhr2.readystate
				}//xhr onreadystate
					
				xhr2.send()
}
