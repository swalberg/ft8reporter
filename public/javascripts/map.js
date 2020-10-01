"use strict";

let map;

function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
      center: {
        lat: 38.785809,
        lng: -77.187248,
      },
      zoom: 4,
    });
  var infowindow =  new google.maps.InfoWindow({
		content: 'Hello World!',
		map: map
	});
  map.data.loadGeoJson('last_spots.json');
  map.data.addListener('click', function(event) {
    });

  // When the user hovers, tempt them to click by outlining the letters.
  // Call revertStyle() to remove all overrides. This will use the style rules
  // defined in the function passed to setStyle()
  map.data.addListener('mouseover', function(event) {
      var call = event.feature.getProperty("name");
      var sender = event.feature.getProperty("sender");
      var snr = event.feature.getProperty("snr");
      infowindow.setContent("<div style='width:150px; text-align: center;'>"+call+" de " + sender + " SNR="+snr+"</div>");
      infowindow.setPosition(event.feature.getGeometry().get());
      infowindow.setOptions({pixelOffset: new google.maps.Size(0,-30)});
      infowindow.open(map);
    });

  map.data.addListener('mouseout', function(event) {
      infowindow.close();
    });
}

$(document).ready(function() {

    $.ajax({
        url: "/calls.json",
      })
    .done(function( data ) {
        $.each(data, function(i, call) {
            $('#calls').append(
              $('<li>').append(
                $('<a>').attr('href','#').append(
                  call.callsign
                )));
          });
      });
  });
