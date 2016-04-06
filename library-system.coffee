Authors = new Mongo.Collection('authors')
Books = new Mongo.Collection('books')
Copies = new Mongo.Collection('copies')
Members = new Mongo.Collection('members')
Records = new Mongo.Collection('records') # check in/out activities

if Meteor.isClient
  library = angular.module('library', ['angular-meteor', 'ui.router', 'ngMaterial', 'angularMoment', 'accounts.ui'])

  library.config new Array '$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdIconProvider',
    ($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdIconProvider) ->
      # $urlRouterProvider.otherwise('book')
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
        .state 'report', url: '/report', templateUrl: 'partials/report.html', controller: 'ReportCtrl'
        # .state 'receipt', url: '/receipt', templateUrl: 'partials/receipt.html'
        .state 'receipt', url: '/receipt', templateUrl: 'partials/receipt.html', controller: 'ReceiptCtrl'
        

      $mdThemingProvider.theme('default')
        .primaryPalette('blue')
        .accentPalette('blue-grey')
        .warnPalette('orange')
        
      $mdIconProvider
        .iconSet("action", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-action.svg")
        .iconSet("content", "/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/svg-sprite-content.svg")

      return

  library.controller 'AppCtrl', new Array '$rootScope', '$scope', '$meteor', '$timeout', '$state',
    ($rootScope, $scope, $meteor, $timeout, $state) ->
      $scope.$state = $state
      $scope.$watch (-> $state.current.name), (newState) -> $scope.currentState = newState
      $scope.overdueSetting = -10
      $scope.user = Meteor.user

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

  library.controller 'RecordEditCtrl', Array '$scope', '$rootScope', '$state', ($scope, $rootScope, $state) ->
    edit = $scope.edit = {}
    members = $scope.members
    resources = $scope.copies
    
    edit.searchMember = (query) ->
      reg = new RegExp(query, 'i')
      results = if query then _.filter(members, (m) -> "#{m.firstName} #{m.lastName} #{m._id}".match(reg)) else members
      
    edit.searchResource = (query) ->
      reg = new RegExp(query, 'i')
      results = if query then _.filter(resources, (m) -> m._id.match(reg)) else resources

    $scope.submit = (record) ->
      $scope.addItem($scope.records, record)
      console.log record
      $rootScope.record = record
      $state.go('receipt', recordId: record._id);

  library.controller 'ReceiptCtrl', Array '$scope', '$state', ($scope, $state) ->
    $scope.record = $scope.record || $scope.records[0]
    $scope.copy = $scope.findItem($scope.copies, $scope.record.resourceId)
    $scope.book = $scope.findItem($scope.books, $scope.copy.bookId)
    $scope.member = $scope.findItem($scope.members, $scope.record.memberId)
    $scope.author = $scope.findItem($scope.authors, $scope.book.authorId)
    $scope.print = -> window.print()

  library.controller 'ReportCtrl', Array '$scope', ($scope) ->
    $scope.$watch (-> $scope.records.length), (newLength) ->
      if newLength > 0
        recordGroupByCopy = _.groupBy($scope.records, 'resourceId')
        overdueRecs = []
        
        _.each recordGroupByCopy, (val, key) ->
          lastRec = val[0]
          
          if lastRec.action is 'checkout'
            lastRec.copy = $scope.findItem($scope.copies, lastRec.resourceId)
            lastRec.book = $scope.findItem($scope.books, lastRec.copy.bookId)
            lastRec.member = $scope.findItem($scope.members, lastRec.memberId)
            overdueRecs.push(lastRec)
            
        $scope.overdueRecs = overdueRecs
        $scope.overdueMems = _.groupBy(overdueRecs, 'memberId')
    return
      
  library.directive 'navBar', -> templateUrl: 'partials/nav-bar.html'
  library.directive 'bookEdit', -> templateUrl: 'partials/book-edit.html'
  library.directive 'memberEdit', -> templateUrl: 'partials/member-edit.html'
