function getFirstURL(selectedUrl) {
	//console.log("getFirstURL VZ")		
	getData()
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
						//console.log("responsetext :  "  + xhr2.responseText)
						
//check if it is a valid url and if the page load has succeeded									
						//<title>Voetbalzone - Actuele wedstrijden uit de populairste competities</title>
						var n301 = xhr2.responseText.indexOf('<title>') + '<title>'.length
						var n302 = xhr2.responseText.indexOf('</title>',n301)
						
						var pagetitleString = xhr2.responseText.substring(n301, n302)
						//console.log("pagetitleString: " + pagetitleString)
						if(pagetitleString.toLowerCase().indexOf("voetbalzone") > -1){

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
							var n201 = xhr2.responseText.indexOf('<div class=\"selectie-list\">')
							//console.log("n201 : " + n201 )
							var n202 = xhr2.responseText.indexOf('<span id=\"footHolder\">',n201)
							//console.log("n202 : " + n202 )
							var allmatches = xhr2.responseText.substring(n201, n202)
							//console.log("allmatches : " + allmatches )
							var compwrapperarray = allmatches.split('wedstrijdenblokkie')
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
								var elpointer =competitionblock.toLowerCase().indexOf('uefa europa')
								var totopointer =competitionblock.toLowerCase().indexOf('toto knvb-be')
								var keukenpointer =competitionblock.toLowerCase().indexOf('keuken kampioen')
								
//if selected competition is a selected Dutch competition
								if (eredivipointer>1||ekpointer>1||wkpointer>1||olypointer>1 ||clpointer>1 ||elpointer>1 ||totopointer>1 ){
										//console.log("competition found today ")
										if (eredivipointer>1 ||clpointer>1 ||elpointer>1 ||totopointer>1 ){compmodus = "club"}
										if (ekpointer>1||wkpointer>1||olypointer>1){compmodus = "land"}

										var matchDates = competitionblock.split('<li class="opmkB"')
										//console.log("matchDates :  "  + matchDates.length)
										
										for(var date in matchDates){
											var dateFoundinBlock = matchDates[date].indexOf('c-teamuitslagen\">')
											if (dateFoundinBlock>1){
												//console.log("matchDates :  "  + matchDates[date])
												var n151 = matchDates[date].indexOf('c-teamuitslagen\">') + 'c-teamuitslagen\">'.length
												//console.log("n151 : " + n151 )
												var n152 = matchDates[date].indexOf('</span>',n151)
												//console.log("n152 : " + n152 )
												var matchDate = matchDates[date].substring(n151, n152).trim()
												//console.log("matchDate :  "  + matchDate)
												
												var months = ["januari","februari","maart","april","mei","juni","juli","augustus","september","oktober","november","december"]
												var d = new Date()
												var n = d.getMonth();
												var currentMonth = months[d.getMonth()]
												var currentDay = d.getDate()
												
												//console.log("currentMonth :  "  + currentMonth)
												//console.log("currentDay :  "  + currentDay )

												var n153 = matchDate.lastIndexOf(" ")
												var foundMonth = matchDate.substring(n153,matchDate.length).trim()
												//console.log("foundMonth :  "  + foundMonth)
												
												var n154 = matchDate.indexOf(' ')+1
												//console.log("n154 : " + n154 )
												var n155 = matchDate.indexOf(' ', n154)
												//console.log("n155 : " + n155 )
												var foundDay = matchDate.substring(n154,n155).trim()
												//console.log("foundDay :  "  + foundDay)
												
												if (foundMonth == currentMonth & foundDay==currentDay){
													//console.log("Today match found!!")
													

//for each match in the competition
													var matches = matchDates[date].split('<!-- MATCH! -->')
													for(var i in matches){
														//console.log(matchDates[i])
														if (matches[i].indexOf('c-tijd')>-1){
														
															if (matchnumber>9){matchnumber = 9}
															//console.log("matches[i], competitioncount :  "  + competitioncount)
															var matchCLorEL = false

															
															var n20 = matches[i].indexOf('class=\"c-team1\"') + 'class=\"c-team1\"'.length
															var n21 = matches[i].indexOf('<a href=\"club.asp',n20) + '<a href=\"club.asp'.length
															var n22 = matches[i].indexOf('\">',n21) + '\">'.length
															var n23 = matches[i].indexOf('</a>',n22)
															homeplayer = matches[i].substring(n22, n23).trim()
															//console.log("homeplayer :  "  + homeplayer)
															
															var n30 = matches[i].indexOf('class=\"c-team2\"') + 'class=\"c-team2\"'.length
															var n31 = matches[i].indexOf('<a href=\"club.asp',n30) + '<a href=\"club.asp'.length
															var n32 = matches[i].indexOf('\">',n31) + '\">'.length
															var n33 = matches[i].indexOf('</a>',n32)
															outplayer = matches[i].substring(n32, n33).trim()
															//console.log("outplayer :  "  + outplayer)
															
															var n40 = matches[i].indexOf('<span class=\"c-tijd\">') + '<span class=\"c-tijd\">'.length
															var n41 = matches[i].indexOf('</span>',n40)
															var matchTime = matches[i].substring(n40, n41).trim()
															//console.log("matchTime :  "  + matchTime)
															eventtime = matchTime
															
															var n10 = matches[i].indexOf('class=\"c-uitslag\"') + 'class=\"c-uitslag\"'.length
															var n11 = matches[i].indexOf('<a href=\"wedstrijd.asp',n10) + '<a href=\"wedstrijd.asp'.length
															var n12 = matches[i].indexOf('\">',n11) + '\">'.length
															var n13 = matches[i].indexOf('</a>',n12)
															var score = matches[i].substring(n12, n13).trim()
															//console.log("score :  "  + score)

															matchstate = "WAITING"
															
															if(score=="-"){
																matchstate = "WAITING"
																homescore = " "																						
																outscore = " "
															}else{
																if (matches[i].indexOf('<div class="fading">')>-1){
																	matchstate = "PLAY"
																	eventtime = "bezig"

																	var n51 = score.indexOf('<div class=\"fading\">') + '<div class=\"fading\">'.length
																	var n52 = score.indexOf('<', n51)
																	var score = score.substring(n51,n52).trim()
																	
																}else{
																	matchstate = "END"
																	eventtime = "einde"
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
																//combiteam = combiteam.toLowerCase()
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
														}//correct match found
													}//end of matches
												}//date is today
											}//datefound in block
										}//each matchdate
								}//eredivisie, ek, wk, olympisch, cl or el found
							}  //next competion
						}//it is a valid scrape
					isFirstRun = false								
					matchesUpdated()
				}//xhr status = 200
			}//end of xhr2.readystate
		}//xhr onreadystate
		xhr2.send()
}
		