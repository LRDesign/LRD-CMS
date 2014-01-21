/*
 * NinjaScript - 0.11.1
 * written by and copyright 2010-2014 Judson Lester and Logical Reality Design
 * Licensed under the MIT license
 *
 * 01-13-2014
 */
var ninjascript = {behaviors:{}};
ninjascript.behaviors.Abstract = function() {
};
(function() {
  ninjascript.behaviors.Abstract.prototype.expandRules = function(b) {
    return[]
  }
})();
ninjascript.behaviors.Select = function(b) {
  this.menu = b
};
ninjascript.behaviors.Select.prototype = new ninjascript.behaviors.Abstract;
(function() {
  ninjascript.behaviors.Select.prototype.choose = function(b) {
    for(var d in this.menu) {
      if(jQuery(b).is(d)) {
        return this.menu[d].choose(b)
      }
    }
    return null
  }
})();
ninjascript.configuration = {messageWrapping:function(b, d) {
  return"<div class='flash " + d + "'><p>" + b + "</p></div>"
}, messageList:"#messages", busyLaziness:200};
ninjascript.exceptions = {};
(function() {
  function b(b) {
    var c = function(a) {
      Error.call(this, a);
      Error.captureStackTrace && Error.captureStackTrace(this, this.constructor);
      this.name = b;
      this.message = a
    };
    c.prototype = Error();
    return c
  }
  ninjascript.exceptions.CouldntChoose = b("CouldntChoose");
  ninjascript.exceptions.TransformFailed = b("TransformFailed")
})();
ninjascript.behaviors.Meta = function(b) {
  this.chooser = b
};
ninjascript.behaviors.Meta.prototype = new ninjascript.behaviors.Abstract;
(function() {
  ninjascript.behaviors.Meta.prototype.choose = function(b) {
    var d = this.chooser(b);
    if(void 0 !== d) {
      return d.choose(b)
    }
    throw new ninjascript.exceptions.CouldntChoose("Couldn't choose behavior for " + b.toString());
  }
})();
ninjascript.Extensible = function() {
};
ninjascript.Extensible.addPackage = function(b, d) {
  var c = {}, a = function(a) {
    return function(c) {
      for(functionName in c) {
        c.hasOwnProperty(functionName) && (a[functionName] = c[functionName])
      }
    }
  };
  c.Ninja = a(b.Ninja);
  c.tools = a(b.tools);
  c.behaviors = c.Ninja;
  c.behaviours = c.Ninja;
  c.ninja = c.Ninja;
  return d(c)
};
(function() {
  ninjascript.Extensible.prototype.inject = function(b) {
    this.extensions = b;
    for(property in b) {
      b.hasOwnProperty(property) && (this[property] = b[property])
    }
  }
})();
ninjascript.Logger = function() {
  this.log_function = null
};
(function() {
  var b = ninjascript.Logger.prototype;
  b.log = function(b) {
    this.log_function(b)
  };
  b.active_logging = function(b) {
    try {
      console.log(b)
    }catch(c) {
    }
  };
  b.inactive_logging = function(b) {
  };
  b.deactivate_logging = function() {
    this.log_function = this.inactive_logging
  };
  b.activate_logging = function() {
    this.log_function = this.active_logging
  };
  ninjascript.Logger.instance = new ninjascript.Logger;
  ninjascript.Logger.instance.activate_logging();
  ninjascript.Logger.log = function(b) {
    ninjascript.Logger.instance.log(b)
  };
  ninjascript.Logger.deactivate = function() {
    ninjascript.Logger.instance.deactivate_logging()
  }
})();
ninjascript.behaviors.EventHandlerConfig = function(b, d) {
  this.name = b;
  this.stopPropagate = this.stopDefault = this.fallThrough = !0;
  this.fireMutation = this.stopImmediate = !1;
  if("function" == typeof d) {
    this.handle = d
  }else {
    this.handle = d[0];
    console.log(d);
    d = d.slice(1, d.length);
    for(var c = d.length, a = 0;a < c;a++) {
      if("dontContinue" == d[a] || "overridesOthers" == d[a]) {
        this.fallThrough = !1
      }
      if("andDoDefault" == d[a] || "continues" == d[a] || "allowDefault" == d[a]) {
        this.stopDefault = !1
      }
      if("allowPropagate" == d[a] || "dontStopPropagation" == d[a]) {
        this.stopPropagate = !1
      }
      "andDoOthers" == d[a] && (this.stopImmediate = !1);
      "changesDOM" == d[a] && (this.fireMutation = !0)
    }
  }
};
(function() {
  var b = ninjascript.behaviors.EventHandlerConfig.prototype;
  b.buildHandlerFunction = function(b) {
    var c = this.handle, a = this, e = function(e) {
      c.apply(this, arguments);
      e.isFallthroughPrevented() || "undefined" === typeof b || b.apply(this, arguments);
      return a.stopDefault ? !1 : !e.isDefaultPrevented()
    };
    this.fallThrough || (e = this.prependAction(e, function(a) {
      a.preventFallthrough()
    }));
    this.stopDefault && (e = this.prependAction(e, function(a) {
      a.preventDefault()
    }));
    this.stopPropagate && (e = this.prependAction(e, function(a) {
      a.stopPropagation()
    }));
    this.stopImmediate && (e = this.prependAction(e, function(a) {
      a.stopImmediatePropagation()
    }));
    this.fireMutation && (e = this.appendAction(e, function(c) {
      a.fireMutationEvent()
    }));
    return e = this.prependAction(e, function(a) {
      a.isFallthroughPrevented = function() {
        return!1
      };
      a.preventFallthrough = function() {
        a.isFallthroughPrevented = function() {
          return!0
        }
      }
    })
  };
  b.prependAction = function(b, c) {
    return function() {
      c.apply(this, arguments);
      return b.apply(this, arguments)
    }
  };
  b.appendAction = function(b, c) {
    return function() {
      var a = b.apply(this, arguments);
      c.apply(this, arguments);
      return a
    }
  }
})();
ninjascript.sizzle = function() {
  function b(l) {
    for(var a = "", c, e = 0;l[e];e++) {
      c = l[e], 3 === c.nodeType || 4 === c.nodeType ? a += c.nodeValue : 8 !== c.nodeType && (a += b(c.childNodes))
    }
    return a
  }
  function d(l, a, c, b, e, d) {
    e = 0;
    for(var f = b.length;e < f;e++) {
      var g = b[e];
      if(g) {
        for(var g = g[l], k = !1;g;) {
          if(g.sizcache === c) {
            k = b[g.sizset];
            break
          }
          1 !== g.nodeType || d || (g.sizcache = c, g.sizset = e);
          if(g.nodeName.toLowerCase() === a) {
            k = g;
            break
          }
          g = g[l]
        }
        b[e] = k
      }
    }
  }
  function c(a, c, b, e, d, f) {
    d = 0;
    for(var g = e.length;d < g;d++) {
      var v = e[d];
      if(v) {
        for(var v = v[a], h = !1;v;) {
          if(v.sizcache === b) {
            h = e[v.sizset];
            break
          }
          if(1 === v.nodeType) {
            if(f || (v.sizcache = b, v.sizset = d), "string" !== typeof c) {
              if(v === c) {
                h = !0;
                break
              }
            }else {
              if(0 < k.filter(c, [v]).length) {
                h = v;
                break
              }
            }
          }
          v = v[a]
        }
        e[d] = h
      }
    }
  }
  var a = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^[\]]*\]|['"][^'"]*['"]|[^[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g, e = 0, f = Object.prototype.toString, h = !1, n = !0;
  [0, 0].sort(function() {
    n = !1;
    return 0
  });
  var k = function(l, c, b, e) {
    b = b || [];
    var d = c = c || document;
    if(1 !== c.nodeType && 9 !== c.nodeType) {
      return[]
    }
    if(!l || "string" !== typeof l) {
      return b
    }
    for(var m = [], p, h, q, t, n = !0, s = y(c), B = l;null !== (a.exec(""), p = a.exec(B));) {
      if(B = p[3], m.push(p[1]), p[2]) {
        t = p[3];
        break
      }
    }
    if(1 < m.length && u.exec(l)) {
      if(2 === m.length && g.relative[m[0]]) {
        h = r(m[0] + m[1], c)
      }else {
        for(h = g.relative[m[0]] ? [c] : k(m.shift(), c);m.length;) {
          l = m.shift(), g.relative[l] && (l += m.shift()), h = r(l, h)
        }
      }
    }else {
      if(!e && 1 < m.length && 9 === c.nodeType && !s && g.match.ID.test(m[0]) && !g.match.ID.test(m[m.length - 1]) && (p = k.find(m.shift(), c, s), c = p.expr ? k.filter(p.expr, p.set)[0] : p.set[0]), c) {
        for(p = e ? {expr:m.pop(), set:x(e)} : k.find(m.pop(), 1 !== m.length || "~" !== m[0] && "+" !== m[0] || !c.parentNode ? c : c.parentNode, s), h = p.expr ? k.filter(p.expr, p.set) : p.set, 0 < m.length ? q = x(h) : n = !1;m.length;) {
          var w = m.pop();
          p = w;
          g.relative[w] ? p = m.pop() : w = "";
          null == p && (p = c);
          g.relative[w](q, p, s)
        }
      }else {
        q = []
      }
    }
    q || (q = h);
    q || k.error(w || l);
    if("[object Array]" === f.call(q)) {
      if(n) {
        if(c && 1 === c.nodeType) {
          for(l = 0;null != q[l];l++) {
            q[l] && (!0 === q[l] || 1 === q[l].nodeType && A(c, q[l])) && b.push(h[l])
          }
        }else {
          for(l = 0;null != q[l];l++) {
            q[l] && 1 === q[l].nodeType && b.push(h[l])
          }
        }
      }else {
        b.push.apply(b, q)
      }
    }else {
      x(q, b)
    }
    t && (k(t, d, b, e), k.uniqueSort(b));
    return b
  };
  k.uniqueSort = function(a) {
    if(s && (h = n, a.sort(s), h)) {
      for(var c = 1;c < a.length;c++) {
        a[c] === a[c - 1] && a.splice(c--, 1)
      }
    }
    return a
  };
  k.matches = function(a, c) {
    return k(a, null, null, c)
  };
  k.find = function(a, c, b) {
    var e, d;
    if(!a) {
      return[]
    }
    for(var f = 0, k = g.order.length;f < k;f++) {
      var h = g.order[f];
      if(d = g.leftMatch[h].exec(a)) {
        var u = d[1];
        d.splice(1, 1);
        if("\\" !== u.substr(u.length - 1) && (d[1] = (d[1] || "").replace(/\\/g, ""), e = g.find[h](d, c, b), null != e)) {
          a = a.replace(g.match[h], "");
          break
        }
      }
    }
    e || (e = c.getElementsByTagName("*"));
    return{set:e, expr:a}
  };
  k.filter = function(a, c, b, e) {
    for(var d = a, f = [], h = c, u, t, n = c && c[0] && y(c[0]);a && c.length;) {
      for(var s in g.filter) {
        if(null != (u = g.leftMatch[s].exec(a)) && u[2]) {
          var x = g.filter[s], r, w;
          w = u[1];
          t = !1;
          u.splice(1, 1);
          if("\\" !== w.substr(w.length - 1)) {
            h === f && (f = []);
            if(g.preFilter[s]) {
              if(u = g.preFilter[s](u, h, b, f, e, n), !u) {
                t = r = !0
              }else {
                if(!0 === u) {
                  continue
                }
              }
            }
            if(u) {
              for(var z = 0;null != (w = h[z]);z++) {
                if(w) {
                  r = x(w, u, z, h);
                  var A = e ^ !!r;
                  b && null != r ? A ? t = !0 : h[z] = !1 : A && (f.push(w), t = !0)
                }
              }
            }
            if(void 0 !== r) {
              b || (h = f);
              a = a.replace(g.match[s], "");
              if(!t) {
                return[]
              }
              break
            }
          }
        }
      }
      if(a === d) {
        if(null == t) {
          k.error(a)
        }else {
          break
        }
      }
      d = a
    }
    return h
  };
  k.error = function(a) {
    throw"Syntax error, unrecognized expression: " + a;
  };
  var g = k.selectors = {order:["ID", "NAME", "TAG"], match:{ID:/#((?:[\w\u00c0-\uFFFF-]|\\.)+)/, CLASS:/\.((?:[\w\u00c0-\uFFFF-]|\\.)+)/, NAME:/\[name=['"]*((?:[\w\u00c0-\uFFFF-]|\\.)+)['"]*\]/, ATTR:/\[\s*((?:[\w\u00c0-\uFFFF-]|\\.)+)\s*(?:(\S?=)\s*(['"]*)(.*?)\3|)\s*\]/, TAG:/^((?:[\w\u00c0-\uFFFF\*-]|\\.)+)/, CHILD:/:(only|nth|last|first)-child(?:\((even|odd|[\dn+-]*)\))?/, POS:/:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^-]|$)/, PSEUDO:/:((?:[\w\u00c0-\uFFFF-]|\\.)+)(?:\((['"]?)((?:\([^\)]+\)|[^\(\)]*)+)\2\))?/},
  leftMatch:{}, attrMap:{"class":"className", "for":"htmlFor"}, attrHandle:{href:function(a) {
    return a.getAttribute("href")
  }}, relative:{"+":function(a, c) {
    var b = "string" === typeof c, e = b && !/\W/.test(c), b = b && !e;
    e && (c = c.toLowerCase());
    for(var e = 0, d = a.length, f;e < d;e++) {
      if(f = a[e]) {
        for(;(f = f.previousSibling) && 1 !== f.nodeType;) {
        }
        a[e] = b || f && f.nodeName.toLowerCase() === c ? f || !1 : f === c
      }
    }
    b && k.filter(c, a, !0)
  }, ">":function(a, c) {
    var b = "string" === typeof c;
    if(b && !/\W/.test(c)) {
      c = c.toLowerCase();
      for(var e = 0, d = a.length;e < d;e++) {
        var f = a[e];
        f && (b = f.parentNode, a[e] = b.nodeName.toLowerCase() === c ? b : !1)
      }
    }else {
      e = 0;
      for(d = a.length;e < d;e++) {
        (f = a[e]) && (a[e] = b ? f.parentNode : f.parentNode === c)
      }
      b && k.filter(c, a, !0)
    }
  }, "":function(a, b, f) {
    var g = e++, k = c;
    if("string" === typeof b && !/\W/.test(b)) {
      var m = b = b.toLowerCase(), k = d
    }
    k("parentNode", b, g, a, m, f)
  }, "~":function(a, b, f) {
    var g = e++, k = c;
    if("string" === typeof b && !/\W/.test(b)) {
      var m = b = b.toLowerCase(), k = d
    }
    k("previousSibling", b, g, a, m, f)
  }}, find:{ID:function(a, c, b) {
    if("undefined" !== typeof c.getElementById && !b) {
      return(a = c.getElementById(a[1])) ? [a] : []
    }
  }, NAME:function(a, c) {
    if("undefined" !== typeof c.getElementsByName) {
      for(var b = [], e = c.getElementsByName(a[1]), f = 0, d = e.length;f < d;f++) {
        e[f].getAttribute("name") === a[1] && b.push(e[f])
      }
      return 0 === b.length ? null : b
    }
  }, TAG:function(a, c) {
    return c.getElementsByTagName(a[1])
  }}, preFilter:{CLASS:function(a, c, b, e, f, d) {
    a = " " + a[1].replace(/\\/g, "") + " ";
    if(d) {
      return a
    }
    d = 0;
    for(var g;null != (g = c[d]);d++) {
      g && (f ^ (g.className && 0 <= (" " + g.className + " ").replace(/[\t\n]/g, " ").indexOf(a)) ? b || e.push(g) : b && (c[d] = !1))
    }
    return!1
  }, ID:function(a) {
    return a[1].replace(/\\/g, "")
  }, TAG:function(a, c) {
    return a[1].toLowerCase()
  }, CHILD:function(a) {
    if("nth" === a[1]) {
      var c = /(-?)(\d*)n((?:\+|-)?\d*)/.exec("even" === a[2] && "2n" || "odd" === a[2] && "2n+1" || !/\D/.test(a[2]) && "0n+" + a[2] || a[2]);
      a[2] = c[1] + (c[2] || 1) - 0;
      a[3] = c[3] - 0
    }
    a[0] = e++;
    return a
  }, ATTR:function(a, c, b, e, f, d) {
    c = a[1].replace(/\\/g, "");
    !d && g.attrMap[c] && (a[1] = g.attrMap[c]);
    "~=" === a[2] && (a[4] = " " + a[4] + " ");
    return a
  }, PSEUDO:function(c, b, e, f, d) {
    if("not" === c[1]) {
      if(1 < (a.exec(c[3]) || "").length || /^\w/.test(c[3])) {
        c[3] = k(c[3], null, null, b)
      }else {
        return c = k.filter(c[3], b, e, 1 ^ d), e || f.push.apply(f, c), !1
      }
    }else {
      if(g.match.POS.test(c[0]) || g.match.CHILD.test(c[0])) {
        return!0
      }
    }
    return c
  }, POS:function(a) {
    a.unshift(!0);
    return a
  }}, filters:{enabled:function(a) {
    return!1 === a.disabled && "hidden" !== a.type
  }, disabled:function(a) {
    return!0 === a.disabled
  }, checked:function(a) {
    return!0 === a.checked
  }, selected:function(a) {
    a.parentNode.selectedIndex;
    return!0 === a.selected
  }, parent:function(a) {
    return!!a.firstChild
  }, empty:function(a) {
    return!a.firstChild
  }, has:function(a, c, b) {
    return!!k(b[3], a).length
  }, header:function(a) {
    return/h\d/i.test(a.nodeName)
  }, text:function(a) {
    return"text" === a.type
  }, radio:function(a) {
    return"radio" === a.type
  }, checkbox:function(a) {
    return"checkbox" === a.type
  }, file:function(a) {
    return"file" === a.type
  }, password:function(a) {
    return"password" === a.type
  }, submit:function(a) {
    return"submit" === a.type
  }, image:function(a) {
    return"image" === a.type
  }, reset:function(a) {
    return"reset" === a.type
  }, button:function(a) {
    return"button" === a.type || "button" === a.nodeName.toLowerCase()
  }, input:function(a) {
    return/input|select|textarea|button/i.test(a.nodeName)
  }}, setFilters:{first:function(a, c) {
    return 0 === c
  }, last:function(a, c, b, e) {
    return c === e.length - 1
  }, even:function(a, c) {
    return 0 === c % 2
  }, odd:function(a, c) {
    return 1 === c % 2
  }, lt:function(a, c, b) {
    return c < b[3] - 0
  }, gt:function(a, c, b) {
    return c > b[3] - 0
  }, nth:function(a, c, b) {
    return b[3] - 0 === c
  }, eq:function(a, c, b) {
    return b[3] - 0 === c
  }}, filter:{PSEUDO:function(a, c, e, f) {
    var d = c[1], h = g.filters[d];
    if(h) {
      return h(a, e, c, f)
    }
    if("contains" === d) {
      return 0 <= (a.textContent || a.innerText || b([a]) || "").indexOf(c[3])
    }
    if("not" === d) {
      c = c[3];
      e = 0;
      for(f = c.length;e < f;e++) {
        if(c[e] === a) {
          return!1
        }
      }
      return!0
    }
    k.error("Syntax error, unrecognized expression: " + d)
  }, CHILD:function(a, c) {
    var b = c[1], e = a;
    switch(b) {
      case "only":
      ;
      case "first":
        for(;e = e.previousSibling;) {
          if(1 === e.nodeType) {
            return!1
          }
        }
        if("first" === b) {
          return!0
        }
        e = a;
      case "last":
        for(;e = e.nextSibling;) {
          if(1 === e.nodeType) {
            return!1
          }
        }
        return!0;
      case "nth":
        var b = c[2], f = c[3];
        if(1 === b && 0 === f) {
          return!0
        }
        var d = c[0], g = a.parentNode;
        if(g && (g.sizcache !== d || !a.nodeIndex)) {
          for(var k = 0, e = g.firstChild;e;e = e.nextSibling) {
            1 === e.nodeType && (e.nodeIndex = ++k)
          }
          g.sizcache = d
        }
        e = a.nodeIndex - f;
        return 0 === b ? 0 === e : 0 === e % b && 0 <= e / b
    }
  }, ID:function(a, c) {
    return 1 === a.nodeType && a.getAttribute("id") === c
  }, TAG:function(a, c) {
    return"*" === c && 1 === a.nodeType || a.nodeName.toLowerCase() === c
  }, CLASS:function(a, c) {
    return-1 < (" " + (a.className || a.getAttribute("class")) + " ").indexOf(c)
  }, ATTR:function(a, c) {
    var b = c[1], b = g.attrHandle[b] ? g.attrHandle[b](a) : null != a[b] ? a[b] : a.getAttribute(b), e = b + "", f = c[2], d = c[4];
    return null == b ? "!=" === f : "=" === f ? e === d : "*=" === f ? 0 <= e.indexOf(d) : "~=" === f ? 0 <= (" " + e + " ").indexOf(d) : d ? "!=" === f ? e !== d : "^=" === f ? 0 === e.indexOf(d) : "$=" === f ? e.substr(e.length - d.length) === d : "|=" === f ? e === d || e.substr(0, d.length + 1) === d + "-" : !1 : e && !1 !== b
  }, POS:function(a, c, b, e) {
    var d = g.setFilters[c[2]];
    if(d) {
      return d(a, b, c, e)
    }
  }}}, u = g.match.POS, t;
  for(t in g.match) {
    g.match[t] = RegExp(g.match[t].source + /(?![^\[]*\])(?![^\(]*\))/.source), g.leftMatch[t] = RegExp(/(^(?:.|\r|\n)*?)/.source + g.match[t].source.replace(/\\(\d+)/g, function(a, c) {
      return"\\" + (c - 0 + 1)
    }))
  }
  var x = function(a, c) {
    a = Array.prototype.slice.call(a, 0);
    return c ? (c.push.apply(c, a), c) : a
  };
  try {
    Array.prototype.slice.call(document.documentElement.childNodes, 0)[0].nodeType
  }catch(z) {
    x = function(a, c) {
      var b = c || [];
      if("[object Array]" === f.call(a)) {
        Array.prototype.push.apply(b, a)
      }else {
        if("number" === typeof a.length) {
          for(var e = 0, d = a.length;e < d;e++) {
            b.push(a[e])
          }
        }else {
          for(e = 0;a[e];e++) {
            b.push(a[e])
          }
        }
      }
      return b
    }
  }
  var s;
  document.documentElement.compareDocumentPosition ? s = function(a, c) {
    if(!a.compareDocumentPosition || !c.compareDocumentPosition) {
      return a == c && (h = !0), a.compareDocumentPosition ? -1 : 1
    }
    var b = a.compareDocumentPosition(c) & 4 ? -1 : a === c ? 0 : 1;
    0 === b && (h = !0);
    return b
  } : "sourceIndex" in document.documentElement ? s = function(a, c) {
    if(!a.sourceIndex || !c.sourceIndex) {
      return a == c && (h = !0), a.sourceIndex ? -1 : 1
    }
    var b = a.sourceIndex - c.sourceIndex;
    0 === b && (h = !0);
    return b
  } : document.createRange && (s = function(a, c) {
    if(!a.ownerDocument || !c.ownerDocument) {
      return a == c && (h = !0), a.ownerDocument ? -1 : 1
    }
    var b = a.ownerDocument.createRange(), e = c.ownerDocument.createRange();
    b.setStart(a, 0);
    b.setEnd(a, 0);
    e.setStart(c, 0);
    e.setEnd(c, 0);
    b = b.compareBoundaryPoints(Range.START_TO_END, e);
    0 === b && (h = !0);
    return b
  });
  (function() {
    var a = document.createElement("div"), c = "script" + (new Date).getTime();
    a.innerHTML = "<a name='" + c + "'/>";
    var b = document.documentElement;
    b.insertBefore(a, b.firstChild);
    document.getElementById(c) && (g.find.ID = function(a, c, b) {
      if("undefined" !== typeof c.getElementById && !b) {
        return(c = c.getElementById(a[1])) ? c.id === a[1] || "undefined" !== typeof c.getAttributeNode && c.getAttributeNode("id").nodeValue === a[1] ? [c] : void 0 : []
      }
    }, g.filter.ID = function(a, c) {
      var b = "undefined" !== typeof a.getAttributeNode && a.getAttributeNode("id");
      return 1 === a.nodeType && b && b.nodeValue === c
    });
    b.removeChild(a);
    b = a = null
  })();
  (function() {
    var a = document.createElement("div");
    a.appendChild(document.createComment(""));
    0 < a.getElementsByTagName("*").length && (g.find.TAG = function(a, c) {
      var b = c.getElementsByTagName(a[1]);
      if("*" === a[1]) {
        for(var e = [], d = 0;b[d];d++) {
          1 === b[d].nodeType && e.push(b[d])
        }
        b = e
      }
      return b
    });
    a.innerHTML = "<a href='#'></a>";
    a.firstChild && "undefined" !== typeof a.firstChild.getAttribute && "#" !== a.firstChild.getAttribute("href") && (g.attrHandle.href = function(a) {
      return a.getAttribute("href", 2)
    });
    a = null
  })();
  document.querySelectorAll && function() {
    var a = k, c = document.createElement("div");
    c.innerHTML = "<p class='TEST'></p>";
    if(!c.querySelectorAll || 0 !== c.querySelectorAll(".TEST").length) {
      k = function(c, b, e, d) {
        b = b || document;
        if(!d && 9 === b.nodeType && !y(b)) {
          try {
            return x(b.querySelectorAll(c), e)
          }catch(f) {
          }
        }
        return a(c, b, e, d)
      };
      for(var b in a) {
        k[b] = a[b]
      }
      c = null
    }
  }();
  (function() {
    var a = document.createElement("div");
    a.innerHTML = "<div class='test e'></div><div class='test'></div>";
    a.getElementsByClassName && 0 !== a.getElementsByClassName("e").length && (a.lastChild.className = "e", 1 !== a.getElementsByClassName("e").length && (g.order.splice(1, 0, "CLASS"), g.find.CLASS = function(a, c, b) {
      if("undefined" !== typeof c.getElementsByClassName && !b) {
        return c.getElementsByClassName(a[1])
      }
    }, a = null))
  })();
  var A = document.compareDocumentPosition ? function(a, c) {
    return!!(a.compareDocumentPosition(c) & 16)
  } : function(a, c) {
    return a !== c && (a.contains ? a.contains(c) : !0)
  }, y = function(a) {
    return(a = (a ? a.ownerDocument || a : 0).documentElement) ? "HTML" !== a.nodeName : !1
  }, r = function(a, c) {
    for(var b = [], e = "", d, f = c.nodeType ? [c] : c;d = g.match.PSEUDO.exec(a);) {
      e += d[0], a = a.replace(g.match.PSEUDO, "")
    }
    a = g.relative[a] ? a + "*" : a;
    d = 0;
    for(var h = f.length;d < h;d++) {
      k(a, f[d], b)
    }
    return k.filter(e, b)
  };
  return k
}();
ninjascript.tools = {};
ninjascript.tools.JSONHandler = function(b) {
  this.desc = b
};
(function() {
  var b = ninjascript.tools.JSONHandler.prototype, d = ninjascript.Logger.log;
  b.receive = function(c) {
    this.compose([], c, this.desc);
    return null
  };
  b.compose = function(c, a, b) {
    if("function" == typeof b) {
      try {
        b.call(this, a)
      }catch(f) {
        d("prototype.Caught = " + f + " while handling JSON at " + c.join("/"))
      }
    }else {
      for(var h in a) {
        a.hasOwnProperty(h) && h in b && this.compose(c.concat([h]), a[h], b[h])
      }
    }
    return null
  };
  b.inspectTree = function(c) {
    var a = [], b;
    for(b in c) {
      "function" == typeof c[b] ? a.push(b) : Utils.forEach(this.inspectTree(c[b]), function(c) {
        a.push(b + "." + c)
      })
    }
    return a
  };
  b.inspect = function() {
    return this.inspectTree(this.desc).join("\n")
  }
})();
ninjascript.utils = {};
(function() {
  var b = ninjascript.utils;
  b.isArray = function(b) {
    return"undefined" == typeof b ? !1 : b.constructor == Array
  };
  b.enrich = function(b, c) {
    return jQuery.extend(b, c)
  };
  b.clone = function(b) {
    return jQuery.extend(!0, {}, b)
  };
  b.forEach = function(b, c, a) {
    if("function" == typeof b.forEach) {
      return b.forEach(c, a)
    }
    if("function" == typeof Array.prototype.forEach) {
      return Array.prototype.forEach.call(b, c, a)
    }
    for(var e = Number(b.length), f = 0;f < e;f += 1) {
      "undefined" != typeof b[f] && c.call(a, b[f], f, b)
    }
  }
})();
ninjascript.BehaviorBinding = function(b) {
  var d = function() {
    this.stashedElements = [];
    this.eventHandlerSet = {}
  };
  d.prototype = b;
  b = new d;
  b.initialize = function(c, a, b) {
    this.behaviorConfig = a;
    this.parent = c;
    this.acquireTransform(a.transform);
    this.acquireEventHandlers(a.eventHandlers);
    this.acquireHelpers(a.helpers);
    this.postElement = this.previousElement = b;
    c = this.transform(b);
    void 0 !== c && (this.postElement = c);
    this.element = this.postElement;
    return this
  };
  b.binding = function(c, a) {
    var b = this, d = function() {
      this.initialize(b, c, a)
    };
    d.prototype = this;
    return new d
  };
  b.acquireEventHandlers = function(c) {
    for(var a = c.length, b = 0, d, b = 0;b < a;b++) {
      d = c[b].name;
      var h = this, n = c[b].buildHandlerFunction(this.parent[d]);
      this[d] = function() {
        var a = Array.prototype.shift.call(arguments);
        Array.prototype.unshift.call(arguments, this);
        Array.prototype.unshift.call(arguments, a);
        return n.apply(h, arguments)
      }
    }
  };
  b.acquireHelpers = function(c) {
    for(var a in c) {
      this[a] = c[a]
    }
  };
  b.acquireTransform = function(c) {
    this.transform = c
  };
  b.stash = function(c) {
    this.stashedElements.unshift(c);
    jQuery(c).detach();
    return c
  };
  b.unstash = function() {
    var c = jQuery(this.stashedElements.shift()), a = this.hiddenDiv();
    c.data("ninja-visited", this);
    jQuery(a).append(c);
    this.parent.bindHandlers();
    return c
  };
  b.clearStash = function() {
    this.stashedElements = []
  };
  b.cascadeEvent = function(c) {
    for(;0 < this.stashedElements.length;) {
      this.unstash().trigger(c)
    }
  };
  b.bindHandlers = function() {
    for(var c = jQuery(this.postElement), a = this.behaviorConfig.eventHandlers, b = a.length, d = 0;d < b;d++) {
      c.bind(a[d].name, this[a[d].name])
    }
  };
  b.unbindHandlers = function() {
    for(var c = jQuery(this.postElement), a = this.behaviorConfig.eventHandlers, b = a.length, d = 0;d < b;d++) {
      c.unbind(a[d].name, this[a[d].name])
    }
  };
  return b.binding({transform:function(c) {
    return c
  }, eventHandlers:[], helpers:{}}, null)
};
ninjascript.BehaviorRuleBuilder = function() {
  this.ninja = null;
  this.rules = [];
  this.finder = null;
  this.behaviors = []
};
(function() {
  var b = ninjascript.BehaviorRuleBuilder.prototype, d = ninjascript.utils;
  b.normalizeFinder = function(c) {
    return"string" == typeof c ? function(a) {
      return ninjascript.sizzle(c, a)
    } : c
  };
  b.normalizeBehavior = function(c) {
    return c instanceof ninjascript.behaviors.Abstract ? c : "function" == typeof c ? c.call(this.ninja) : new ninjascript.behaviors.Basic(c)
  };
  b.buildRules = function(c) {
    this.rules = [];
    this.finder = this.normalizeFinder(this.finder);
    for(d.isArray(c) ? this.behaviors = c : this.behaviors = [c];0 < this.behaviors.length;) {
      if(c = this.behaviors.shift(), c = this.normalizeBehavior(c), d.isArray(c)) {
        this.behaviors = this.behaviors.concat(c)
      }else {
        var a = new ninjascript.BehaviorRule;
        a.finder = this.finder;
        a.behavior = c;
        this.rules.push(a)
      }
    }
  }
})();
ninjascript.behaviors.Basic = function(b) {
  this.helpers = {};
  this.eventHandlers = [];
  this.priority = this.lexicalOrder = 0;
  "function" == typeof b.transform && (this.transform = b.transform, delete b.transform);
  "undefined" != typeof b.helpers && (this.helpers = b.helpers, delete b.helpers);
  "undefined" != typeof b.priority && (this.priority = b.priority);
  delete b.priority;
  this.eventHandlers = "undefined" != typeof b.events ? this.eventConfigs(b.events) : this.eventConfigs(b);
  return this
};
ninjascript.behaviors.Basic.prototype = new ninjascript.behaviors.Abstract;
(function() {
  var b = ninjascript.behaviors.Basic.prototype, d = ninjascript.behaviors.EventHandlerConfig;
  b.priority = function(c) {
    this.priority = c;
    return this
  };
  b.choose = function(c) {
    return this
  };
  b.eventConfigs = function(c) {
    var a = [], b;
    for(b in c) {
      a.push(new d(b, c[b]))
    }
    return a
  };
  b.transform = function(c) {
    return c
  };
  b.expandRules = function(c) {
    return[]
  };
  b.helpers = {}
})();
ninjascript.BehaviorRule = function() {
  this.finder = function(b) {
    return[]
  };
  this.behavior = null
};
ninjascript.BehaviorRule.build = function(b, d, c) {
  builder = new ninjascript.BehaviorRuleBuilder;
  builder.ninja = b;
  builder.finder = d;
  builder.buildRules(c);
  return builder.rules
};
(function() {
  var b = ninjascript.BehaviorRule.prototype;
  b.match = function(b) {
    return this.matchRoots([b], this.finder)
  };
  b.matchRoots = function(b, c) {
    var a, e = b.length, f = [];
    for(a = 0;a < e;a++) {
      f = f.concat(c(b[a]))
    }
    return f
  };
  b.chainFinder = function(b) {
    return function(c) {
      return this.matchRoots(precendent.finder(c), b)
    }
  };
  b.chainRule = function(b, c) {
    var a = new ninjascript.BehaviorRule;
    a.finder = this.chainFinder(b);
    a.behavior = c;
    return a
  }
})();
ninjascript.BehaviorCollection = function(b) {
  this.lexicalCount = 0;
  this.rules = [];
  this.parts = b;
  this.tools = b.tools;
  return this
};
(function() {
  var b = ninjascript.BehaviorCollection.prototype, d = ninjascript.utils, c = ninjascript.BehaviorBinding, a = ninjascript.BehaviorRule, e = d.forEach, f = ninjascript.Logger.log, h = ninjascript.exceptions.TransformFailed, n = ninjascript.exceptions.CouldntChoose;
  b.ninja = function() {
    return this.parts.ninja
  };
  b.addBehavior = function(c, b) {
    d.isArray(b) ? e(b, function(a) {
      this.addBehavior(c, a)
    }, this) : e(a.build(this.ninja(), c, b), function(a) {
      this.addBehaviorRule(a)
    }, this)
  };
  b.addBehaviorRule = function(a) {
    a.behavior.lexicalOrder = this.lexicalCount;
    this.lexicalCount += 1;
    this.rules.push(a)
  };
  b.finalize = function() {
    for(var a, c = 0;c < this.rules.length;c++) {
      a = this.rules[c];
      a = a.behavior.expandRules(a);
      for(var b = 0;b < a.length;b++) {
        this.addBehaviorRule(a[b])
      }
    }
  };
  b.applyAll = function(a) {
    var c, b, e, d, f, h, n, y = !1, r = [];
    f = this.rules.length;
    for(c = 0;c < f;c++) {
      for(h = this.rules[c].match(a), d = h.length, n = r.length, b = 0;b < d;b++) {
        for(e = 0;e < n;e++) {
          if(h[b] == r[e].element) {
            r[e].behaviors.push(this.rules[c].behavior);
            y = !0;
            break
          }
        }
        y || (r.push({element:h[b], behaviors:[this.rules[c].behavior]}), n = r.length)
      }
    }
    for(c = 0;c < n;c++) {
      jQuery(r[c].element).data("ninja-visited") || this.apply(r[c].element, r[c].behaviors)
    }
  };
  b.apply = function(a, b) {
    var e = [], e = this.collectBehaviors(a, b), d = jQuery(a).data("ninja-visited");
    d ? d.unbindHandlers() : d = c(this.tools);
    this.applyBehaviorsInContext(d, a, e)
  };
  b.collectBehaviors = function(a, c) {
    var b = [];
    e(c, function(c) {
      try {
        b.push(c.choose(a))
      }catch(e) {
        if(e instanceof n) {
          f("!!! couldn't choose")
        }else {
          throw f(e), e;
        }
      }
    });
    return b
  };
  b.applyBehaviorsInContext = function(a, c, b) {
    var d = a;
    b = this.sortBehaviors(b);
    e(b, function(b) {
      try {
        a = a.binding(b, c), c = a.element
      }catch(e) {
        if(e instanceof h) {
          f("!!! Transform failed")
        }else {
          throw f(e), e;
        }
      }
    });
    d.visibleElement = c;
    jQuery(c).data("ninja-visited", a);
    a.bindHandlers();
    this.tools.fireMutationEvent();
    return c
  };
  b.sortBehaviors = function(a) {
    return a.sort(function(a, c) {
      return a.priority != c.priority ? void 0 === a.priority ? -1 : void 0 === c.priority ? 1 : a.priority - c.priority : a.lexicalOrder - c.lexicalOrder
    })
  }
})();
ninjascript.mutation = {};
ninjascript.mutation.EventHandler = function(b, d) {
  this.eventQueue = [];
  this.mutationTargets = [];
  this.behaviorCollection = d;
  this.docRoot = b;
  var c = this;
  this.handleMutationEvent = function(a) {
    c.mutationEventTriggered(a)
  };
  this.handleNaturalMutationEvent = function() {
    c.detachSyntheticMutationEvents()
  }
};
(function() {
  var b = ninjascript.mutation.EventHandler.prototype, d = ninjascript.utils.forEach;
  b.setup = function() {
    this.docRoot.bind("DOMSubtreeModified DOMNodeInserted thisChangedDOM", this.handleMutationEvent);
    this.docRoot.one("DOMSubtreeModified DOMNodeInserted", this.handleNaturalMutationEvent);
    this.setup = function() {
    }
  };
  b.teardown = function() {
    delete this.setup;
    this.docRoot.unbind("DOMSubtreeModified DOMNodeInserted thisChangedDOM", this.handleMutationEvent)
  };
  b.detachSyntheticMutationEvents = function() {
    this.fireMutationEvent = function() {
    };
    this.addMutationTargets = function() {
    }
  };
  b.addMutationTargets = function(c) {
    this.mutationTargets = this.mutationTargets.concat(c)
  };
  b.fireMutationEvent = function() {
    var c = this.mutationTargets;
    if(0 < c.length) {
      for(var a = c[0];0 < c.length;a = c.shift()) {
        jQuery(a).trigger("thisChangedDOM")
      }
    }else {
      this.docRoot.trigger("thisChangedDOM")
    }
  };
  b.mutationEventTriggered = function(c) {
    0 == this.eventQueue.length ? (this.enqueueEvent(c), this.handleQueue()) : this.enqueueEvent(c)
  };
  b.enqueueEvent = function(c) {
    var a = !1, b = [];
    d(this.eventQueue, function(d) {
      a = a || jQuery.contains(d.target, c.target);
      jQuery.contains(c.target, d.target) || b.push(d)
    });
    a || (b.unshift(c), this.eventQueue = b)
  };
  b.handleQueue = function() {
    for(;0 != this.eventQueue.length;) {
      this.behaviorCollection.applyAll(this.eventQueue[0].target), this.eventQueue.shift()
    }
  }
})();
ninjascript.NinjaScript = function() {
};
ninjascript.NinjaScript.prototype = new ninjascript.Extensible;
(function() {
  var b = ninjascript.NinjaScript.prototype, d = ninjascript.utils, c = ninjascript.Logger.log;
  b.plugin = function(a) {
    return ninjascript.Extensible.addPackage({Ninja:this, tools:this.tools}, a)
  };
  b.configure = function(a) {
    d.enrich(this.config, a)
  };
  b.respondToJson = function(a) {
    this.jsonDispatcher.addHandler(a)
  };
  b.goodBehavior = function(a) {
    var b = this.extensions.collection, d;
    for(d in a) {
      "undefined" == typeof a[d] ? c("Selector " + d + " not properly defined - ignoring") : b.addBehavior(d, a[d])
    }
    this.failSafeGo()
  };
  b.behavior = b.goodBehavior;
  b.failSafeGo = function() {
    this.failSafeGo = function() {
    };
    jQuery(window).load(function() {
      Ninja.go()
    })
  };
  b.badBehavior = function(a) {
    throw Error("Called Ninja.behavior() after Ninja.go() - don't do that.  'Go' means 'I'm done, please proceed'");
  };
  b.go = function() {
    this.behavior != this.badBehavior && (this.behavior = this.badBehavior, this.extensions.collection.finalize(), this.mutationHandler.setup(), this.mutationHandler.fireMutationEvent())
  };
  b.stop = function() {
    this.mutationHandler.teardown();
    this.behavior = this.goodBehavior
  }
})();
ninjascript.Tools = function() {
};
ninjascript.Tools.prototype = new ninjascript.Extensible;
(function() {
  var b = ninjascript.Tools.prototype, d = ninjascript.exceptions.TransformFailed, c = ninjascript.Logger.log;
  b.forEach = ninjascript.utils.forEach;
  b.ensureDefaults = function(a, c) {
    a instanceof Object || (a = {});
    for(var b in c) {
      "undefined" == typeof a[b] && ("undefined" != typeof this.ninja.config[b] ? a[b] = this.ninja.config[b] : "undefined" != typeof c[b] && (a[b] = c[b]))
    }
    return a
  };
  b.getRootOfDocument = function() {
    return jQuery("html")
  };
  b.getRootCollection = function() {
    return this.ninja.collection
  };
  b.fireMutationEvent = function() {
    this.ninja.mutationHandler.fireMutationEvent()
  };
  b.copyAttributes = function(a, c, b) {
    var d = RegExp("^" + b.join("$|^") + "$");
    c = jQuery(c);
    this.forEach(a.attributes, function(a) {
      d.test(a.nodeName) && c.attr(a.nodeName, a.nodeValue)
    })
  };
  b.deriveElementsFrom = function(a, c) {
    switch(typeof c) {
      case "undefined":
        return a;
      case "string":
        return jQuery(c);
      case "function":
        return c(a)
    }
  };
  b.extractMethod = function(a, b) {
    if(void 0 !== a.dataset && void 0 !== a.dataset.method && 0 < a.dataset.method.length) {
      return c("Override via prototype.dataset = " + a.dataset.method), a.dataset.method
    }
    if(void 0 === a.dataset && void 0 !== jQuery(a).attr("data-method")) {
      return c("Override via data-prototype.method = " + jQuery(a).attr("data-method")), jQuery(a).attr("data-method")
    }
    if("undefined" !== typeof b) {
      for(var d = 0, h = b.length;d < h;d++) {
        if("Method" == b[d].name) {
          return c("Override via prototype.Method = " + b[d].value), b[d].value
        }
      }
    }
    return"undefined" !== typeof a.method ? a.method : "GET"
  };
  b.cantTransform = function(a) {
    throw new d(a);
  };
  b.message = function(a, c) {
    var b = this.ninja.config.messageWrapping(a, c);
    jQuery(this.ninja.config.messageList).append(b)
  };
  b.hiddenDiv = function() {
    var a = jQuery("div#ninja-hide");
    if(0 < a.length) {
      return a[0]
    }
    a = jQuery("<div id='ninja-hide'></div>").css("display", "none");
    jQuery("body").append(a);
    this.getRootCollection().apply(a, [this.ninja.suppressChangeEvents()]);
    return a
  }
})();
ninjascript.plugin = function(b) {
  ninjascript.Extensible.addPackage({Ninja:ninjascript.NinjaScript.prototype, tools:ninjascript.Tools.prototype}, b)
};
ninjascript.packagedBehaviors = {};
ninjascript.packagedBehaviors.confirm = {};
(function() {
  ninjascript.plugin(function(b) {
    b.behaviors({confirms:function(b) {
      function c(a, c) {
        confirm(b.confirmMessage(c)) || (a.preventDefault(), a.preventFallthrough())
      }
      b = this.tools.ensureDefaults(b, {confirmMessage:function(a) {
        return $(a).attr("data-confirm")
      }});
      "string" == typeof b.confirmMessage && (message = b.confirmMessage, b.confirmMessage = function(a) {
        return message
      });
      return new this.types.selects({form:new this.types.does({priority:20, events:{submit:[c, "andDoDefault"]}}), "a,input":new this.types.does({priority:20, events:{click:[c, "andDoDefault"]}})})
    }})
  })
})();
ninjascript.packagedBehaviors.placeholder = {};
(function() {
  var b = {placeholderSubmitter:function(a) {
    return new this.types.does({priority:1E3, submit:[function(c, b, d) {
      a.prepareForSubmit();
      d(c)
    }, "andDoDefault"]})
  }, grabsPlaceholderText:function(a) {
    a = this.tools.ensureDefaults(a, {textElementSelector:function(a) {
      return"*[data-for=" + a.id + "]"
    }, findTextElement:function(c) {
      c = $(a.textElementSelector(c));
      return 0 == c.length ? null : c[0]
    }});
    return new this.types.does({priority:-10, transform:function(c) {
      var b = $(a.findTextElement(c));
      null === b && this.cantTransform();
      this.placeholderText = b.text();
      $(c).attr("placeholder", b.text());
      this.stash(b.detach())
    }})
  }}, d = !!("placeholder" in document.createElement("input")), c = !!("placeholder" in document.createElement("textarea"));
  d || (b.alternateInput = function(a, c) {
    return new this.types.does({helpers:{prepareForSubmit:function() {
      $(this.element).val("")
    }}, transform:function() {
      this.applyBehaviors(c, [placeholderSubmitter(this)])
    }, events:{focus:function(c) {
      c = $(this.element);
      var b = c.attr("id");
      c.attr("id", "");
      c.replaceWith(a);
      a.attr("id", b);
      a.focus()
    }}})
  }, b.hasPlaceholderPassword = function(a) {
    a = this.tools.ensureDefaults(a, {findParentForm:function(a) {
      return a.parents("form")[0]
    }, retainedInputAttributes:"name class style title lang dir size maxlength alt tabindex accesskey data-.*".split(" ")});
    return new this.types.does({priority:1E3, helpers:{swapInAlternate:function() {
      var a = $(this.element), c = a.attr("id");
      "" == a.val() && (a.attr("id", ""), a.replaceWith(this.placeholderTextInput), this.placeholderTextInput.attr("id", c))
    }}, transform:function(c) {
      var b, d = $(c);
      b = $('<input type="text">');
      this.copyAttributes(c, b, a.retainedInputAttributes);
      b.addClass("ninja_placeholder");
      b.val(this.placeholderText);
      d = alternateInput(d, a.findParentForm(d));
      this.applyBehaviors(b, [d]);
      this.placeholderTextInput = b;
      this.swapInAlternate();
      return c
    }, events:{blur:function(a) {
      this.swapInAlternate()
    }}})
  });
  d && c || (b.hasPlaceholderText = function(a) {
    a = this.tools.ensureDefaults(a, {findParentForm:function(a) {
      return a.parents("form")[0]
    }});
    return new this.types.does({priority:1E3, helpers:{prepareForSubmit:function() {
      $(this.element).hasClass("ninja_placeholder") && $(this.element).val("")
    }}, transform:function(c) {
      var b = $(c);
      b.addClass("ninja_placeholder");
      b.val(this.placeholderText);
      this.applyBehaviors(a.findParentForm(b), [placeholderSubmitter(this)]);
      return c
    }, events:{focus:function(a) {
      $(this.element).hasClass("ninja_placeholder") && $(this.element).removeClass("ninja_placeholder").val("")
    }, blur:function(a) {
      "" == $(this.element).val() && $(this.element).addClass("ninja_placeholder").val(this.placeholderText)
    }}})
  });
  b.hasPlaceholder = function(a) {
    var b = [this.grabsPlaceholderText(a)], f = null, h = null, n = null;
    d && c || (d || (f = this.hasPlaceholderText(a), h = this.hasPlaceholderPassword(a)), c || (n = this.hasPlaceholderText(a)), b.push(new this.types.chooses(function(a) {
      a = $(a);
      if(a.is("input[type=text]")) {
        return f
      }
      if(a.is("textarea")) {
        return n
      }
      if(a.is("input[type=password]")) {
        return h
      }
    })));
    return b
  };
  ninjascript.plugin(function(a) {
    a.Ninja(b)
  })
})();
ninjascript.packagedBehaviors.standard = {};
(function() {
  var b = ninjascript.Logger.log;
  ninjascript.plugin(function(d) {
    d.ninja({submitsAsAjax:function(c) {
      var a = this.submitsAsAjaxLink(c), b = this.submitsAsAjaxForm(c);
      return new this.types.chooses(function(c) {
        switch(c.tagName.toLowerCase()) {
          case "a":
            return a;
          case "form":
            return b
        }
      })
    }, submitsAsAjaxLink:function(c) {
      c = this.tools.ensureDefaults(c, {busyElement:function(a) {
        return $(a).parents("address,blockquote,body,dd,div,p,dl,dt,table,form,ol,ul,tr")[0]
      }});
      c.actions || (c.actions = c.expectsJSON);
      return new this.types.does({priority:10, helpers:{findOverlay:function(a) {
        return this.deriveElementsFrom(a, c.busyElement)
      }}, events:{click:function(a) {
        this.overlayAndSubmit(this.visibleElement, a.target, a.target.href, c.actions)
      }}})
    }, submitsAsAjaxForm:function(c) {
      c = this.tools.ensureDefaults(c, {busyElement:void 0});
      c.actions || (c.actions = c.expectsJSON);
      return new this.types.does({priority:10, helpers:{findOverlay:function(a) {
        return this.deriveElementsFrom(a, c.busyElement)
      }}, events:{submit:function(a) {
        this.overlayAndSubmit(this.visibleElement, a.target, a.target.action, c.actions)
      }}})
    }, becomesAjaxLink:function(c) {
      c = this.tools.ensureDefaults(c, {busyElement:void 0, retainedFormAttributes:"id class lang dir title data-.*".split(" ")});
      return[this.submitsAsAjax(c), this.becomesLink(c)]
    }, becomesLink:function(c) {
      c = this.tools.ensureDefaults(c, {retainedFormAttributes:"id class lang dir title rel data-.*".split(" ")});
      return new this.types.does({priority:30, transform:function(a) {
        var d, f;
        0 < (f = jQuery("button[type=submit]", a)).size() ? (console.log(f), d = f.first().text()) : 0 < (f = jQuery("input[type=image]", a)).size() ? (d = f[0], d = "<img src='" + d.src + "' alt='" + d.alt + "'") : 0 < (f = jQuery("input[type=submit]", a)).size() ? (1 < f.size() && b("Multiple submits.  Using: " + f[0]), d = f[0].value) : (b("Couldn't find a submit input in form"), this.cantTransform("Couldn't find a submit input"));
        d = jQuery("<a rel='nofollow' href='#'>" + d + "</a>");
        this.copyAttributes(a, d, c.retainedFormAttributes);
        this.stash(jQuery(a).replaceWith(d));
        return d
      }, events:{click:function(a, c) {
        this.cascadeEvent("submit")
      }}})
    }, decays:function(c) {
      c = this.tools.ensureDefaults(c, {lifetime:1E4, diesFor:600});
      return new this.types.does({priority:100, transform:function(a) {
        jQuery(a).delay(c.lifetime).slideUp(c.diesFor, function() {
          jQuery(a).remove();
          this.tools.fireMutationEvent()
        })
      }, events:{click:[function(a) {
        jQuery(this.element).remove()
      }, "changesDOM"]}})
    }})
  })
})();
ninjascript.packagedBehaviors.triggerOn = {};
(function() {
  ninjascript.plugin(function(b) {
    b.behaviors({cascadeEvent:function(b) {
    }, removed:function() {
    }, triggersOnSelect:function(b) {
      var c = b = this.tools.ensureDefaults(b, {busyElement:void 0, selectElement:function(a) {
        return $(a).find("select").first()
      }, submitElement:function(a) {
        return $(a).find("input[type='submit']").first()
      }, placeholderText:"Select to go", placeholderValue:"instructions"});
      "object" === typeof b.actions && (c = b.actions);
      return new this.types.does({priority:20, helpers:{findOverlay:function(a) {
        return this.deriveElementsFrom(a, b.busyElement)
      }}, transform:function(a) {
        var c = this.deriveElementsFrom(a, b.selectElement), f = this.deriveElementsFrom(a, b.submitElement);
        "undefined" != typeof c && "undefined" != typeof f || this.cantTransform();
        c.prepend("<option value='" + b.placeholderValue + "'> " + b.placeholderText + "</option>");
        c.val(b.placeholderValue);
        $(a).find("input[type='submit']").remove();
        return a
      }, events:{change:[function(a, b) {
        this.overlayAndSubmit(b, b.action, c)
      }, "andDoDefault"]}})
    }})
  })
})();
ninjascript.packagedBehaviors.utility = {};
(function() {
  ninjascript.plugin(function(b) {
    b.behaviors({suppressChangeEvents:function() {
      return new this.types.does({events:{DOMSubtreeModified:function(b) {
      }, DOMNodeInserted:function(b) {
      }}})
    }})
  })
})();
ninjascript.packagedBehaviors.all = {};
ninjascript.tools.JSONDispatcher = function() {
  this.handlers = []
};
(function() {
  var b = ninjascript.utils, d = ninjascript.tools.JSONDispatcher.prototype, c = ninjascript.Logger.log;
  d.addHandler = function(a) {
    this.handlers.push(new ninjascript.tools.JSONHandler(a))
  };
  d.dispatch = function(a) {
    for(var b = this.handlers.length, d = 0;d < b;d++) {
      try {
        this.handlers[d].receive(a)
      }catch(h) {
        c("prototype.Caught = " + h + " while handling JSON response.")
      }
    }
  };
  d.inspect = function() {
    var a = [];
    b.forEach(this.handlers, function(b) {
      a.push(b.inspect())
    });
    return"JSONDispatcher, " + this.handlers.length + " handlers:\n" + a.join("\n")
  }
})();
ninjascript.build = function() {
  var b = {};
  b.tools = new ninjascript.Tools(b);
  b.config = ninjascript.configuration;
  b.collection = new ninjascript.BehaviorCollection(b);
  b.jsonDispatcher = new ninjascript.tools.JSONDispatcher;
  b.mutationHandler = new ninjascript.mutation.EventHandler(b.tools.getRootOfDocument(), b.collection);
  b.types = {does:ninjascript.behaviors.Basic, chooses:ninjascript.behaviors.Meta, selects:ninjascript.behaviors.Select};
  b.ninja = new ninjascript.NinjaScript(b);
  b.tools.inject(b);
  b.ninja.inject(b);
  return b.ninja
};
Ninja = ninjascript.build();
Ninja.orders = function(b) {
  b(window.Ninja)
};
ninjascript.tools.Overlay = function(b) {
  b = this.convertToElementArray(b);
  this.laziness = 0;
  var d = this;
  this.set = jQuery(jQuery.map(b, function(b, a) {
    return d.buildOverlayFor(b)
  }))
};
(function() {
  var b = ninjascript.utils.forEach, d = ninjascript.tools.Overlay.prototype;
  d.convertToElementArray = function(c) {
    var a = this;
    switch(typeof c) {
      case "undefined":
        return[];
      case "boolean":
        return[];
      case "string":
        return a.convertToElementArray(jQuery(c));
      case "function":
        return a.convertToElementArray(c());
      case "object":
        if("focus" in c && "blur" in c && !("jquery" in c)) {
          return[c]
        }
        if("length" in c && "0" in c) {
          var d = [];
          b(c, function(b) {
            d = d.concat(a.convertToElementArray(b))
          });
          return d
        }
        return[]
    }
  };
  d.buildOverlayFor = function(b) {
    var a = jQuery(document.createElement("div"));
    b = jQuery(b);
    var d = b.offset();
    a.css("position", "absolute");
    a.css("top", d.top);
    a.css("left", d.left);
    a.width(b.outerWidth());
    a.height(b.outerHeight());
    a.css("display", "none");
    return a[0]
  };
  d.affix = function() {
    this.set.appendTo(jQuery("body"));
    overlaySet = this.set;
    window.setTimeout(function() {
      overlaySet.css("display", "block")
    }, this.laziness)
  };
  d.remove = function() {
    this.set.remove()
  };
  ninjascript.plugin(function(b) {
    b.tools({overlay:function() {
      return new ninjascript.tools.Overlay(jQuery.makeArray(arguments))
    }, busyOverlay:function(a) {
      a = this.overlay(a);
      a.set.addClass("ninja_busy");
      a.laziness = this.ninja.config.busyLaziness;
      return a
    }, buildOverlayFor:function(a) {
      var b = jQuery(document.createElement("div"));
      a = jQuery(a);
      var c = a.offset();
      b.css("position", "absolute");
      b.css("top", c.top);
      b.css("left", c.left);
      b.width(a.outerWidth());
      b.height(a.outerHeight());
      b.css("zIndex", "2");
      return b
    }})
  })
})();
ninjascript.tools.AjaxSubmitter = function() {
  this.formData = [];
  this.action = "/";
  this.method = "GET";
  this.dataType = "script";
  return this
};
(function() {
  var b = ninjascript.Logger.log, d = ninjascript.tools.AjaxSubmitter.prototype;
  d.submit = function() {
    b("Computed prototype.method = " + this.method);
    jQuery.ajax(this.ajaxData())
  };
  d.sourceForm = function(b) {
    this.formData = jQuery(b).serializeArray()
  };
  d.ajaxData = function() {
    return{data:this.formData, dataType:this.dataType, url:this.action, type:this.method, complete:this.responseHandler(), success:this.successHandler(), error:this.onError}
  };
  d.successHandler = function() {
    var b = this;
    return function(a, d, f) {
      b.onSuccess(f, d, a)
    }
  };
  d.responseHandler = function() {
    var b = this;
    return function(a, d) {
      b.onResponse(a, d);
      Ninja.tools.fireMutationEvent()
    }
  };
  d.onResponse = function(b, a) {
  };
  d.onSuccess = function(b, a, d) {
  };
  d.onError = function(c, a, d) {
    b(c.responseText);
    Ninja.tools.message("Server prototype.error = " + c.statusText, "error")
  };
  ninjascript.plugin(function(b) {
    b.tools({ajaxSubmitter:function() {
      return new ninjascript.tools.AjaxSubmitter
    }, ajaxToJson:function(a) {
      a = this.ajaxSubmitter();
      var b = this.jsonDispatcher;
      a.dataType = "json";
      a.onSuccess = function(a, c, d) {
        b.dispatch(d)
      };
      return a
    }, overlayAndSubmit:function(a, b, c, d) {
      var n = this.busyOverlay(this.findOverlay(a));
      a = "undefined" == typeof d ? this.ajaxSubmitter() : this.ajaxToJson(d);
      a.sourceForm(b);
      a.action = c;
      a.method = this.extractMethod(b, a.formData);
      a.onResponse = function(a, b) {
        n.remove()
      };
      n.affix();
      a.submit()
    }})
  })
})();
ninjascript.tools.all = {};
ninjascript.loaded = {};
