'use strict'

describe 'Controller: StreamCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.services', 'neo4jApp.controllers'

  Frame = {}
  Folder = {}
  StreamCtrl = {}
  scope = {}
  timer = {}


  # Initialize the controller and a mock scope
  beforeEach ->
    module (FrameProvider) ->
      FrameProvider.interpreters.push
        type: 'help'
        matches: 'help'
        templateUrl: 'dummy.html'
        exec: ->
          (input) -> return true

      return

    inject ($controller, $rootScope, _Folder_, _Frame_, $timeout) ->
      scope = $rootScope.$new()
      Folder = _Folder_
      Frame = _Frame_
      timer = $timeout
      # Reset storage
      Folder.save([])

      # Instantiate
      StreamCtrl = $controller 'StreamCtrl', { $scope: scope }
      scope.$digest()

  it 'should insert the welcome frame when instantiated', ->
    timer.flush()
    expect(scope.frames.length).toBe 1

  describe 'createFolder:', ->
    it 'should return the created folder', ->
      folder = scope.createFolder()
      expect(folder instanceof Folder).toBeTruthy()

    it 'should add the created folder the folders', ->
      len = scope.folders.length
      scope.createFolder()
      expect(scope.folders.length).toBe len+1

    it 'should create a folder that is expanded by default', ->
      folder = scope.createFolder()
      expect(folder.expanded).toBeTruthy()

  describe 'createFrame:', ->
    it 'should not create a frame without input', ->
      frame = scope.createFrame()
      expect(frame).toBe undefined
      expect(scope.frames.length).toBe 0

    it 'should return the created frame', ->
      frame = scope.createFrame(input: 'help')
      expect(frame instanceof Frame).toBeTruthy()

    it 'should create a new frame and add it to the frames', ->
      len = scope.frames.length
      scope.createFrame(input: 'help')
      expect(scope.frames.length).toBe len+1

  describe 'removeFolder:', ->
    xit 'should remove a folder from folders', ->
      # TODO: Solve confirm...
      len = scope.folders.length
      folder = scope.createFolder()
      scope.removeFolder(folder)
      len2 = scope.folders.length
      expect(len2).toEqual(len)

    it 'should remove all documents in the folder being deleted', ->
      folder = scope.createFolder()
      scope.createFrame(folder: folder.id)
      scope.removeFolder(folder)
      expect(scope.documents.where(folder: folder.id).length).toBe 0

  describe 'toggleStar', ->
    it 'should remove the document from collection if already saved', ->
      doc = scope.createDocument(folder: 'folder')
      scope.toggleStar(doc)
      expect(scope.documents.get(doc)).toBeFalsy()
