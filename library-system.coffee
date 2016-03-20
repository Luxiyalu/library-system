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
        .state 'author', url: '/author', templateUrl: 'partials/author.html'
        .state 'book', url: '/', templateUrl: 'partials/book.html'
        .state 'copy', url: '/copy', templateUrl: 'partials/copy.html'
          
        .state 'member', url: '/member', templateUrl: 'partials/member.html'
        .state 'newmember', url: '/newmember', templateUrl: 'partials/member-edit.html'
        .state 'editmember', url: '/editmember/:id', templateUrl: 'partials/member-edit.html'
          
        .state 'record', url: '/record', templateUrl: 'partials/record.html'
        .state 'checkin', url: '/checkin', templateUrl: 'partials/record-edit.html', controller: 'RecordEditCtrl'
        .state 'checkout', url: '/checkout', templateUrl: 'partials/record-edit.html', controller: 'RecordEditCtrl'

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

  library.controller 'AppCtrl', new Array '$rootScope', '$scope', '$meteor', '$timeout', '$state',
    ($rootScope, $scope, $meteor, $timeout, $state) ->
      $scope.$state = $state
      $scope.$watch (-> $state.current.name), (newState) -> $scope.currentState = newState

      $scope.authors = $scope.$meteorCollection -> Authors.find {}, {sort: {createdAt: -1}}
      $scope.books = $scope.$meteorCollection -> Books.find {}, {sort: {createdAt: -1}}
      $scope.copies = $scope.$meteorCollection -> Copies.find {}, {sort: {createdAt: -1}}
      $scope.members = $scope.$meteorCollection -> Members.find {}, {sort: {createdAt: -1}}
      $scope.records = $scope.$meteorCollection -> Records.find {}, {sort: {createdAt: -1}}

      $rootScope.addItem = (arr, item) ->
        item.createdAt = new Date()
        arr.push(item)

      $rootScope.findItem = (arr, id) ->
        _.find arr, (obj) -> obj._id == id

  library.controller 'RecordEditCtrl', Array '$scope', ($scope) ->
    edit = $scope.edit = {}
    members = $scope.members
    resources = $scope.copies
    
    edit.searchMember = (query) ->
      reg = new RegExp(query, 'i')
      results = if query then _.filter(members, (m) -> "#{m.firstName} #{m.lastName} #{m._id}".match(reg)) else members
      
    edit.searchResource = (query) ->
      reg = new RegExp(query, 'i')
      results = if query then _.filter(resources, (m) -> m._id.match(reg)) else resources
      
  library.directive 'navBar', -> templateUrl: 'partials/nav-bar.html'
  library.directive 'bookEdit', -> templateUrl: 'partials/book-edit.html'
  library.directive 'memberEdit', -> templateUrl: 'partials/member-edit.html'
