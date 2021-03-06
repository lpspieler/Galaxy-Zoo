Spine = require 'spine'

class Question extends Spine.Model
  @configure 'Question', 'tree', 'answers', 'checkboxes', 'leadsTo', 'helpText'
  
  @findByTreeAndText: (tree, text) ->
    @select (q) -> q.tree is tree and q.text is text
  
  @firstForTree: (tree) ->
    @find "#{ tree }-0"
  
  constructor: (hash) ->
    count = Question.findAllByAttribute('tree', hash.tree).length
    @id or= "#{ hash.tree }-#{ count }"
    @helpText or= ''
    @answers or= { }
    @checkboxes or= { }
    @text = I18n.t 'questions', @id, 'text'
    @title = I18n.t 'questions', @id, 'title'
    hash.answerWith?.apply @
    super
  
  isTalk: =>
    @id in ['candels-17', 'sloan-11']
  
  help: (text) ->
    @helpText = I18n.t 'questions', @id, 'help'
  
  answer: (text, { leadsTo: leadsTo, icon: icon, examples: examples, talk: talk } = { leadsTo: null, icon: null, examples: 0, talk: false }) ->
    id = "a-#{ _(@answers).keys().length }"
    text = I18n.t 'questions', @id, 'answers', id
    @answers[id] = { text, leadsTo, icon, examples, talk }
  
  examples: =>
    _({ }).tap (examples) =>
      answers = $.extend { }, @answers, @checkboxes
      for key, answer of answers
        _(answer.examples).times (i) =>
          examples[key] or= []
          console.log "#{ @id }_#{ key}_#{ i }"
          examples[key].push "#{ @id }_#{ key }_#{ i }"
  
  checkbox: (text, { icon: icon, examples: examples } = { icon: null, examples: 0 }) ->
    checkbox = true
    id = "x-#{ _(@checkboxes).keys().length }"
    text = I18n.t 'questions', @id, 'checkboxes', id
    @checkboxes[id] = { checkbox, text, icon, examples }
  
  nextQuestionFrom: (answer) ->
    text = @answers[answer]?.leadsTo or @leadsTo
    question = @constructor.findByTreeAndText @tree, text
    question[0] or null

module.exports = Question
