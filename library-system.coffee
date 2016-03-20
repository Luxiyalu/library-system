Authors = new Mongo.Collection('authors')
Books = new Mongo.Collection('books')
Copies = new Mongo.Collection('copies')
Members = new Mongo.Collection('members')
Records = new Mongo.Collection('records') # check in/out activities

if Meteor.isClient
  library = angular.module('library', ['angular-meteor', 'ui.router', 'ngMaterial'])

  library.config new Array '$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdIconProvider',
    ($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdIconProvider) ->

      $stateProvider
        .state 'author',
          url: '/author'
          templateUrl: 'partials/author.html'
        .state 'book',
          url: '/'
          templateUrl: 'partials/book.html'
        .state 'copy',
          url: '/copy'
          templateUrl: 'partials/copy.html'
        .state 'member',
          url: '/member'
          templateUrl: 'partials/member.html'
        .state 'newmember',
          url: '/newmember'
          templateUrl: 'partials/member-edit.html'
        .state 'editmember',
          url: '/editmember/:id'
          templateUrl: 'partials/member-edit.html'

      # $urlRouterProvider.otherwise('book')

      $mdThemingProvider.theme('default')
        .primaryPalette('blue')
        .accentPalette('blue-grey')
        .warnPalette('orange')
        
      $mdIconProvider
        .iconSet("action", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-action.svg")
        .iconSet("content", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-content.svg")
        # .iconSet("editor", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-social.svg")
        # .iconSet("communication", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-communication.svg")
        # .iconSet("toggle", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-toggle.svg")
        # .iconSet("navigation", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-navigation.svg")
        # .iconSet("image", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-image.svg");

      return

  library.controller 'AppCtrl', new Array '$scope', '$meteor', '$timeout', '$state',
    ($scope, $meteor, $timeout, $state) ->
      $scope.$state = $state
      $scope.$watch (-> $state.current.name), (newState) -> $scope.currentState = newState

      $scope.authors = $scope.$meteorCollection -> Authors.find {}, {sort: {createdAt: -1}}
      $scope.books = $scope.$meteorCollection -> Books.find {}, {sort: {createdAt: -1}}
      $scope.copies = $scope.$meteorCollection -> Copies.find {}, {sort: {createdAt: -1}}
      $scope.members = $scope.$meteorCollection -> Members.find {}, {sort: {createdAt: -1}}

      $scope.addItem = (arr, item) ->
        item.createdAt = new Date()
        arr.push(item)

      $scope.findItem = (arr, id) ->
        _.find arr, (obj) -> obj._id == id

  # library.controller 'AuthorCtrl', () ->
  # library.controller 'BookCtrl', Array '$scope', ($scope) ->
  # library.controller 'CopyCtrl', () ->
    
  library.directive 'navBar', -> templateUrl: 'partials/nav-bar.html'
  library.directive 'bookEdit', -> templateUrl: 'partials/book-edit.html'
  library.directive 'memberEdit', -> templateUrl: 'partials/member-edit.html'
