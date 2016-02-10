Authors = new Mongo.Collection('authors')
Books = new Mongo.Collection('books')
Copies = new Mongo.Collection('copies')
Members = new Mongo.Collection('members')
Records = new Mongo.Collection('records') # check in/out activities

if Meteor.isClient
  angular.module('library', ['angular-meteor', 'ui.router', 'ngMaterial'])

  angular.module('library').config ($stateProvider, $urlRouterProvider, $mdThemingProvider) ->

    $stateProvider
      .state 'author',
        url: '/author'
        templateUrl: 'partials/author.html'
        controller: 'AuthorCtrl'
      .state 'book',
        url: '/'
        templateUrl: 'partials/book.html'
        controller: 'BookCtrl'
      .state 'copy',
        url: '/copy'
        templateUrl: 'partials/copy.html'
        controller: 'CopyCtrl'

    $urlRouterProvider.otherwise('book')

    $mdThemingProvider.theme('default')
      .primaryPalette('blue')
      .accentPalette('blue-grey')
      .warnPalette('orange')

    return

  angular.module('library').controller 'AppCtrl', ($scope, $meteor, $timeout) ->
    $scope.authors = $scope.$meteorCollection ->
      return Authors.find {}, {sort: {createdAt: -1}}
    $scope.books = $scope.$meteorCollection ->
      return Books.find {}, {sort: {createdAt: -1}}
    $scope.copies = $scope.$meteorCollection ->
      return Copies.find {}, {sort: {createdAt: -1}}

    $scope.addItem = (arr, item) ->
      item.createdAt = new Date()
      arr.push(item)

    $scope.findItem = (arr, id) ->
      _.find arr, (obj) -> obj._id == id

  angular.module('library').controller 'AuthorCtrl', ($scope, $meteor) ->
  angular.module('library').controller 'BookCtrl', ($scope, $meteor) ->
  angular.module('library').controller 'CopyCtrl', ($scope, $meteor) ->