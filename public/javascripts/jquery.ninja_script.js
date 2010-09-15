/*

 Usage Example: 

 $.behavior({
   "#footnote": {
     transform: function(){},
     events: {
       click: function(){}
     }
   },
   "form.input": $.ninja.make_ajax_submit
   )
 })
 */

/*
 $.behavior({
   'div': {
     events: {
       click: function(){}, //okay
       mouseover: {
         handler: function(){},
         do_default: true,
         do_propagate: true
       },
       click: [doClick, true, false],
       click: [doClick, "default", "propagate"], //3
       click: [function(elem){
         ...
         ...
         ...
       }, "default"],

       click: function(elem){
         this.no_default()
         this.no_propagate()
         ...
       }
     }
   })
   */

  (function($) {
    function Behavior(handlers) {
      if (typeof handlers.transform == "function") {
        this.transform = handlers.transform
        delete handlers.transform
      }
      if (typeof handlers.helpers != "undefined"){
        this.helpers = handlers.helpers
        delete handlers.helpers
      }
      if (typeof handlers.events != "undefined") {
        this.event_handlers = handlers.events
      } 
      else {
        this.event_handlers = handlers
      }

      return this
    }

    Behavior.prototype = {
      apply: function() {
        var behavior = this
        return function(index, elem) {
          if (!$(elem).data("ninja_behaviors")) {
            var context = new BehaviorContext(elem, behavior)
            context.apply()
          }
        }
      },
      transform: function(elem){ 
        return elem 
      },
      helpers: {}
    }

    function BehaviorContext(elem, behavior) {
      this.element = elem
      this.transform = behavior.transform
      this.handlers = []
      this.helpers = behavior.helpers
      var event_name
      for(event_name in behavior.event_handlers) {
        var handler = behavior.event_handlers[event_name]
        this.handlers.push([event_name, this.make_handler(handler)])
      }
      return this
    }

    BehaviorContext.prototype = {
      make_handler: function(config) {
        var behavior = this
        var handle
        var stop_default = true
        var stop_propagate = true
        var stop_immediate = true
        if (typeof config == "function") {
          handle = config
        }
        else {
          handle = config[0]
          config = config.slice(1,config.length)
          var len = config.length
          for(var i = 0; i < len; i++) {
            if (config[i] == "default") {
              stop_default = false
            }
            if (config[i] == "propagate") {
              stop_propagate = false
            }
            if (config[i] == "immediate" || config[i] == "other") {
              stop_immediate = false
            }
          }
        }
        return function(event_record) {
          if (stop_default) {
            event_record.preventDefault()
          }
          if (stop_propagate) {
            event_record.stopPropagation()
          }
          if (stop_immediate) {
            event_record.stopImmediatePropagation()
          }
          handle.apply(behavior, [event_record, this])
          return !stop_default
        }
      },
      apply: function() {
        var elem = this.transform(this.element)

        $(elem).data("ninja-behaviors", true)
        var len = this.handlers.length
        for(var i = 0; i < len; i++) {
          var event_name = this.handlers[i][0]
          var handler = this.handlers[i][1]
          $(elem).bind(event_name, handler)
        }
      }
    }

    function BehaviorApplier(selector, behavior) {
      this.selector = selector
      this.behavior = behavior
      return this
    }

    BehaviorApplier.prototype = {
      apply: function() {
        $(this.selector).each(this.behavior.apply())
      }
    }

    BehaviorApplier.prototype.prototype = Behavior.prototype

    function AjaxSubmitter(form_data, action, method) {
      this.form_data = form_data
      this.action = action
      this.method = method
      this.dataType = 'script'

      var method_fields = $.grep(form_data, function(pair) {
        return (pair.name == "_method");
      });
      if ( method_fields.length > 0 ){
        this.method = method_fields[0].value;
      }

      return this
    }

    //Possibly, this should be just $.ajax with complex ajax_data
    AjaxSubmitter.prototype = {
      submit: function() {
        $.ajax(this.ajax_data())
      },

      ajax_data: function() {
        return {
          data: this.form_data,
          dataType: this.dataType,
          url: this.action,
          type: this.method,
          complete: this.response_handler,
          success: this.success_handler,
          error: this.on_error,
          submitter: this
        }
      },
      success_handler: function(data, statusTxt, xhr) {
        this.submitter.on_success(xhr, statusTxt, data)
      },
      response_handler: function(xhr, statusTxt) {
        this.submitter.on_response(xhr, statusTxt)
        Ninja.tools.fire_mutation_event()
      },

      on_response: function(xhr, statusTxt) {
      },
      on_success: function(xhr, statusTxt, data) {
        var response = eval(data)
      },
      on_error: function(xhr, statusTxt, errorThrown) {
        console.log(xhr.responseText)
        $.ninja.tools.message("Server error: " + xhr.statusText, "error")
      }
    }


    function BehaviorCollection() {
      this.event_queue = []
      this.behaviors = []
      return this
    }

    BehaviorCollection.prototype = {
      event_triggered: function(evnt){
        if(this.event_queue.length == 0){
          this.event_queue.unshift(evnt)
          this.handle_queue()
        }
        else {
          this.event_queue.unshift(evnt)
        }
      },
      handle_queue: function(){
        //compacting the queue - should reduce overlapping like events to a single event.
        while (this.event_queue.length != 0){
          this.event_queue = [this.event_queue[0]]
          this.apply();
          this.event_queue.pop()
        }
      },
      apply: function(){
        var i
        var len = this.behaviors.length
        for(i = 0; i < len; i++) {
          var behavior = this.behaviors[i]
          behavior.apply()
        }
      }
    }

    //Needed: spinner, message blocks (There was a problem)
    //Integrated with the ajax handler
    var Ninja = {
      config: {
        message_wrapping: function(text, classes) {
          return "<div class='flash " + classes +"'><p>" + text + "</p></div>"
        },
        message_list: "#messages"
      },
      tools: {
        fire_mutation_event: function() {
          $(document.firstChild).trigger("NinjaChangedDOM");
        },
        suppress_change_events: function() {
          return new Behavior({
            events: {
              DOMSubtreeModified: function(e){},
              DOMNodeInserted: function(e){}
            }
          })
        },
        ajax_submitter: function(form_data, action, method) {
          return new AjaxSubmitter(form_data, action, method)
        },
        busy_overlay: function(elem) {
          var overlay = this.build_overlay_for(elem)
          overlay.addClass("ninja busy")
          return overlay
        },
        build_overlay_for: function(elem) {
          var overlay = $(document.createElement("div"))
          var hideMe = $(elem)
          var offset = hideMe.offset()
          overlay.css("position", "absolute")
          overlay.css("top", offset.top)
          overlay.css("left", offset.left)
          overlay.width(hideMe.outerWidth())
          overlay.height(hideMe.outerHeight())
          overlay.css("zIndex", "2")
          return overlay
        },
        message: function(text, classes) {
          var adding_message = Ninja.config.message_wrapping(text, classes)
          $(Ninja.config.message_list).append(adding_message)
        }
      },
      ajax_submission: function(configs) {
        if(typeof configs == "undefined") {
          configs = {}
        }

        if(typeof configs.busy_element == "undefined") {
          configs.busy_element = function(elem) {
            return elem
          }
        }
        return new Behavior({
          helpers: {
            find_overlay: configs.busy_element
          },
          events: {
            submit: function(evnt) {
              var form_data = $(evnt.target).serializeArray()
              var overlay = $.ninja.tools.busy_overlay(this.helpers.find_overlay(evnt.target))
              var submitter = $.ninja.tools.ajax_submitter(form_data, 
              evnt.target.action, 
              evnt.target.method)
              submitter.on_response = function(x,t) {
                overlay.remove()
              }
              $("body").append(overlay)
              submitter.submit()
            }
          }
        })
      },
      make_ajax_link: function(configs) {
        if(typeof configs == "undefined") {
          configs = {}
        }

        if(typeof configs.busy_element == "undefined") {
          configs.busy_element = function(elem) {
            return elem
          }
        }
        return new Behavior({
          helpers: {
            find_overlay: configs.busy_element
          },
          transform: function(form){
            var link_text
            if ((images = $('input[type=image]', form)).size() > 0){
              image = images[0]
              link_text = "<img src='" + image.src + "' alt='" + image.alt +"'";
            } else if((submits = $('input[type=submit]', form)).size() > 0) {
              submit = submits[0]
              link_text = submit.value
              } else {
                console.log("Couldn't find a submit input in form");
              }

              var link = $("<a href='#'>" + link_text + "</a>")
              this.form_data = $(form).serializeArray()
              this.action = form.action
              this.method = form.method

              $(form).replaceWith(link)
              return link
            },
            events: {
              click: function(evnt, elem){
                var overlay = $.ninja.tools.busy_overlay(this.helpers.find_overlay(evnt.target))
                var submitter = $.ninja.tools.ajax_submitter(
                  this.form_data, 
                  this.action, 
                  this.method)
                  submitter.on_response = function(x,t) {
                    overlay.remove()
                  }
                  $("body").append(overlay)
                  submitter.submit()
                }
                }} 
                )
              }
            }
              

        function handleMutation(evnt) {
          //TODO Queue up re-applications
          //TODO Restrict application to changed part of subtree

          $(this).data("ninja-behavior").event_triggered(evnt);
        }

        $.extend({
          ninja: Ninja,
          behavior: function(dispatching) 
          {
            var collection = new BehaviorCollection()
            var selector
            for(selector in dispatching) 
            {
              if(typeof dispatching[selector] == "undefined") 
              {
                console.log("Selector " + selector + " not properly defined - ignoring")
              } 
              else 
              {
                //Needs to confirm either a Behavior (or decended from Behavior (how?))
                //Or a proper behavior spec
                if(dispatching[selector] instanceof Behavior) 
                {
                  collection.behaviors.push(new BehaviorApplier(selector, dispatching[selector]))
                } 
                else 
                {
                  var behavior = new Behavior(dispatching[selector])
                  collection.behaviors.push(new BehaviorApplier(selector, behavior))
                }
              }
            }
            $("html").data("ninja-behavior", collection);
            $("html").bind("DOMSubtreeModified DOMNodeInserted NinjaChangedDOM", handleMutation);
            $("html").one("DOMSubtreeModified DOMNodeInserted", function(){
              Ninja.tools.fire_mutation_event = function(){}
            })
            //$(document.firstChild).data("ninja-behavior", collection);
            //$(document.firstChild).bind("DOMSubtreeModified DOMNodeInserted NinjaChangedDOM", handleMutation);
      //      collection.apply();
            $(function(){ Ninja.tools.fire_mutation_event(); });
          }
        });
      })(jQuery);
