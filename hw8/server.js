var express = require('express');
var app = express();
var request = require('request');
var https = require('https');
var geohash = require('ngeohash');
var SpotifyWebApi = require('spotify-web-api-node');


app.use(express.static('public'));
 
app.get('/index.htm', function (req, res) {
   res.sendFile( __dirname + "/" + "index.htm" );
})
 
app.get('/process_get', function (req, res) {

    var keyword = req.query.keyword;;
    var distance = 10;
    var category = req.query.category;
    var location = req.query.location;
    var unit = req.query.unit;
    var segmentId = event_id = venue = lat = lng = geoPoint = "";
    lat = req.query.lat;
    lng = req.query.lng;

    if (req.query.distance  != 'undefined'){
      distance = req.query.distance;
    }

    switch(category){
        case "All": segmentId = "";
        break;
        case "Music": segmentId = "KZFzniwnSyZfZ7v7nJ";
        break;
        case "Sports": segmentId = "KZFzniwnSyZfZ7v7nE";
        break;
        case "Arts & Theatre": segmentId = "KZFzniwnSyZfZ7v7na";
        break;
        case "Film": segmentId = "KZFzniwnSyZfZ7v7nn";
        break;
        case "Miscellaneous": segmentId = "KZFzniwnSyZfZ7v7n1";
        break;
    }

    var event_num = 0;
    var apikey = "y3LHeageuWyHgDTk5t5lPlHNMa0rHrRy";
    var googlekey = "AIzaSyCY8Irk1vTr85Fop3NmHvG8C4K3hhYlwh4";

    var google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=" + googlekey;

    console.log(distance);
    console.log(category);

    var ticketmaster_url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=%20" 
                          + apikey + "%20&keyword=" + keyword + "&segmentId=" + segmentId + "&radius=" 
                          + distance + "&unit=" + unit + "&geoPoint=" + geoPoint;



    // ip-api; google-api
    function getLocation(location_url, fn){
        response = request(location_url, { json: true }, (err, res, body) => 
          {
          if (err) { return console.log(err); }
          fn(body);
          });
    }

    console.log(typeof req.query.location);
    console.log(req.query.location);

    if (req.query.location == 'undefined'){
      console.log('location not defined');
    }
    else {
      console.log('location is defined');
    }

    console.log("keyword: " + req.query.keyword);


    // Promise
    function test(resolve, reject) {
        setTimeout(function () {
            if (req.query.location == 'undefined') {
                // console.log('call resolve()...');
                resolve('use ip-api');
            }
            else {
                // console.log('call reject()...');
                reject('use google-api');
            }
        }, 0.001);
    }

    var p1 = new Promise(test);
    var p2 = p1.then(function (result) {
        console.log('Location not specified by user：' + result);

          geoPoint = geohash.encode(lat, lng);
          console.log("lat:" + lat);
          console.log("lng:" + lng);
          console.log("geoPoint:" + geoPoint);

          ticketmaster_url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=%20" 
                              + apikey + "%20&keyword=" + keyword + "&segmentId=" + segmentId + "&radius=" 
                              + distance + "&unit=miles" + "&geoPoint=" + geoPoint;

          https.get(ticketmaster_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                console.log(html._embedded);

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html._embedded != 'undefined') {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.001);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                   // "time":now,
                                   "keyword":keyword,
                                   "location":'here',
                                   "events":html._embedded.events,
                                   "lat": lat,
                                   "lng": lng

                                  };
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                   // "time":now,
                                   "keyword":keyword,
                                   "location":'here',
                                   "events":'N/A',
                                   "lat": lat,
                                   "lng": lng
                                  };      
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('no result');
                });
    
                console.log();


                 // res.send(response);

                // res.send(html);
              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })
        });

    var p3 = p2.catch(function (reason) {
        console.log('Location entered by user：' + reason);

        getLocation(google_url, function(coord){
          
          lat = coord.results[0].geometry.location.lat;
          lng = coord.results[0].geometry.location.lng;

          geoPoint = geohash.encode(lat, lng);
          console.log("lat:" + lat);
          console.log("lng:" + lng);
          console.log("geoPoint:" + geoPoint);

          ticketmaster_url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=%20" 
                              + apikey + "%20&keyword=" + keyword + "&segmentId=" + segmentId + "&radius=" 
                              + distance + "&unit=miles" + "&geoPoint=" + geoPoint;

          https.get(ticketmaster_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                // console.log(html._embedded);

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html._embedded != "undefined") {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.001);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                   "keyword":keyword,
                                   "location":location,
                                   "events":html._embedded.events,
                                   "lat": lat,
                                   "lng": lng
                                  };
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            // console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                   "keyword":keyword,
                                   "location":location,
                                   "events":"N/A",
                                   "lat": lat,
                                   "lng": lng                                   
                                  };
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            // console.log('no result');
                });

                console.log();

                 // res.send(response);

              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })
        })

    });

})


app.get('/photo', function (req, res) {

    var apikey = "AIzaSyDZXcr4eIGO4g3dfcckdHrxd5MmEs-hMkI";
    var CX = "012055444064624330710:uznthdxvxg0";
    var keyword = "";
    keyword = req.query.keyword;

    console.log(keyword);

    var custom_search_url = "https://www.googleapis.com/customsearch/v1?q="+ keyword + "&cx=" 
                    + CX + "&imgSize=huge&imgType=news&num=9&searchType=image&key=" + apikey;


          https.get(custom_search_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                console.log(html.items);

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html.items != "undefined") {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.002);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                   "items":html.items
                                  };
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                   "items":"N/A"
                                  };      
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('no result');
                });
    
                console.log();
              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })

})


app.get('/venue', function (req, res) {

    var apikey = "y3LHeageuWyHgDTk5t5lPlHNMa0rHrRy";
    var venue = "";
    if (req.query.venue != 'undefined'){
        venue = req.query.venue;
    }

    console.log(venue);

    var event_url = "https://app.ticketmaster.com/discovery/v2/venues?apikey=" 
                    + apikey + "&keyword=" + venue;
          https.get(event_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                console.log(typeof html._embedded);

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html._embedded != "undefined") {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.001);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                   "address": html._embedded.venues[0].address.line1,
                                   "city": html._embedded.venues[0].city.name + ', ' + html._embedded.venues[0].state.name,
                                   "phone": html._embedded.venues[0].boxOfficeInfo.phoneNumberDetail,
                                   "openHours": html._embedded.venues[0].boxOfficeInfo.openHoursDetail,
                                   "generalRule": html._embedded.venues[0].generalInfo.generalRule,
                                   "childRule": html._embedded.venues[0].generalInfo.childRule
                                  };
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                   "address": "N/A",
                                   "city": "N/A",
                                   "phone": "N/A",
                                   "openHours": "N/A",
                                   "genearlRule": "N/A",
                                   "childRule": "N/A"
                                  };      
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('no result');
                });
    
                console.log();
              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })

})


app.get('/venueid', function (req, res) {

    var apikey = "HiB8pNdBu3nGPGVv";
    var venue = "";
    if (req.query.venue != 'undefined'){
        venue = req.query.venue;
    }

    console.log(venue);

    var event_url = "https://api.songkick.com/api/3.0/search/venues.json?query=" + venue +"&apikey=" + apikey;

          https.get(event_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html.resultsPage != "undefined") {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.001);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                    "id": html.resultsPage.results.venue[0].id
                                  };

                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                    'id':'N/A'
                                  };      
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('no result');
                });
    
                console.log();
              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })

})


app.get('/nextevent', function (req, res) {

    var apikey = "HiB8pNdBu3nGPGVv";
    var id = "";
    if (req.query.id != 'undefined'){
        id = req.query.id;
    }

    console.log(id);

    var event_url = "https://api.songkick.com/api/3.0/venues/" + id + "/calendar.json?apikey="+ apikey;

          https.get(event_url,(res1)=>{
            var html = "";
            res1.on("data",(data)=>{
                html += data;
            })

            res1.on("end",()=>{
                html = JSON.parse(html);
                // console.log(html);

                var response;

                function checkResult(resolve, reject) {
                    setTimeout(function () {
                        if (html.resultsPage != "undefined") {
                            resolve('has result');
                        }
                        else {
                            reject('no result');
                        }
                    }, 0.001);
                }

                var q1 = new Promise(checkResult);
                var q2 = q1.then(function (result) {
                                  response = {
                                    "event": html.resultsPage.results.event
                                  };

                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('has result');

                });
                var q3 = q2.catch(function (reason) {
                                  response = {
                                    'event':'N/A'
                                  };      
                             res.setHeader('Content-Type', 'application/json');
                             res.header("Access-Control-Allow-Origin", "*");
                             res.header("Access-Control-Allow-Headers", "X-Requested-With");
                             res.send(response);
                            console.log('no result');
                });
    
                console.log();
              })

            }).on("error",(e)=>{
                console.log('Fail: ${e.message}')
            })

})


app.get('/spotify', function(req, res){

    var keyword = "";
    if (req.query.keyword != 'undefined'){
        keyword = req.query.keyword;
    }

    // credentials are optional
    var spotifyApi = new SpotifyWebApi({
      clientId: '4a0a71150350439b9637360661514ad9',
      clientSecret: 'defe1ff416a04f729c957454932a15d2',
      redirectUri: 'http://www.example.com/callback'
    });


  spotifyApi.clientCredentialsGrant().then(
      function(data) {
        console.log('The access token expires in ' + data.body['expires_in']);
        console.log('The access token is ' + data.body['access_token']);

        // Save the access token so that it's used in future calls
        spotifyApi.setAccessToken(data.body['access_token']);

          var response;

          spotifyApi.searchArtists(keyword)
          .then(function(data) {
                  response = {
                        'event':data.body
                      };      
                 res.setHeader('Content-Type', 'application/json');
                 res.header("Access-Control-Allow-Origin", "*");
                 res.header("Access-Control-Allow-Headers", "X-Requested-With");
                 res.send(response);
            console.log('Search artists by '+keyword, data.body);
          }, function(err) {
            console.error(err);
                 response = {
                        'event':'N/A'
                      };      
                 res.setHeader('Content-Type', 'application/json');
                 res.header("Access-Control-Allow-Origin", "*");
                 res.header("Access-Control-Allow-Headers", "X-Requested-With");
                 res.send(response);
          });


      },
      function(err) {
        console.log('Something went wrong when retrieving an access token', err);
      }
    );

})

var server = app.listen(8081, function () {

var host = server.address().address
var port = server.address().port

console.log("Url is http://%s:%s", host, port)
 
})