// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
var app = angular.module('starter', ['ionic', 'firebase']);

app.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider
  .state('tab', {
      url: "/tab",
      abstract: true,
      templateUrl: "templates/tabs.html"
  })
  .state('tab.articleList', {
    url: '/articlelist',
    views: {
      'articlelist-tab': {
        templateUrl: 'templates/articlelist.html',
        controller: 'articleListController'
      }
    }
  })
  .state('tab.articleCat', {
    url: '/articlecat',
    views: {
      'articlecat-tab': {
        templateUrl: 'templates/articlecat.html',
        controller: 'articleCatController'
      }
    }
  })
  .state('tab.article1', {
    url: '/article1/:articleId',
    views: {
      'articlelist-tab': {
        templateUrl: "templates/article.display.html",
        controller: 'articleController'
      }
    }
  })
  .state('tab.article2', {
    url: '/article2/:articleId',
    views: {
      'articlecat-tab': {
        templateUrl: "templates/article.display.html",
        controller: 'articleController'
      }
    }
  })
  .state('composeArticle',{
    url: '/composearticle',
    templateUrl: 'templates/composearticle.html',
    controller: 'composeArticleController'
  });
  $urlRouterProvider.otherwise('/tab/articlelist');

});


app.run(function($ionicPlatform, $rootScope, $firebaseAuth, $firebase, $window, $ionicLoading) {
  $rootScope.baseUrl = "http://brilliant-torch-1595.firebaseio.com/";
  $rootScope.fb = new Firebase($rootScope.baseUrl);
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if(window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if(window.StatusBar) {
      StatusBar.styleDefault();
    }

    $rootScope.show = function(text) {
      $rootScope.loading = $ionicLoading.show({
        content: text ? text : 'Loading...',
        animation: 'dafe-in',
        showBackdrop: 'true',
        maxWidth: 200,
        showDelay: 0
      });
    };

    $rootScope.hide = function() {
      $ionicLoading.hide();
    };

    $rootScope.notify = function(text) {
      $rootScope.show(text);
      $window.setTimeout(function() {
        $rootScope.hide();
      }, 1999);
    };


  });
});

app.controller("articleListController", function ($rootScope,$scope,$firebaseObject, $firebaseArray) {
  $scope.list = function() {
    syncObject = $firebaseObject($rootScope.fb);

    syncObject.$bindTo($scope, "data");
    
    $scope.headlineArray = [];
    $scope.headlines = {};
    syncObject.$loaded().then(function() {
      // angular.forEach(syncObject, function(value, key) {
      //   console.log(key,value);
      // });
      $rootScope.syncObject = syncObject;
      for (var count = 0;count < syncObject["numArticles"];count++){
        $scope.headlineArray.push(count+"Headline");
      }

      $scope.headlineArray.forEach(function(element, index){
        $scope.headlines[element[0]] = syncObject[element];
      });
    });

    syncObject.$watch(function() {
      for (var count = 0;count < syncObject["numArticles"];count++){
        $scope.headlineArray.push(count+"Headline");
      }
      $scope.headlineArray.forEach(function(element, index){
        $scope.headlines[element[0]] = syncObject[element];
      });
    });
  };
});

app.controller("articleCatController", function ($rootScope,$scope,$firebaseObject) {
  $scope.list = function() {
    var syncObject = $firebaseObject($rootScope.fb);

    syncObject.$bindTo($scope, "data");
    $scope.categories = {};
    

    syncObject.$loaded().then(function() {
      // angular.forEach(syncObject, function(value, key) {
      //   console.log(key,value);
      // });
    for (var count = 0;count < syncObject["numArticles"];count++){
          thisHeadline = syncObject[count+"Headline"];
          thisArticle = syncObject[count+"Article"];
          thisId = count;
          thisCategory = syncObject[count+"Category"];
          if (thisCategory in $scope.categories){
            $scope.categories[thisCategory][thisId] = thisHeadline;
          }
          else{
            $scope.categories[thisCategory] = {};
            $scope.categories[thisCategory][thisId] = thisHeadline;
          }
        }

      syncObject.$watch(function() {
        for (var count = 0;count < syncObject["numArticles"];count++){
          thisHeadline = syncObject[count+"Headline"];
          thisArticle = syncObject[count+"Article"];
          thisId = count;
          thisCategory = syncObject[count+"Category"];
          if (thisCategory in $scope.categories){
            $scope.categories[thisCategory][thisId] = thisHeadline;
          }
          else{
            $scope.categories[thisCategory] = {};
            $scope.categories[thisCategory][thisId] = thisHeadline;
          }
        }
      });
    });
  };
});

app.controller("articleController", function ($rootScope, $scope, $firebaseObject, $stateParams) {
  $scope.viewarticle = function() {
    var syncObject = $firebaseObject($rootScope.fb);
    syncObject.$loaded().then(function() {
      $scope.title = syncObject[$stateParams["articleId"]+"Headline"];
      $scope.article = syncObject[$stateParams["articleId"]+"Article"];
      $scope.category = syncObject[$stateParams["articleId"]+"Category"];
    });
  };
});

app.controller("composeArticleController", function ($rootScope, $scope, $firebaseObject, $ionicHistory) {
  $scope.form1 = {};
  $scope.form1.articleTitle = "";
  $scope.form1.articleType = "";
  $scope.form1.articleText = "";

  syncObject = {};

  $scope.initForm = function () {
    syncObject = $firebaseObject($rootScope.fb);
    syncObject.$loaded().then(function() {
      console.log("DB loaded");
    });
  };

  $scope.goBack = function() {
    $ionicHistory.goBack();
  };

  $scope.submitArticle = function() {
    console.log($scope.form1.articleTitle);
    console.log($scope.form1.articleType);
    console.log($scope.form1.articleText);

    syncObject[(parseInt(syncObject["numArticles"])) + "Headline"] = $scope.form1.articleTitle;
    syncObject[(parseInt(syncObject["numArticles"])) + "Category"] = $scope.form1.articleType;
    syncObject[(parseInt(syncObject["numArticles"])) + "Article"] = $scope.form1.articleText;
    syncObject["numArticles"] = parseInt(syncObject["numArticles"]) + 1;

    syncObject.$save().then(function(ref){
      console.log("Yay!");
    })
  };
});