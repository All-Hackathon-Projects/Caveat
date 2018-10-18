let map
let nextID = 0

//Holds a dictionary of id:marker
const markers = {}

//Initializes the google map
function initMap()
{
  map = new google.maps.Map(document.getElementById('map'),
  {
    zoom: 17,
    center: new google.maps.LatLng(41.8826, -87.6374),
    mapTypeId: 'terrain'
  });


//  let testMarker = createMarker('Robbery', '20 N Wacker Drive', 41.8826, -87.6374)
  
  const crimes = data.crimesInArea

 // console.log(crimes)
 // 
  for(let i = 0; i < 400; i++)
  {
    const crime = crimes[i]
    const crimeType = crime.genericType
    const address = crime.address
    const lat = crime.lat
    const long = crime.long
    createMarker(crimeType, address, lat, long)
  }

}


/**
 * Creates a location marker for a crime, adds it to the database, and returns it
 * @param  {String}  crimeType The type of crime
 * @param  {String}  address   Address of the crime
 * @param  {Number}  lat       Latitude
 * @param  {Number}  long      Longtitude
 * @param  {Boolean} accepted  If this marker has been accepted or not
 * @return {Marker}            A marker
 */
function createMarker(crimeType, address, lat, long, accepted=false)
{

  //Get an ID for the marker
  const id = nextID++
  //Create the marker
  const marker = new google.maps.Marker
  ({
    position: {lat: lat, lng: long},
    map: map,
    icon: 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png'
  })
  //Create the popup window
  const popupWindow = getPopupWindow(crimeType, address, lat, long, id, accepted)
  //Attach the click listener
  marker.addListener('click', function()
  {
    this.window.open(map, marker)
  })

  //Attach data to the marker
  marker.id = id
  marker.window = popupWindow

  marker.confirm = function()
  {
    this.window.close()
    this.window = getPopupWindow(crimeType, address, lat, long, id, true)
    this.window.open(marker, this)
    this.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png')
  }

  marker.reject = function()
  {
    this.window.close()
    this.window = getPopupWindow(crimeType, address, lat, long, id, true)
    this.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png')

  }

  markers[id] = marker
  return marker
}

//Returns a new popup window for a marker
function getPopupWindow(crimeType, address, lat, long, id, accepted)
{
  return new google.maps.InfoWindow
  ({
     content: getContentString(crimeType, address, lat, long, id, accepted)
  })
}

//Returns the div as a string representing the marker's window
function getContentString(crimeType, address, lat, long, id, accepted)
{
  let string = '<div id="content">'+
                  '<h1 id="firstHeading" class="firstHeading">' +
                    crimeType +
                  '</h1>'+
                  '<div id="bodyContent">'+
                    '<p>' +
                      '<b>Address </b>' + address + 
                    '</p>' +
                     '<p>' +
                      '<b>Coordinates </b>' + lat + ', ' + long + 
                    '</p>' +
                  '</div>'

                  if(!accepted)
                  {
                    string += '<div class="button-container">' + 
                                '<div class="button confirm" onclick=confirmMarker(' + id + ')>Confirm</div>' +
                                '<div class="button reject" onclick=rejectMarker(' + id + ')>Reject</div>' +
                              '</div>'
                  }
                  
                 string += '</div>'

  return string
}

function confirmMarker(id) { markers[id].confirm() }

function rejectMarker(id) { markers[id].reject() }

function deleteMarker(id)
{
  markers[id].setMap(null)
  delete markers[id]
}