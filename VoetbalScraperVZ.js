//Scraper for https://www.voetbalzone.nl/actuele-wedstrijden
//09-2026: rewritten for the new voetbalzone website (server side rendered React page, "fco-" css classes)
//
//Structure of the page (only the parts that are used):
//
//	<a class="fco-competition-section__header" href="/competities/eredivisie/akmkihra9ruad09ljapsm84b3">
//		<span class="fco-competition-section__header-name">Eredivisie</span>
//		<span class="fco-competition-section__header-area">Nederland</span>
//	</a>
//	<div class="fco-match-list-item" data-match-id="XouRLI70twiuJ1VQdtfUu" data-match-period="FIRST_HALF" data-match-status="LIVE">
//		<div class="fco-match-team" data-side="team-a" ...><div class="fco-team-name fco-full-name">FC Groningen</div>...</div>
//		<div class="fco-team-score" data-side="team-a"><div class="fco-team-score__value">1</div></div>         (only when LIVE or RESULT)
//		<div class="fco-match-team" data-side="team-b" ...><div class="fco-team-name fco-full-name">FC Twente</div>...</div>
//		<div class="fco-team-score" data-side="team-b"><div class="fco-team-score__value">0</div></div>
//		<time class="fco-match-start-time" dateTime="2026-09-06T10:15:00.000Z">12:15</time>                   (only when not started)
//		<div class="fco-match-minutes"><div class="fco-match-minutes__value" style="...">41&#x27;</div></div>  (only when playing)
//		<div class="fco-match-status">R</div>                                                                  (R = rust, FT = einde, UITG = uitgesteld, AFG = afgelast)
//	</div>
//
//	data-match-status : FIXTURE, LIVE, RESULT, POSTPONED, CANCELLED
//	data-match-period : FIRST_HALF, HALF_TIME, SECOND_HALF, ... (only when LIVE)
//
//The page only contains the matches of today, so no date check is needed anymore.

//id of the (men's) Eredivisie in the competition link. The women's Eredivisie has the same name "Eredivisie" but another id.
var vzMenEredivisieId = "akmkihra9ruad09ljapsm84b3"

function getFirstURL(selectedUrl) {
	//console.log("getFirstURL VZ")
	getData()
}

//text between startMarker and endMarker, searched from fromIndex. "" when not found
function vzTextBetween(source, startMarker, endMarker, fromIndex) {
	var s = source.indexOf(startMarker, fromIndex ? fromIndex : 0)
	if (s < 0) return ""
	s = s + startMarker.length
	var e = source.indexOf(endMarker, s)
	if (e < 0) return ""
	return source.substring(s, e).trim()
}

//inner text of the tag that contains marker: the text between the first '>' after marker and the next '<'. "" when not found
function vzInner(source, marker, fromIndex) {
	var s = source.indexOf(marker, fromIndex ? fromIndex : 0)
	if (s < 0) return ""
	s = source.indexOf('>', s)
	if (s < 0) return ""
	var e = source.indexOf('<', s + 1)
	if (e < 0) return ""
	return source.substring(s + 1, e).trim()
}

//decode the html entities that can occur in team and competition names
function vzDecode(text) {
	return text.split('&amp;').join('&').split('&#x27;').join("'").split('&#39;').join("'").split('&quot;').join('"').split('&nbsp;').join(' ')
}

//true when word is a separate word in text (text and word in lowercase)
function vzHasWord(text, word) {
	var padded = " " + text.split('-').join(' ') + " "
	return padded.indexOf(" " + word + " ") > -1
}

function getURL(selectedUrl) {
	//console.log("getURL VZ")
	//console.log("selectedUrl : " + selectedUrl)
	var xhr2 = new XMLHttpRequest();
	xhr2.open("GET", selectedUrl, true); //check the feeds from the webpage
	xhr2.onreadystatechange = function() {
		if (xhr2.readyState == XMLHttpRequest.DONE) {
			if (xhr2.status == 200) {
				var page = xhr2.responseText
				//console.log("XHR READY :  ")

//check if it is a valid url and if the page load has succeeded
				//<title data-next-head="">Live voetbalwedstrijden, tussenstanden en uitslagen | Voetbalzone</title>
				var pagetitleString = vzInner(page, '<title')
				//console.log("pagetitleString: " + pagetitleString)
				if (pagetitleString.toLowerCase().indexOf("voetbalzone") > -1 && (page.indexOf('fco-match-list') > -1 || page.indexOf('fco-calendar-day') > -1)) {

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
					var compHeaderMarker = '<a class="fco-competition-section__header"'
					var n201 = page.indexOf(compHeaderMarker)
					//console.log("n201 : " + n201 )
					if (n201 > -1) {
						var n202 = page.indexOf('</main>', n201)
						if (n202 < 0) n202 = page.length
						var allmatches = page.substring(n201, n202)
						var compwrapperarray = allmatches.split(compHeaderMarker)
						//console.log("compwrapperarray.length: " + compwrapperarray.length)

						//when the men's Eredivisie is on the page, other competitions called "Eredivisie" (women) are skipped
						var hasMenEredivisie = allmatches.indexOf('/competities/eredivisie/' + vzMenEredivisieId) > -1
						var processedMatchIds = ";"

//for each competition (element 0 is the part before the first competition header)
						for (var competitioncount = 1; competitioncount < compwrapperarray.length; competitioncount++) {
							var competitionblock = compwrapperarray[competitioncount]
							var comphref = vzTextBetween(competitionblock, 'href="', '"').toLowerCase()
							var compname = vzDecode(vzInner(competitionblock, 'fco-competition-section__header-name"')).toLowerCase()
							var comparea = vzDecode(vzInner(competitionblock, 'fco-competition-section__header-area"')).toLowerCase()
							//console.log("competition : " + compname + " | " + comparea + " | " + comphref)
							found = 2

							var isEredivisie = false
							var isBeker = false
							var isCL = false
							var isEL = false
							var isConf = false
							var isEK = false
							var isWK = false
							var isOly = false

							//youth, women and qualification competitions are not shown
							var skipComp = (compname.indexOf('vrouwen') > -1 || compname.indexOf('women') > -1 || compname.indexOf('jeugd') > -1 || compname.indexOf('youth') > -1
											|| compname.indexOf('u21') > -1 || compname.indexOf('u19') > -1 || compname.indexOf('u17') > -1 || compname.indexOf('beloften') > -1
											|| compname.indexOf('kwalificatie') > -1 || compname.indexOf('qualif') > -1)

							if (!skipComp) {
								if (compname.indexOf('eredivisie') > -1) {
									isEredivisie = true
									if (hasMenEredivisie && comphref.indexOf(vzMenEredivisieId) < 0) {
										isEredivisie = false  //another competition with the same name (women)
									}
								}
								if (compname.indexOf('knvb') > -1 && compname.indexOf('beker') > -1) {isBeker = true}  //TOTO KNVB Beker
								if (compname.indexOf('champions league') > -1 && compname.indexOf('caf') < 0 && compname.indexOf('afc') < 0 && compname.indexOf('concacaf') < 0 && compname.indexOf('women') < 0) {isCL = true}
								if (compname.indexOf('europa league') > -1) {isEL = true}
								if (compname.indexOf('conference league') > -1) {isConf = true}
								if (compname.indexOf('europees kampioenschap') > -1 || vzHasWord(compname, 'ek') || compname.indexOf('euro 20') > -1) {isEK = true}
								if (compname.indexOf('club') < 0 && (compname.indexOf('wereldkampioenschap') > -1 || vzHasWord(compname, 'wk') || compname.indexOf('world cup') > -1)) {isWK = true}
								if (compname.indexOf('olympische') > -1 || compname.indexOf('olympic') > -1) {isOly = true}
							}

//if selected competition is a selected Dutch competition
							if (isEredivisie || isBeker || isCL || isEL || isConf || isEK || isWK || isOly) {
								//console.log("competition found today : " + compname)
								if (isEK || isWK || isOly) {compmodus = "land"} else {compmodus = "club"}

//for each match in the competition (element 0 is the competition header)
								var matches = competitionblock.split('<div class="fco-match-list-item"')
								for (var m = 1; m < matches.length; m++) {
									var match = matches[m]

									var matchId = vzTextBetween(match, 'data-match-id="', '"')
									if (matchId.length > 0) {
										if (processedMatchIds.indexOf(";" + matchId + ";") > -1) {
											continue  //same match already found in another block of the page
										}
										processedMatchIds = processedMatchIds + matchId + ";"
									}

									var matchStatus = vzTextBetween(match, 'data-match-status="', '"')   //FIXTURE, LIVE, RESULT, POSTPONED, CANCELLED
									var matchPeriod = vzTextBetween(match, 'data-match-period="', '"')   //FIRST_HALF, HALF_TIME, SECOND_HALF, ...
									var statusText = vzInner(match, 'class="fco-match-status"')           //R, FT, UITG, AFG
									if (matchStatus == "POSTPONED" || matchStatus == "CANCELLED" || statusText == "UITG" || statusText == "AFG") {
										continue  //no match today
									}

									if (matchnumber>9){matchnumber = 9}
									var matchCLorEL = false

									var teamA = match.indexOf('data-side="team-a"')
									var teamB = match.indexOf('data-side="team-b"')
									if (teamA < 0 || teamB < 0) {
										continue
									}
									homeplayer = vzDecode(vzInner(match, 'fco-full-name"', teamA))
									outplayer = vzDecode(vzInner(match, 'fco-full-name"', teamB))
									//console.log("homeplayer :  "  + homeplayer)
									//console.log("outplayer :  "  + outplayer)

									//score per team, "" when the match has not started
									var scoreA = vzInner(match, 'fco-team-score__value"', teamA)
									var scoreB = vzInner(match, 'fco-team-score__value"', teamB)

									//start time as shown on the page (Dutch time), e.g. 12:15
									var matchTime = vzInner(match, '<time class="fco-match-start-time"')
									//console.log("matchTime :  "  + matchTime)

									//minutes played, e.g. 41&#x27; or 90+3&#x27;
									var minutes = vzInner(match, 'fco-match-minutes__value"')
									minutes = minutes.split('&')[0].split("'")[0].trim()

									matchstate = "WAITING"
									eventtime = matchTime
									homescore = " "
									outscore = " "

									if (matchStatus == "LIVE") {
										matchstate = "PLAY"
										if (matchPeriod == "HALF_TIME" || statusText == "R") {
											eventtime = "rust"
										} else if (minutes.length > 0) {
											eventtime = minutes + "'"
										} else {
											eventtime = "bezig"
										}
									} else if (matchStatus == "RESULT" || statusText == "FT") {
										matchstate = "END"
										eventtime = "einde"
									} else if (matchStatus != "FIXTURE" && scoreA.length > 0 && scoreB.length > 0) {
										//unknown status but there is a score, so the match is being played
										matchstate = "PLAY"
										eventtime = "bezig"
									}

									if (matchstate != "WAITING") {
										homescore = parseInt(scoreA)
										outscore = parseInt(scoreB)
										if (isNaN(homescore)) {homescore = 0}
										if (isNaN(outscore)) {outscore = 0}
									}
									//console.log("match : " + homeplayer + " " + homescore + "-" + outscore + " " + outplayer + " | " + matchstate + " | " + eventtime)

//only add CL, EL and Conference League matches when they are teams playing in the Dutch Competition
									if (isCL || isEL || isConf) {
										var combiteam = (homeplayer + " " + outplayer).toLowerCase()
										var teamsCLandELarray = teamsCLandEL.split(';')
										for (var teamnumber in teamsCLandELarray) {
											var teamcheck = teamsCLandELarray[teamnumber].toLowerCase().trim()
											if (teamcheck.length > 0 && combiteam.indexOf(teamcheck) > -1) {
//when the teamname is short (AZ) make a whole word match (InternAZionale)
												if (teamcheck.length >= 3 || vzHasWord(homeplayer.toLowerCase(), teamcheck) || vzHasWord(outplayer.toLowerCase(), teamcheck)) {
													matchCLorEL = true
													//console.log("match found : " + matchnumber + " / " + homeplayer + " " + outplayer )
												}
											}
										}
									}

//when it is a valid match, do actions
									if (isEredivisie || isBeker || isEK || isWK || isOly || matchCLorEL) {
										doTakeActions()
									}
								}//end of matches
							}//eredivisie, beker, ek, wk, olympisch, cl, el or conference found
						}//next competition
					}//competitions found on the page
				}//it is a valid scrape
				isFirstRun = false
				matchesUpdated()
			}//xhr status = 200
		}//end of xhr2.readystate
	}//xhr onreadystate
	xhr2.send()
}
