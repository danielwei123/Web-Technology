<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title></title>
<style>
    i {
      border: solid gray;
      border-width: 0 3px 3px 0;
      padding: 3px;
      display: inline-block;
      }

      .up {
          transform: rotate(-135deg);
          -webkit-transform: rotate(-135deg);
      }
      .down {
          transform: rotate(45deg);
          -webkit-transform: rotate(45deg);
      }

    #title{
      text-align: center;
      line-height: 0%;
      font-style: italic;
    }

    .title{
      text-align: center;
      font-size:25px;
      font-weight: bold;      
    }

    .title2{
      text-align: left;
      font-weight: bold;      
    }

    .title3{
      text-align: center;
    }

    #map {
      height:300px;
      width: 50%;
      left: 25%;
    }

    #map_2 {
      height:300px;
      width: 80%;
      left: 20%;
    }

    .inner {
      width: 50%;
      margin: 0 auto;
    }

    #p1, #p2 {
      text-align: center;
    }

    #arrow1, #arrow2 {
      margin: 0 auto;
      display: block;
    }

    #tbl, #tbl1, #tbl2, #tbl3, #row2, #row3{
      width: 80%;
      margin: 0 auto;
      border-collapse:collapse;
    }

    .pointer {cursor: pointer;}
</style>
<script>
  function resetform() {

      var child = document.getElementById("tbl"); 
      if (child != null){
          var parent = child.parentElement;
          parent.removeChild(child);
      }

      var map = document.getElementById('map');

      if (map != null){
          var map_parent = map.parentElement;
          map_parent.removeChild(map);
      }

      var select = document.getElementById("mode");
      if (select != null){
         var parent = select.parentElement;
         parent.removeChild(select);
      }

      var tbl1 = document.getElementById("tbl1");
      var tbl2 = document.getElementById("tbl2");
      var tbl3 = document.getElementById("tbl3");

      if (tbl1 != null){
          var parent = tbl1.parentElement;
          parent.removeChild(tbl1);
          parent.removeChild(tbl2);
          parent.removeChild(tbl3);
      }

      var p1 = document.getElementById("p1");
      if (p1 != null){
         var parent = p1.parentElement;
         parent.removeChild(p1);
      }

      var p2 = document.getElementById("p2");
      if (p2 != null){
         var parent = p2.parentElement;
         parent.removeChild(p2);
      }

      var arrow1 = document.getElementById("arrow1");
      if (arrow1 != null){
         var parent = arrow1.parentElement;
         parent.removeChild(arrow1);
      }

      var arrow2 = document.getElementById("arrow2");
      if (arrow2 != null){
         var parent = arrow2.parentElement;
         parent.removeChild(arrow2);
      }      

      var topic = document.getElementById("topic");
      if (topic != null){
         var parent = topic.parentElement;
         parent.removeChild(topic);
      }   


   }; 

   function resetform2(){
      resetform();
      document.getElementById("keyword1").value = "";
      document.getElementById("category1").value = "";
      document.getElementById("distance1").value = "";
      document.getElementById("location1").value = "";   
      document.getElementById("radio1").checked = true;
      document.getElementById("radio2").checked = false;
      document.getElementById("location1").required = false;

   }
</script>
</head>
<body > 

<?php
    include 'geoHash.php';
    $keyword = $category = $distance = $location = $segmentId = $event_id = $venue = $geoPoint = $lat = $lng = $lat2 = $lng2 = "";
    $event_num = 0;
    $apikey = "y3LHeageuWyHgDTk5t5lPlHNMa0rHrRy";
    $googlekey = "AIzaSyCY8Irk1vTr85Fop3NmHvG8C4K3hhYlwh4";

    if ($_SERVER["REQUEST_METHOD"] == "POST")
    {
        if (!empty($_POST["keyword"]))
        {
          $keyword = $_POST["keyword"];
          $keyword_clean = str_replace(" ", "%20", $keyword);
        }
        
        if (!empty($_POST["category"]))
        {
          $category = $_POST["category"];
        }

        if (!empty($_POST["distance"]))
        {
          $distance = $_POST["distance"];
        }
        else
        {
          $distance = 10;
        }

        if (empty($_POST["from_value"]))
        {
          $location = $_POST["from"];
        }
        else{
          $location = $_POST["from_value"];
          $location_clean = str_replace(" ", "%20", $location);
        }  

        if (!empty($_POST["pass_event_num"]))
        {
          $event_num = $_POST["pass_event_num"];
        }

        if (!empty($_POST["lat"]))
        {
          $lat = $_POST["lat"];
        }

        if (!empty($_POST["lng"]))
        {
          $lng = $_POST["lng"];
        }
      }

    switch($category){
        case "Music": $segmentId = "KZFzniwnSyZfZ7v7nJ";
        break;
        case "Sports": $segmentId = "KZFzniwnSyZfZ7v7nE";
        break;
        case "Arts & Theatre": $segmentId = "KZFzniwnSyZfZ7v7na";
        break;
        case "Film": $segmentId = "KZFzniwnSyZfZ7v7nn";
        break;
        case "Miscellaneous": $segmentId = "KZFzniwnSyZfZ7v7n1";
        break;
    }

    // echo " keyword = ".$keyword;
    // echo " category = ".$category;
    // echo " location = ".$location;
    // echo " lat = ".$lat;
    // echo " lng = ".$lng;
    // echo " venue = ".$venue;
    // echo " distance = ".$distance;

    if ($location == ""){}
    else{
        $url_google = "https://maps.googleapis.com/maps/api/geocode/json?address=".$location_clean."&key=".$googlekey;
        $str_google = file_get_contents($url_google);
        $json_google = json_decode($str_google, true);
        $lat = $json_google['results'][0]['geometry']['location']['lat'];
        $lng = $json_google['results'][0]['geometry']['location']['lng'];
    }


    $geoPoint = encode($lat, $lng);

    // echo " geoPoint = ".$geoPoint;


    $url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=%20".$apikey."%20"."&keyword=".$keyword_clean."&segmentId=".$segmentId."&radius=".$distance."&unit=miles"."&geoPoint=".$geoPoint;
    $str = file_get_contents($url);
    $json = json_decode($str, true);

    $venue = $json['_embedded']['events'][0]['_embedded']['venues'][0]['name'];
    $venue = str_replace(" ", "%20", $venue);

    $event_id = $json['_embedded']['events'][$event_num][id];

    $url2 = "https://app.ticketmaster.com/discovery/v2/events/".$event_id."?apikey=".$apikey."&";
    $str2 = file_get_contents($url2);
    $json2 = json_decode($str2, true);

    $url3 = "https://app.ticketmaster.com/discovery/v2/venues?apikey=".$apikey."&keyword=".$venue."";
    $str3 = file_get_contents($url3);
    $json3 = json_decode($str3, true);

    if ($venue == ""){
        $lat2 = $lat;
        $lng2 = $lat;
    }
    else{
        $url_google2 = "https://maps.googleapis.com/maps/api/geocode/json?address=".$venue."&key=".$googlekey;
        $str_google2 = file_get_contents($url_google2);
        $json_google2 = json_decode($str_google2, true);
        $lat2 = $json_google2['results'][0]['geometry']['location']['lat'];
        $lng2 = $json_google2['results'][0]['geometry']['location']['lng'];
    }

    // echo " lat2 = ".$lat2;
    // echo " lng2 = ".$lng2;
// echo "url3 = ".$url3;
?>

<form method="POST" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" style="border: solid gray; border-width: medium; padding: 10px;" class="inner">
   <input type="hidden" id="event_num" name="event_num"/>
   <input type="hidden" id="pass_event_num" name="pass_event_num" value="0" />
   <input type="hidden" id="p1_check" name="p1_check" value="0"/>
   <input type="hidden" id="p2_check" name="p2_check" value="0"/>
   <input type="hidden" id="map1" name="map1_check" value="0"/>
   <input type="hidden" id="select_check" name="select_check" value="0"/>
   <input type="hidden" id="select_check2" name="select_check2" value="0"/>
   <input type="hidden" id="lat" name="lat" value="0"/>
   <input type="hidden" id="lng" name="lng" value="0"/>

   <h1 id="title">Events Search</h1>
   <hr />
   <b>Keyword</b>
      <input class="form-control" type="text" name="keyword" required="True" id="keyword1" value="<?php echo $keyword;?>" >
      <br><br>
   <b>Category</b>
      <select name="category" id="category1">
         <option selected=selected value="">Default</option>
         <option value="Music" <?php echo $category == 'Music' ? 'selected' : '' ?>>Music</option>
         <option value="Sports" <?php echo $category == 'Sports' ? 'selected' : '' ?>>Sports</option>
         <option value="Art & Theatre" <?php echo $category == 'Art & Theatre' ? 'selected' : '' ?>>Art & Theatre</option>
         <option value="Film" <?php echo $category == 'Film' ? 'selected' : '' ?>>Film</option>
         <option value="Miscellaneous" <?php echo $category == 'Miscellaneous' ? 'selected' : '' ?>>Miscellaneous</option>
      </select>
      <br><br>
   <b>Distance (miles)</b> 
      <input type="text" name="distance" placeholder="10" id="distance1" value="<?php echo $distance;?>">
   <b>from</b>
      <input type="radio" name="from" id="radio1" value="" onclick="document.getElementById('location1').value='';document.getElementById('location1').required='false';document.getElementById('radio1').checked='true';document.getElementById('radio2').checked='false';" <?php if ($location==$_POST["from"] || $location=='') echo ' checked="checked"'?> >
      <b>Here</b> <br> 
      &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;

      <input type="radio" name="from" id="radio2" onclick="document.getElementById('location1').required='true';document.getElementById('radio1').checked='false';document.getElementById('radio2').checked='true';" <?php if ($location!=$_POST["from"] && $location!='') echo 'checked="checked"'?>>
      <input type="text" name="from_value" placeholder="location" id="location1" value="<?php if ($location!=$_POST["from"]) echo $location ?>" onclick="document.getElementById('radio1').checked='false';document.getElementById('radio2').checked='true';document.getElementById('location1').required='true';" >
      <br><br>

  <input type="submit" name="search" id="submit" value="Search" style="margin-left: 10%" >
  <button onclick="resetform2()">Clear</button>
  <br><br>

</form>

<script>
        function loadJSON(url) 
        {
            if (window.XMLHttpRequest)
            {// code for IE7+, Firefox, Chrome, Opera, Safari
              xmlhttp=new XMLHttpRequest();
            } 
            else 
            {// code for IE6, IE5
              xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");  
            }
            try
            {
              xmlhttp.open("GET",url,false); // "synchronous"
              xmlhttp.send();
              if (xmlhttp.status == 404){return 404}
            }
            catch (Error)
            {
              return false;
            }
            
            jsonObj= JSON.parse(xmlhttp.responseText);
            return jsonObj;
        }

        //testing

        if (document.getElementById("lat").value == 0){
          geo_url = "http://ip-api.com/json";
          jsonObj = loadJSON(geo_url);
          document.getElementById("lat").value = jsonObj.lat;
          document.getElementById("lng").value = jsonObj.lon;
        }

</script>

<script>

    var data = <?php echo json_encode($json) ?>; 
    var data2 = <?php echo json_encode($json2) ?>; 
    var data3 = <?php echo json_encode($json3) ?>; 
    var events;
    var title_array = new Array("Date", "Icon", "Event", "Genre", "Veneue");
    var Date_array = new Array();
    var Time_array = new Array();
    var image_array = new Array();
    var name_array = new Array();
    var url_array = new Array();
    var category_array = new Array();
    var venue_array = new Array();
    var id_array = new Array();
    var staticUrl_array = new Array();

    var lat_value1 = Number("<?php echo $lat ?>");
    var lng_value1 = Number("<?php echo $lng ?>");
    var lat_value2 = Number("<?php echo $lat2 ?>");
    var lng_value2 = Number("<?php echo $lng2 ?>");


    if (data.hasOwnProperty("_embedded")){

          events = data._embedded.events;
              
              // document.writeln(events[0]._embedded.venues[0].name);
              // document.writeln(events.length);

          for (var i=0;i<events.length;i++){ 

                if (events[i].dates.start.hasOwnProperty('localDate')){
                  Date_array.push(events[i].dates.start.localDate);
                }
                else{
                  Date_array.push("N/A");
                }

                if (events[i].dates.start.hasOwnProperty('localTime')){
                  Time_array.push(events[i].dates.start.localTime);
                }
                else{
                  Time_array.push("N/A");                  
                }

                if (events[i].hasOwnProperty('images')){
                  image_array.push(events[i].images[0].url);
                }
                else{
                  image_array.push("N/A");
                }

                if (events[i].hasOwnProperty('name')){
                  name_array.push(events[i].name);
                }
                else{
                  name_array.push("N/A");
                }

                if (events[i].hasOwnProperty('url')){
                  url_array.push(events[i].url);
                }
                else{
                  url_array.push("N/A");
                }
                
                if (events[i].hasOwnProperty('classifications')){
                  category_array.push(events[i].classifications[0].segment.name);
                }
                else
                {
                  category_array.push("N/A");
                }

                if (events[i].hasOwnProperty('_embedded')){
                  venue_array.push(events[i]._embedded.venues[0].name);
                  id_array.push(events[i]._embedded.id);  //event_id
                }
                else{
                  venue_array.push("N/A");
                  id_array.push("N/A");
                }
          }

    }

    if (data2.hasOwnProperty('seatmap')){
        staticUrl_array.push(data2.seatmap.staticUrl);
    }

    function generate_table() {

      var body = document.getElementsByTagName("body")[0];
      document.write("<br/>");

      if (typeof events == 'undefined'){
          var tbl = document.createElement("div");
          tbl.setAttribute('id', 'tbl');
          tbl.setAttribute('type', 'text');
          var t = document.createTextNode('No Records has been found');
          tbl.appendChild(t);          
          tbl.setAttribute("size", '100');
          tbl.setAttribute("align", "middle");
          tbl.style.border = "solid gray";
          body.appendChild(tbl);
        }

      else{
          var tbl = document.createElement("table");
          var tblBody = document.createElement("tbody");
          
          // creating all cells
          for (var i = 0; i < Date_array.length + 1; i++) {
              // creates a table row
              var row = document.createElement("tr");

              for (var j = 0; j < title_array.length; j++) {

                  var cell = document.createElement("td");
                  if (i == 0){
                    var cell = document.createElement("th");
                    var cellText = document.createTextNode(title_array[j]);
                    cell.appendChild(cellText);
                  }
                  else{
                      if (j == 1) {
                        var img = document.createElement("img");
                        img.src = image_array[i-1];
                        img.height = 30;
                        cell.setAttribute("align", "center");
                        cell.appendChild(img);
                      }
                      else if (j == 2) {
                        var ancher = document.createElement("A");
                        var t = document.createTextNode(name_array[i-1]);

                        var temp = i-1;
                        // ancher.value = temp;
                        // document.getElementById("pass_event_num").value = temp;
                        ancher.setAttribute("onclick", 'event_table()');  //  need to be modified
                        ancher.setAttribute("class", "pointer");
                        ancher.style.color = 'black';
                        ancher.appendChild(t);
                        cell.appendChild(ancher);
                      }
                      else{
                        if (j == 0) {
                          var c1 = document.createTextNode(Date_array[i-1]);
                          var c2 = document.createElement("br");
                          var c3 = document.createTextNode(Time_array[i-1]);
                          var cellText = document.createElement("div");
                          cellText.appendChild(c1);
                          cellText.appendChild(c2);
                          cellText.appendChild(c3);
                          cellText.style.textAlign="center";
                        }
                        if (j == 3) {
                          if (category_array === undefined || category_array.length == 0){
                            var cellText = document.createTextNode('N/A');
                          }
                          else{
                            var cellText = document.createTextNode(category_array[i-1]);
                          }
                        }
                        if (j == 4) {
                          if (venue_array === undefined || venue_array.length == 0){
                            var cellText = document.createTextNode('N/A');
                          }
                          else{
                            var cellText = document.createElement("A");
                            var t2 = document.createTextNode(venue_array[i-1]);
                            cellText.setAttribute("onclick", 'generate_map()'); 
                            cellText.setAttribute("class", "pointer");
                            cellText.style.color = 'black';
                            cellText.appendChild(t2);
                          }
                        }
                        cell.appendChild(cellText);
                      }
              }
              row.appendChild(cell);
            }
         
            // add the row to the end of the table body
            tblBody.appendChild(row);
          }
         
          // put the <tbody> in the <table>
          tbl.appendChild(tblBody);
          // appends <table> into <body>
          body.appendChild(tbl);
          // sets the border attribute of tbl to 2;
          tbl.setAttribute("border", "1");
          tbl.setAttribute('id', 'tbl');
        }
    }

    function generate_map(){

        var body = document.getElementsByTagName('body')[0];
        map1 = document.getElementById("map1");

        if (map1.value == 0){
            var m1 = document.createElement("div");
                m1.setAttribute("id", "map");
                m1.value = 0;

            var select = document.createElement("select");
                select.setAttribute("id", "mode");
                select.setAttribute("onclick", "change_select()");

                var opt1 = document.createElement("option");
                    opt1.value = "WALKING";
                    var text1 = document.createTextNode("Walk there");
                    opt1.appendChild(text1);
                var opt2 = document.createElement("option");
                    opt2.value = "BICYCLING";
                    var text2 = document.createTextNode("Bike there");
                    opt2.appendChild(text2);
                var opt3 = document.createElement("option");
                    opt3.value = "DRIVING";
                    var text3 = document.createTextNode("Drive there");
                    opt3.appendChild(text3);

                select.appendChild(opt1);
                select.appendChild(opt2);
                select.appendChild(opt3);

            body.appendChild(select);
            body.appendChild(m1);

            if (select_check.value == 0){
                initMap();
            }

            map1.value += 1;
            m1.hidden = false;
            select.hidden = false;
        }
        else{
          var m1 = document.getElementById("map");
          var select = document.getElementById("mode");
          if (m1.hidden == false){
            m1.hidden = true;
            select.hidden = true;
          }
          else{
            m1.hidden = false;
            select.hidden = false;
          }
        }
    }

    function change_select(){
        var select_check = document.getElementById("select_check");
        select_check.value = 1;
        var m1 = document.getElementById("map");
        m1.value = 0;
        initMap();
    }

    function change_select2(){
        var select_check = document.getElementById("select_check2");
        select_check.value = 1;
        var m2 = document.getElementById("map_2");
        m2.value = 0;
        initMap2();
    }

    function hide1(){
      var p1 = document.getElementById('p1').firstChild.firstChild;
      p1.nodeValue = 'click to show venue info';
      document.getElementById('tbl2').hidden = true;
      document.getElementById('t1').className = 'down';
      document.getElementById('p1_check').value = 0;
    }
    function show1(){
      var p1 = document.getElementById('p1').firstChild.firstChild;
      p1.nodeValue = 'click to hide venue info';
      document.getElementById('t1').className = 'up';
      document.getElementById('tbl2').hidden = false;
      document.getElementById('p1_check').value = 1;
      if (document.getElementById('p2_check').value == 1){
        hide2();
      }
    }
    function change1(){
      if (document.getElementById('p1_check').value == 0){
        show1();
      }
      else{
        hide1();
      }
    }

    function hide2(){
      var p2 = document.getElementById('p2').firstChild.firstChild;
      p2.nodeValue = 'click to show venue photos';
      document.getElementById('tbl3').hidden = true;
      document.getElementById('t2').className = 'down';
      document.getElementById('p2_check').value = 0;
    }
    function show2(){
      var p2 = document.getElementById('p2').firstChild.firstChild;
      p2.nodeValue = 'click to hide venue photos';
      document.getElementById('t2').className = 'up';
      document.getElementById('tbl3').hidden = false;
      document.getElementById('p2_check').value = 1;
      if (document.getElementById('p1_check').value == 1){
        hide1();
      }    
    }
    function change2(){
      if (document.getElementById('p2_check').value == 0){
        show2();
      }
      else{
        hide2();
      }
    }

    function initMap(){

        var m1 = document.getElementById("map");

        if (m1.value == 0){
            m1.hidden = false;

            var coord = {lat: lat_value2, lng: lng_value2};
            var map = new google.maps.Map(document.getElementById('map'), {zoom:12, center:coord});
            var marker = new google.maps.Marker({position: coord, map:map});  

            if (document.getElementById("select_check").value == 1){
                var directionsDisplay = new google.maps.DirectionsRenderer;
                var directionsService = new google.maps.DirectionsService;
                directionsDisplay.setMap(map);
                calculateAndDisplayRoute(directionsService, directionsDisplay);
                document.getElementById('mode').addEventListener('change', function() {
                    calculateAndDisplayRoute(directionsService, directionsDisplay);
                });
                marker = '';
            }
            
            m1.value = 1;        
        }
        else{
          m1.hidden = true;
          m1.value = 0;
        }
    }

    function calculateAndDisplayRoute(directionsService, directionsDisplay) {
      var selectedMode = document.getElementById('mode').value;
      directionsService.route({
          origin: {lat: lat_value1, lng: lng_value1},
          destination: {lat: lat_value2, lng: lng_value2}, 
          // Note that Javascript allows us to access the constant
          // using square brackets and a string value as its
          // "property."
          travelMode: google.maps.TravelMode[selectedMode]
        }, function(response, status) {
          if (status == 'OK') {
            directionsDisplay.setDirections(response);
          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });
    }

    function event_table() {

          resetform();

          // document.getElementById("event_num").value = temp;

          // get the reference for the body
          var body = document.getElementsByTagName("body")[0];

          var title = document.createElement("div");
          var title_text = document.createTextNode(data2.name);
          title.setAttribute("class", "title");
          title.setAttribute("id", "topic");
          title.appendChild(title_text);
          body.appendChild(title);

          // creates a <table> element and a <tbody> element
          var tbl = document.createElement("table");
              tbl.setAttribute("border", "0");
              tbl.setAttribute('id', 'tbl1');
              var tblBody = document.createElement("tbody");

              var row = document.createElement("tr");  

                  var cell = document.createElement("th");
                  cell.setAttribute("class", "title2");
                  var cellText = document.createTextNode("Date");
                  cell.appendChild(cellText);
                  row.appendChild(cell);

                  var cell = document.createElement("th");
                  cell.setAttribute("rowspan",'14');
                      if (staticUrl_array === undefined || staticUrl_array.length == 0){}
                      else{
                          var img = document.createElement("img");
                          img.src = staticUrl_array[0];
                          img.height = 350;
                          cell.appendChild(img);
                      }
                  row.appendChild(cell);
      
                  tblBody.appendChild(row);

              for (var i = 0; i < 13; i++){
                  var row = document.createElement("tr");  
                  if (i % 2 == 1){
                      var cell = document.createElement("td");
                      cell.setAttribute("class", "title2");                      
                      if (i == 1) var cellText = document.createTextNode("Artist / Team");
                      if (i == 3) var cellText = document.createTextNode("Veneue");
                      if (i == 5) var cellText = document.createTextNode("Genres");
                      if (i == 7) var cellText = document.createTextNode("Price Ranges");
                      if (i == 9) var cellText = document.createTextNode("TicketStatus");
                      if (i == 11) var cellText = document.createTextNode("Buy Ticket At");
                      cell.appendChild(cellText);
                      row.appendChild(cell);
                  }
                  else{
                      var cell = document.createElement("td");
                      var cellText = document.createTextNode("");
                      if (i == 0){
                          if (data2.hasOwnProperty('dates')){
                              cellText = document.createTextNode(data2.dates.start.localDate + " " + data2.dates.start.localTime);
                          }
                          else{
                              cellText = document.createTextNode("");                           
                          }
                              cell.appendChild(cellText); 
                      }
                      if (i == 2){
                          if (data2.hasOwnProperty('_embedded')){

                              if (data2._embedded.hasOwnProperty('attractions')){

                                  cellText1 = document.createElement("A");
                                  cellText2 = document.createElement("A");

                                  var t1 = document.createTextNode(data2._embedded.attractions[0].name);
                                  var t2 = document.createTextNode("");
                                  var t3 = document.createTextNode("");
    
                                  cellText1.setAttribute("href", data2._embedded.attractions[0].url); 
                                  cellText1.setAttribute("target", "_blank"); // open in a new window
                                  cellText1.style.textDecoration = 'none';
                                  cellText1.style.color = 'black';
                                  cellText1.appendChild(t1);
                                  cell.appendChild(cellText1);

                                  if (data2._embedded.attractions.length > 1){
                                      t2 = document.createTextNode(data2._embedded.attractions[1].name);
                                      t3 = document.createTextNode(" | ");
        
                                      cellText2.setAttribute("href", data2._embedded.attractions[1].url); 
                                      cellText2.setAttribute("target", "_blank");
                                      cellText2.style.textDecoration = 'none';
                                      cellText2.style.color = 'black';
                                      cellText2.appendChild(t2);
                                      cell.appendChild(t3);
                                      cell.appendChild(cellText2);
                                  }                          
                              }

                          }
                          else{
                              cellText = document.createTextNode("");                           
                              cell.appendChild(cellText);                            
                          }
                      }
                      if (i == 4){
                          if (data2.hasOwnProperty('_embedded')){
                              cellText = document.createTextNode(data2._embedded.venues[0].name);
                          }
                          else{
                              cellText = document.createTextNode("");
                          }
                          cell.appendChild(cellText);
                      }
                      if (i == 6){
                          if (data2.hasOwnProperty('classifications')){
                              var subGenre = "N/A";
                              var genre = "N/A";
                              var segment = "N/A";
                              var subType = "N/A";
                              var type = "N/A";

                              if (data2.classifications[0].hasOwnProperty('subGenre')){
                                  if (data2.classifications[0].subGenre.name != 'Undefined'){
                                      subGenre = data2.classifications[0].subGenre.name;
                                  }
                              }
                              if (data2.classifications[0].hasOwnProperty('genre')){
                                  if (data2.classifications[0].genre.name != 'Undefined'){
                                      genre = data2.classifications[0].genre.name;
                                  }
                              }
                              if (data2.classifications[0].hasOwnProperty('segment')){
                                  if (data2.classifications[0].segment.name != 'Undefined'){
                                      segment = data2.classifications[0].segment.name;
                                  }
                              }
                              if (data2.classifications[0].hasOwnProperty('subType')){
                                  if (data2.classifications[0].subType.name != 'Undefined'){
                                      subType = data2.classifications[0].subType.name;
                                  }
                              }
                              if (data2.classifications[0].hasOwnProperty('type')){
                                  if (data2.classifications[0].type.name != 'Undefined'){
                                      type = data2.classifications[0].type.name;
                                  }
                              }
                              
                              cellText = document.createTextNode(
                                subGenre + " | " + 
                                genre + " | " + 
                                segment + " | " + 
                                subType + " | " + 
                                type);
                          }
                          else{
                            cellText = document.createTextNode("");
                          }
                          cell.appendChild(cellText);
                      }
                      if (i == 8){
                          if (data2.hasOwnProperty('priceRanges')){
                              cellText = document.createTextNode(data2.priceRanges[0].min + " - " + data2.priceRanges[0].max + " " + data2.priceRanges[0].currency);
                          }
                          else{
                            cellText = document.createTextNode("");
                          }
                          cell.appendChild(cellText);
                      }                      
                      if (i == 10){
                          if (data2.hasOwnProperty('dates')){
                              cellText = document.createTextNode(data2.dates.status.code);
                          }
                          else{
                            cellText = document.createTextNode("");
                          }
                          cell.appendChild(cellText);
                      }
                      if (i == 12){
                          if (data2.hasOwnProperty('url')){
                              cellText = document.createElement("A");
                              var t = document.createTextNode("Ticketmaster");
                              cellText.setAttribute("href", data2.url);
                              cellText.setAttribute("target", "_blank");
                              cellText.style.textDecoration = 'none';
                              cellText.style.color = 'black';
                              cellText.appendChild(t);

                          }
                          else{
                            cellText = document.createTextNode("");
                          }
                          cell.appendChild(cellText);                          
                      }                      

                      row.appendChild(cell);                    
                  }
        
                  tblBody.appendChild(row);
              }

              // put the <tbody> in the <table>
              tbl.appendChild(tblBody);
              // appends <table> into <body>
              body.appendChild(tbl);

          var n1 = document.createElement("br");
          body.appendChild(n1);

          var p1 = document.createElement("div");
              // p1_check.value = 0 - hide ; 1 - show
              var t = document.createTextNode("click to show venue info");
              p1.setAttribute("id", "p1");
              var span = document.createElement('span');
              span.style.color = "gray";
              span.appendChild(t);
              p1.appendChild(span);
              body.appendChild(p1);

          var arrow1 = document.createElement("button");
              arrow1.setAttribute('id', 'arrow1');
              var t1 = document.createElement('i');
              t1.setAttribute('id', 't1');
              t1.setAttribute("class", "down");
              arrow1.appendChild(t1);
              arrow1.setAttribute("onclick", "change1()");
              body.appendChild(arrow1);

          var n2 = document.createElement("br");
          body.appendChild(n2);

          var tbl2 = document.createElement("table");
              tbl2.setAttribute('hidden',true);
              var tblBody2 = document.createElement("tbody");

              if  (data3.hasOwnProperty('_embedded')){
                  for (var i = 0; i < 6; i++){
                      var row2 = document.createElement("tr");  
                      var cell2 = document.createElement("th");
                      var cell22 = document.createElement("td");
                      var cellText2;
                      var cellText22;
                          if (i == 0) {
                            cellText2 = document.createTextNode("Name");
                            cellText22 = document.createTextNode(data3._embedded.venues[0].name);
                            cell22.setAttribute("class", "title3");
                          }
                          if (i == 1) {
                            cellText2 = document.createTextNode("Map");

                            cellText22 = document.createElement("div");
                            cellText22.setAttribute("id", "map_2");
                            cellText22.value = 0;

                            var select = document.createElement("select");
                                select.setAttribute("id", "mode2");
                                select.setAttribute("onclick", "change_select2()");

                                var opt1 = document.createElement("option");
                                    opt1.value = "WALKING";
                                    var text1 = document.createTextNode("Walk there");
                                    opt1.appendChild(text1);
                                var opt2 = document.createElement("option");
                                    opt2.value = "BICYCLING";
                                    var text2 = document.createTextNode("Bike there");
                                    opt2.appendChild(text2);
                                var opt3 = document.createElement("option");
                                    opt3.value = "DRIVING";
                                    var text3 = document.createTextNode("Drive there");
                                    opt3.appendChild(text3);

                                select.appendChild(opt1);
                                select.appendChild(opt2);
                                select.appendChild(opt3);
                                cell22.appendChild(select);
                          }                      
                          if (i == 2) {
                            cellText2 = document.createTextNode("Address");
                            cellText22 = document.createTextNode(data3._embedded.venues[0].address.line1);
                            cell22.setAttribute("class", "title3");

                          }                      
                          if (i == 3) {
                            cellText2 = document.createTextNode("City");
                            cellText22 = document.createTextNode(data3._embedded.venues[0].city.name + "," + data3._embedded.venues[0].state.stateCode);
                            cell22.setAttribute("class", "title3");
                          }                      
                          if (i == 4) {
                            cellText2 = document.createTextNode("Postal Code");
                            cellText22 = document.createTextNode(data3._embedded.venues[0].postalCode);
                            cell22.setAttribute("class", "title3");
                          }                      
                          if (i == 5) {
                            cellText2 = document.createTextNode("Upcoming Events");
                            cellText22 = document.createElement("A");
                            var t = document.createTextNode(data3._embedded.venues[0].name + " Tickets");
                            cellText22.setAttribute("href", data3._embedded.venues[0].url);  
                            cellText22.setAttribute("target", "_blank"); // open in a new window
                            cellText22.style.textDecoration = 'none';
                            cellText22.style.color = 'black';
                            cellText22.appendChild(t);
                            cell22.setAttribute("class", "title3");
                          }                      

                      cell2.appendChild(cellText2);
                      cell22.appendChild(cellText22);
                      row2.appendChild(cell2);
                      row2.appendChild(cell22);
                      tblBody2.appendChild(row2);                     
                  }
              }
              else{
                  var row2 = document.createElement("table");
                  row2.setAttribute("id", "row2");
                  row2.setAttribute("class", "title");
                  var t = document.createTextNode("No Venue Info Found");
                  row2.appendChild(t);
                  row2.setAttribute("border", "1");
                  tblBody2.appendChild(row2);                                       
              }

              // put the <tbody> in the <table>
              tbl2.appendChild(tblBody2);
              // appends <table> into <body>
              body.appendChild(tbl2);
              tbl2.setAttribute("border", "1");
              tbl2.setAttribute('id', 'tbl2');

          var p2 = document.createElement("div");
              // p2_check.value = 0 - hide ; 1 - show
              var t2 = document.createTextNode("click to show venue photos");
              p2.setAttribute("id", "p2");
              var span = document.createElement('span');
              span.style.color = "gray";
              span.appendChild(t2);
              p2.appendChild(span);
              body.appendChild(p2);

          var arrow2 = document.createElement("button");
              arrow2.setAttribute('id', 'arrow2');
              var t2 = document.createElement('i');
              t2.setAttribute('id', 't2');
              t2.setAttribute("class", "down");
              arrow2.appendChild(t2);
              arrow2.setAttribute("onclick", "change2()");
              body.appendChild(arrow2);

          var tbl3 = document.createElement("table");
              tbl3.setAttribute('hidden',true);
              var tblBody3 = document.createElement("tbody");

              if  ((data3.hasOwnProperty('_embedded')) && (data3._embedded.venues[0].hasOwnProperty('images'))){

                  for (var i=0; i<data3._embedded.venues[0].images.length; i++){

                      var r = document.createElement("tr");
                      var img = document.createElement("img");
                      img.src = data3._embedded.venues[0].images[i].url;
                      img.height = 300;
                      r.appendChild(img);
                      tblBody3.setAttribute("align", "center");
                      tblBody3.appendChild(r);

                  }
              }
              else{
                  var row3 = document.createElement("table");
                  row3.setAttribute("id", "row3");
                  row3.setAttribute("class", "title");
                  var t = document.createTextNode("No Venue Photos Found");
                  row3.appendChild(t);
                  row3.setAttribute("border", "1");
                  tblBody3.appendChild(row3);                                       
              }                                    
              // put the <tbody> in the <table>
              tbl3.appendChild(tblBody3);
              // appends <table> into <body>
              body.appendChild(tbl3);
              tbl3.setAttribute("border", "0");
              tbl3.setAttribute('id', 'tbl3');

              initMap2();
    }

    function initMap2(){

        var m2 = document.getElementById("map_2");

              if (m2.value == 0){
                  var coord = {lat: lat_value2, lng: lng_value2};
                  var map = new google.maps.Map(document.getElementById('map_2'), {zoom:12, center:coord});
                  var marker = new google.maps.Marker({position: coord, map:map});     

                  if (document.getElementById("select_check2").value == 1){
                    marker = '';
                    var directionsDisplay = new google.maps.DirectionsRenderer;
                    var directionsService = new google.maps.DirectionsService;
                    directionsDisplay.setMap(map);
                    calculateAndDisplayRoute2(directionsService, directionsDisplay);
                    document.getElementById('mode2').addEventListener('change', function() {
                        calculateAndDisplayRoute(directionsService, directionsDisplay);
                    });
                  }

                  m2.value = 1;        

              }
              else{
                  m2.value = 0;
              }
    }

    function calculateAndDisplayRoute2(directionsService, directionsDisplay) {
      var selectedMode = document.getElementById('mode2').value;
      directionsService.route({
          origin: {lat: lat_value1, lng: lng_value1},
          destination: {lat: lat_value2, lng: lng_value2}, 
          // Note that Javascript allows us to access the constant
          // using square brackets and a string value as its
          // "property."
          travelMode: google.maps.TravelMode[selectedMode]
        }, function(response, status) {
          if (status == 'OK') {
            directionsDisplay.setDirections(response);
          } else {
            window.alert('Directions request failed due to ' + status);
          }
        });
    }

</script>

<?php

if ($keyword != ""){
  echo "<script> generate_table() </script>";
}
?>

<script async defer
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCY8Irk1vTr85Fop3NmHvG8C4K3hhYlwh4&callback=initMap">
</script>
<script async defer
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCY8Irk1vTr85Fop3NmHvG8C4K3hhYlwh4&callback=initMap2">
</script>

</body>
</html>