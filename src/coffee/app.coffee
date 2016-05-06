app = angular.module('delta-wall', [])
app.filter('numberFixedLen', ()=>(a,b)=>(1e4+""+a).slice(-b));
app.filter('dateFormat', ()=> (date)=>
  date.getFullYear() + "." + (date.getMonth() + 1) + "." + date.getDate() +
    " " + ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2) + "." + ("0" + date.getSeconds()).slice(-2)
)
app.controller('busTimetableController', ['$scope', '$http', '$interval', ($scope, $http, $interval) ->
  $scope.getDayIndex = ->
    if new UltraDate().isHoliday()
      2
    else if new Date().getDay() == 6
      1
    else
      0

  $scope.getNextBusIndex = ->
    date = new Date()
    for bus, index in $scope.timetable
      date.setHours(bus.h)
      date.setMinutes(bus.m)
      return index if new Date().getTime() < date.getTime()

  $scope.getAbsoluteTime = (h, m) ->
    lastMinutes = (h * 60 + m) - (new Date().getHours() * 60 + new Date().getMinutes())
    lastSeconds = 60 - new Date().getSeconds()
    [Math.floor(lastMinutes / 60), lastMinutes % 60 - 1, lastSeconds]

  $http.jsonp('http://hack.sfc.keioac.jp/sfcbusapi/index.php?callback=JSON_CALLBACK').success((response) ->
    $scope.response = response
  )
  $interval( ->
    $scope.date = new Date()
    $scope.dayIndex = $scope.getDayIndex()
    $scope.timetable = $scope.response[1][$scope.dayIndex] # sfc to sho
    $scope.nextBusIndex = $scope.getNextBusIndex()
  , 1000)
])
