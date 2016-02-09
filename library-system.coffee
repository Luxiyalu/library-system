Books = new Mongo.Collection('books')
Copies = new Mongo.Collection('copies')
Authors = new Mongo.Collection('authors')
Members = new Mongo.Collection('members')
Records = new Mongo.Collection('records') # check in/out activities

if Meteor.isClient
  angular.module('library', ['angular-meteor', 'ui.router'])

  angular.module('library').config ($stateProvider, $urlRouterProvider) ->

    $stateProvider
      .state 'book',
        url: '/'
        templateUrl: 'partials/book.html'
        controller: 'LibraryCtrl'

    $urlRouterProvider.otherwise('book')

    return

  angular.module('library').controller 'LibraryCtrl', ($scope, $meteor) ->
    $scope.books = $meteor.collection ->
      return Books.find {}, {sort: {createdAt: -1}}

    $scope.addBook = (newBook) ->
      $scope.books.push
        text: newBook
        createdAt: new Date()

    return

  # angular.bootstrap(document, ['library']);