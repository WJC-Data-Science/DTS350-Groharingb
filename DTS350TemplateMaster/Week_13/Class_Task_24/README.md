Example map:

leaflet() %>%     #Base widget
  addTiles() %>%  #Add graphics element
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

options like lng and lat can be vectors.
Use dataframe$colname to easily populate them.

To override default position/zoom:
  setView(zoom=5,lat=31.51073,lng=-96.4247)

BASEMAPS

addTiles() creates map background
alternate basemaps can be loaded w/ addProviderTiles()
Preview with this page:
  http://leaflet-extras.github.io/leaflet-providers/preview/index.html

CartoDB.PositronNoLabels is the best blank map I could find
Esri.WorldGrayCanvas is also decent

MARKERS
addMarkers for basic markers.

or, you can use circle markers:
addCircleMarkers(
    radius = ~ifelse(type == "ship", 6, 10),
    color = ~pal(type),
    stroke = FALSE, fillOpacity = 0.5
  )

It's also possible to load in image icons from file
or a URL. ex:
    addMarkers(icon = ~oceanIcons[type])

awesomeIcons() for info using markers from online icon lilbraries.

POLYGONS

use addPolygons:

addPolygons(map, lng = NULL, lat = NULL, layerId = NULL,
            group = NULL, stroke = TRUE, color = "#03F", weight = 5,
            opacity = 0.5, fill = TRUE, fillColor = color, fillOpacity = 0.2,
            dashArray = NULL, smoothFactor = 1, noClip = FALSE, popup = NULL,
            popupOptions = NULL, label = NULL, labelOptions = NULL,
            options = pathOptions(), highlightOptions = NULL,
            data = getMapData(map))

maps::map(database="state") can be used for getting polys of states


LAYER TOGGLING:

add group="name" to a layer to add it to a layers group.
These can be selected by adding them to a sidepane using addLayersConrol().
Groups default to on; to start with them turned off, add 
  %>% hidegroup("name") layer.