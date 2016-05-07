(function() {
  var app;

  app = angular.module('delta-wall', []);

  app.filter('numberFixedLen', (function(_this) {
    return function() {
      return function(a, b) {
        return (1e4 + "" + a).slice(-b);
      };
    };
  })(this));

  app.filter('dateFormat', (function(_this) {
    return function() {
      return function(date) {
        return date.getFullYear() + "." + (date.getMonth() + 1) + "." + date.getDate() + " " + ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2) + "." + ("0" + date.getSeconds()).slice(-2);
      };
    };
  })(this));

  app.controller('busTimetableController', [
    '$scope', '$http', '$interval', function($scope, $http, $interval) {
      $scope.getDayIndex = function() {
        if (new UltraDate().isHoliday()) {
          return 2;
        } else if (new Date().getDay() === 6) {
          return 1;
        } else {
          return 0;
        }
      };
      $scope.getNextBusIndex = function() {
        var bus, date, i, index, len, ref;
        date = new Date();
        ref = $scope.timetable;
        for (index = i = 0, len = ref.length; i < len; index = ++i) {
          bus = ref[index];
          date.setHours(bus.h);
          date.setMinutes(bus.m);
          if (new Date().getTime() < date.getTime()) {
            return index;
          }
        }
      };
      $scope.getAbsoluteTime = function(h, m) {
        var date, lastSeconds;
        date = new Date();
        date.setHours(h);
        date.setMinutes(m);
        date.setSeconds(0);
        lastSeconds = Math.floor((date.getTime() - new Date().getTime()) / 1000);
        return [Math.floor(lastSeconds / 3600), Math.floor(lastSeconds % 3600 / 60), lastSeconds % 60];
      };
      $http.jsonp('http://hack.sfc.keioac.jp/sfcbusapi/index.php?callback=JSON_CALLBACK').success(function(response) {
        return $scope.response = response;
      });
      return $interval(function() {
        $scope.date = new Date();
        $scope.dayIndex = $scope.getDayIndex();
        $scope.timetable = $scope.response[1][$scope.dayIndex];
        return $scope.nextBusIndex = $scope.getNextBusIndex();
      }, 1000);
    }
  ]);

}).call(this);
