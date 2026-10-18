// Dart Tutorial — small, dependency-free enhancements.
(function () {
  'use strict';
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
  var store = {
    get: function (k, d) { try { var v = localStorage.getItem(k); return v === null ? d : JSON.parse(v); } catch (e) { return d; } },
    set: function (k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} }
  };

  /* Theme */
  var themeBtn = $('[data-theme-toggle]');
  if (themeBtn) themeBtn.addEventListener('click', function () {
    var next = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
    document.documentElement.dataset.theme = next;
    try { localStorage.setItem('theme', next); } catch (e) {}
  });

  /* Mobile lesson menu */
  var side = $('#sidebar'), menuBtn = $('[data-menu]'), scrim = $('[data-scrim]');
  function setMenu(open) {
    if (!side) return;
    side.classList.toggle('is-open', open);
    if (scrim) scrim.hidden = !open;
    if (menuBtn) menuBtn.setAttribute('aria-expanded', String(open));
  }
  if (menuBtn) menuBtn.addEventListener('click', function () { setMenu(!side.classList.contains('is-open')); });
  if (scrim) scrim.addEventListener('click', function () { setMenu(false); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setMenu(false); });
  if (side) {
    var current = $('[aria-current="page"]', side);
    if (current && current.offsetTop > side.clientHeight - 80) side.scrollTop = current.offsetTop - side.clientHeight / 2;
  }

  /* Progress (kept in this browser only) */
  var done = store.get('dart-done', {});
  function paintProgress() {
    var links = $$('[data-lesson]');
    links.forEach(function (a) { a.classList.toggle('is-done', !!done[a.dataset.lesson]); });
    var all = {};
    $$('.side [data-lesson], .chapters [data-lesson]').forEach(function (a) { all[a.dataset.lesson] = 1; });
    var total = Object.keys(all).length;
    var count = Object.keys(all).filter(function (k) { return done[k]; }).length;
    $$('[data-progress-total]').forEach(function (box) {
      box.hidden = count === 0;
      $('[data-progress-text]', box).textContent = count + ' of ' + total + ' lessons done';
      $('[data-progress-bar]', box).style.width = (total ? (count / total) * 100 : 0) + '%';
    });
    var doneBtn = $('[data-done]');
    if (doneBtn) {
      var on = !!done[doneBtn.dataset.done];
      doneBtn.setAttribute('aria-pressed', String(on));
      doneBtn.textContent = on ? 'Lesson done ✓' : 'Mark lesson as done';
    }
  }
  var doneBtn = $('[data-done]');
  if (doneBtn) {
    doneBtn.addEventListener('click', function () {
      var k = doneBtn.dataset.done;
      if (done[k]) delete done[k]; else done[k] = 1;
      store.set('dart-done', done);
      paintProgress();
    });
    store.set('dart-last', { u: doneBtn.dataset.done, t: document.title.split(' | ')[0] });
  }
  paintProgress();
  var resume = $('[data-resume]'), last = store.get('dart-last', null);
  if (resume && last && last.u) { resume.href = last.u; resume.textContent = resume.dataset.resumeLabel; }

  /* Tables scroll sideways on small screens */
  $$('.prose table').forEach(function (t) {
    var w = document.createElement('div'); w.className = 'table-wrap';
    t.parentNode.insertBefore(w, t); w.appendChild(t);
  });

  /* Code blocks: label, copy, run in DartPad */
  var LABELS = { dart: 'Dart', output: 'Output', text: 'Text', bash: 'Terminal', sh: 'Terminal', shell: 'Terminal', yaml: 'YAML', json: 'JSON', powershell: 'PowerShell', javascript: 'JavaScript', js: 'JavaScript' };
  // Packages DartPad can load. Anything else, or dart:io, cannot run in the browser.
  var DARTPAD = /^(flutter|http|dio|provider|flutter_riverpod|hooks_riverpod|riverpod|flutter_hooks|flutter_bloc|bloc|go_router|shared_preferences|google_fonts|intl|collection|path|characters|async|equatable|rxdart|signals|signals_flutter|signals_core|flame|flame_forge2d|flame_tiled|flame_splash_screen|fl_chart|animations|url_launcher|flutter_svg|uuid|vector_math|fast_immutable_collections|meta|english_words|timezone)\//;
  function runnable(code) {
    if (!/\bmain\s*\(/.test(code)) return false;
    if (/dart:(io|isolate|ffi|mirrors)/.test(code)) return false;
    if (/Not standalone/.test(code)) return false;
    if (/\b(testWidgets|blocTest)\s*[<(]/.test(code)) return false;
    var re = /package:([\w\/.]+)/g, m;
    while ((m = re.exec(code))) { if (!DARTPAD.test(m[1])) return false; }
    // Flutter fragments: must import Flutter and define the screens they use.
    if (/\brunApp\s*\(/.test(code)) {
      if (!/package:flutter\//.test(code)) return false;
      var used = /\b([A-Z]\w*(?:App|Page|Screen|Shell|Gate|Demo))\s*\(/g;
      while ((m = used.exec(code))) {
        if (/^(MaterialApp|CupertinoApp|WidgetsApp|MaterialPage|CupertinoPage)$/.test(m[1])) continue;
        if (!new RegExp('class\\s+' + m[1] + '\\b').test(code)) return false;
      }
    }
    return true;
  }
  // Can this code be opened in the browser editor at all?
  function editable(code) {
    if (/dart:(io|isolate|ffi|mirrors)/.test(code)) return false;
    if (/Not standalone/.test(code)) return false;
    if (/\b(testWidgets|blocTest)\s*[<(]/.test(code) || /package:(test|flutter_test|integration_test)\//.test(code)) return false;
    var re = /package:([\w\/.]+)/g, m;
    while ((m = re.exec(code))) { if (!DARTPAD.test(m[1])) return false; }
    return code.split('\n').length > 2;
  }

  /* An editable DartPad, embedded in the page.
     Protocol (from DartPad's source, pkgs/dartpad_ui/lib/app/embed/web.dart):
     the frame posts {type: 'ready'} to its parent once loaded, then accepts
     {type: 'sourceCode', sourceCode}. With run=true it compiles and runs every
     snippet it receives.

     Two DartPad behaviours we work around:
     1. With run=true, DartPad first runs whatever code it last stored in its own
        browser storage (often the previous lesson's code), at the same moment we
        inject ours. Both compiles race and the stale one can finish last, so the
        wrong output appears. We inject again shortly after, so the final run is
        always the code on screen. The second send is skipped once the reader has
        started typing in the editor, so it never overwrites their edits.
     2. DartPad only runs on Run or Ctrl/Cmd+Enter, never on every keystroke. */
  var IS_MAC = /Mac|iPhone|iPad/.test(navigator.platform || navigator.userAgent);
  var RUN_KEYS = IS_MAC ? '⌘ + Enter' : 'Ctrl + Enter';
  var padCount = 0;
  function createPad(code, opts) {
    opts = opts || {};
    var wrap = document.createElement('div'); wrap.className = 'pad is-loading';
    var stage = document.createElement('div'); stage.className = 'pad-stage';
    var loader = document.createElement('div'); loader.className = 'pad-loader'; loader.setAttribute('role', 'status');
    loader.innerHTML = '<span class="pad-spin" aria-hidden="true"></span><span data-pad-loadtext>Loading the editor…</span>';
    var frame = null, ready = false, current = code, touched = false, timers = [];
    var later = function (fn, ms) { timers.push(setTimeout(fn, ms)); };
    var clearTimers = function () { timers.forEach(clearTimeout); timers = []; };
    var post = function (c) {
      if (!frame || !frame.contentWindow) return;
      try { frame.contentWindow.postMessage({ sourceCode: c, type: 'sourceCode' }, '*'); } catch (e) {}
    };
    // Send code and make sure it is what ends up running.
    var deliver = function (c) {
      current = c; touched = false;
      if (!ready) return; // sent on 'ready'
      post(c);
      later(function () { if (!touched && current === c) post(c); }, 1800);
    };
    var onMsg = function (e) {
      if (!frame || e.source !== frame.contentWindow || !e.data || e.data.type !== 'ready') return;
      ready = true;
      wrap.classList.remove('is-loading', 'is-slow'); wrap.classList.add('is-ready');
      deliver(current);
    };
    // Typing inside the cross-origin frame moves focus into it: that is our signal.
    var onBlur = function () { setTimeout(function () { if (document.activeElement === frame) touched = true; }, 0); };
    window.addEventListener('message', onMsg);
    window.addEventListener('blur', onBlur);

    var load = function () {
      clearTimers(); ready = false;
      wrap.classList.remove('is-ready', 'is-slow'); wrap.classList.add('is-loading');
      $('[data-pad-loadtext]', loader).textContent = 'Loading the editor…';
      if (frame) frame.remove();
      frame = document.createElement('iframe');
      frame.id = frame.name = 'dartpad-' + (++padCount);
      frame.title = 'Code editor: edit and run this example';
      frame.setAttribute('allow', 'clipboard-write');
      var theme = document.documentElement.dataset.theme === 'dark' ? 'dark' : 'light';
      // Cache-busting value: each editor is a fresh DartPad session.
      frame.src = 'https://dartpad.dev/?embed=true&run=true&theme=' + theme + '&v=' + Date.now().toString(36);
      stage.insertBefore(frame, loader);
      later(function () {
        if (ready) return;
        wrap.classList.add('is-slow');
        $('[data-pad-loadtext]', loader).textContent = 'Still loading. DartPad needs an internet connection…';
      }, 12000);
    };

    var note = document.createElement('div'); note.className = 'pad-note';
    var hint = document.createElement('span');
    hint.innerHTML = 'Edit the code, then press <strong>Run</strong> or <kbd>' + RUN_KEYS + '</kbd> to run your latest version.' + (opts.flutter ? ' The app appears on the right.' : '');
    note.appendChild(hint);
    var tools = document.createElement('span'); tools.className = 'pad-tools';
    var mk = function (label, title, fn) {
      var b = document.createElement('button'); b.type = 'button'; b.textContent = label; b.title = title;
      b.addEventListener('click', fn); tools.appendChild(b); return b;
    };
    if (opts.resettable !== false) mk('Reset code', 'Put the original example back and run it', function () { deliver(opts.original || code); });
    mk('Reload editor', 'Restart the editor if it stops responding', load);
    if (opts.playground) {
      var big = document.createElement('a'); big.href = opts.playground; big.textContent = 'Open in playground';
      big.addEventListener('click', function () { store.set('dart-pg-code', { code: current, t: Date.now() }); });
      tools.appendChild(big);
    }
    var ext = document.createElement('a'); ext.href = 'https://dartpad.dev/'; ext.target = '_blank'; ext.rel = 'noopener'; ext.textContent = 'DartPad ↗';
    tools.appendChild(ext);
    note.appendChild(tools);

    stage.appendChild(loader);
    wrap.appendChild(stage); wrap.appendChild(note);
    load();
    return {
      el: wrap,
      send: function (c, original) { if (original) opts.original = original; deliver(c); },
      destroy: function () {
        clearTimers();
        window.removeEventListener('message', onMsg); window.removeEventListener('blur', onBlur);
        if (wrap.parentNode) wrap.parentNode.removeChild(wrap);
      }
    };
  }

  var playgroundUrl = (document.body.getAttribute('data-playground') || '/playground/');
  var openPads = [];
  $$('.prose pre').forEach(function (pre) {
    var codeEl = $('code', pre); if (!codeEl) return;
    var lang = (codeEl.className.match(/language-([\w-]+)/) || [])[1] || codeEl.dataset.lang || 'text';
    var host = (pre.closest && pre.closest('.highlight')) || pre;
    var box = document.createElement('div');
    box.className = 'code' + (lang === 'output' ? ' is-output' : '');
    host.parentNode.insertBefore(box, host);
    var bar = document.createElement('div'); bar.className = 'code-bar';
    var label = document.createElement('span'); label.className = 'lang'; label.textContent = LABELS[lang] || lang;
    bar.appendChild(label);
    box.appendChild(bar); box.appendChild(host);
    var text = function () { return codeEl.textContent.replace(/\n+$/, '') + '\n'; };
    if (lang !== 'output') {
      var copy = document.createElement('button'); copy.type = 'button'; copy.textContent = 'Copy';
      copy.addEventListener('click', function () {
        var ok = function () { copy.textContent = 'Copied'; setTimeout(function () { copy.textContent = 'Copy'; }, 1600); };
        if (navigator.clipboard) navigator.clipboard.writeText(text()).then(ok, function () {});
      });
      bar.appendChild(copy);
    }
    if (lang !== 'dart') return;
    var code = text(), canRun = runnable(code);
    if (!canRun && !editable(code)) return;

    var pad = null, full = null, entry = null;
    var btn = document.createElement('button'); btn.type = 'button';
    var idle = canRun ? 'Run' : 'Edit';
    btn.className = canRun ? 'run' : 'edit'; btn.textContent = idle;
    btn.title = canRun ? 'Run this code here. You can edit it too.' : 'Open this code in the editor to complete and run it.';
    var setFull = function (on) {
      box.classList.toggle('is-full', on);
      document.documentElement.classList.toggle('pad-open', on);
      if (full) full.textContent = on ? 'Exit full screen' : 'Full screen';
    };
    var close = function () {
      if (!pad) return;
      pad.destroy(); pad = null; setFull(false);
      host.hidden = false; box.classList.remove('is-editing');
      if (full && full.parentNode) full.parentNode.removeChild(full);
      openPads = openPads.filter(function (x) { return x !== entry; });
      btn.textContent = idle; btn.setAttribute('aria-expanded', 'false');
    };
    entry = { close: close };
    btn.setAttribute('aria-expanded', 'false');
    btn.addEventListener('click', function () {
      if (pad) { close(); return; }
      // One live editor at a time keeps pages fast and avoids stray runs.
      openPads.slice().forEach(function (x) { x.close(); });
      pad = createPad(text(), { run: canRun, playground: playgroundUrl, flutter: /package:flutter\//.test(code) });
      // The editor replaces the static listing, so there is one copy of the code on screen.
      host.hidden = true; box.classList.add('is-editing');
      box.appendChild(pad.el);
      openPads.push(entry);
      btn.textContent = 'Close editor'; btn.setAttribute('aria-expanded', 'true');
      full = document.createElement('button'); full.type = 'button'; full.textContent = 'Full screen';
      full.addEventListener('click', function () { setFull(!box.classList.contains('is-full')); });
      bar.insertBefore(full, btn);
    });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && box.classList.contains('is-full')) setFull(false); });
    bar.appendChild(btn);
  });

  /* Playground page: write your own Dart or Flutter code */
  var pg = $('[data-pg]');
  if (pg) {
    var pgSamples = [];
    try { pgSamples = JSON.parse($('[data-pg-samples-json]', pg).textContent) || []; } catch (e) {}
    pgSamples = pgSamples.map(function (x) { return { track: x.track, title: x.title, code: String(x.code).replace(/^\n+/, '').replace(/\s+$/, '') + '\n' }; });
    var pgSelect = $('[data-pg-samples]', pg), pgMount = $('[data-pg-mount]', pg), pgTabs = $$('[data-pg-track]', pg);
    var handed = store.get('dart-pg-code', null);
    store.set('dart-pg-code', null);
    var pgTrack = pg.getAttribute('data-default-track') || 'dart';
    if (/[?&]track=flutter/.test(location.search) || location.hash === '#flutter') pgTrack = 'flutter';
    if (location.hash === '#game') pgTrack = 'game';
    if (handed && handed.code && Date.now() - handed.t < 60000) {
      if (/package:flutter\//.test(handed.code)) pgTrack = 'flutter';
      if (/package:flame\//.test(handed.code) && pgSamples.some(function (x) { return x.track === 'game'; })) pgTrack = 'game';
    } else { handed = null; }
    var pgFill = function () {
      pgSelect.innerHTML = '';
      pgSamples.forEach(function (x, i) {
        if (x.track !== pgTrack) return;
        var o = document.createElement('option'); o.value = String(i); o.textContent = x.title; pgSelect.appendChild(o);
      });
      pgTabs.forEach(function (t) { t.setAttribute('aria-pressed', String(t.dataset.pgTrack === pgTrack)); });
      pg.setAttribute('data-track', pgTrack);
    };
    var pgCurrent = function () { return pgSamples[Number(pgSelect.value)]; };
    pgFill();
    var first = handed ? handed.code : ((pgCurrent() || {}).code || '');
    var pgPad = createPad(first, { run: true, resettable: false });
    pgMount.appendChild(pgPad.el);
    var pgLoad = function () { var x = pgCurrent(); if (x) pgPad.send(x.code, x.code); };
    pgSelect.addEventListener('change', pgLoad);
    pgTabs.forEach(function (t) { t.addEventListener('click', function () {
      if (t.dataset.pgTrack === pgTrack) return;
      pgTrack = t.dataset.pgTrack; pgFill(); pgLoad();
    }); });
    var pgReset = $('[data-pg-reset]', pg);
    if (pgReset) pgReset.addEventListener('click', pgLoad);
  }

  /* Table of contents: highlight the section being read */
  /* One table of contents in the HTML; copied into the inline box for small screens. */
  var tocSrc = $('.toc nav'), tocDst = $('[data-toc-inline]');
  if (tocSrc && tocDst) { var tocCopy = tocSrc.cloneNode(true); tocCopy.removeAttribute('id'); tocCopy.setAttribute('aria-label', 'On this page'); tocDst.appendChild(tocCopy); }
  var tocLinks = $$('.toc a');
  if (tocLinks.length && 'IntersectionObserver' in window) {
    var map = {};
    tocLinks.forEach(function (a) { map[decodeURIComponent(a.hash.slice(1))] = a; });
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (!en.isIntersecting) return;
        tocLinks.forEach(function (a) { a.classList.remove('is-active'); });
        var a = map[en.target.id]; if (a) a.classList.add('is-active');
      });
    }, { rootMargin: '-80px 0px -70% 0px' });
    $$('.prose h2[id], .prose h3[id]').forEach(function (h) { io.observe(h); });
  }

  /* Tabs in the home page example */
  $$('[data-tabs]').forEach(function (group) {
    var tabs = $$('[role="tab"]', group);
    function select(tab) {
      tabs.forEach(function (t) {
        var on = t === tab;
        t.setAttribute('aria-selected', String(on));
        t.tabIndex = on ? 0 : -1;
        var panel = document.getElementById(t.dataset.tab);
        if (panel) panel.hidden = !on;
      });
    }
    tabs.forEach(function (tab, i) {
      tab.addEventListener('click', function () { select(tab); });
      tab.addEventListener('keydown', function (e) {
        if (e.key !== 'ArrowRight' && e.key !== 'ArrowLeft') return;
        var next = tabs[(i + (e.key === 'ArrowRight' ? 1 : -1) + tabs.length) % tabs.length];
        select(next); next.focus();
      });
    });
  });

  /* Reading progress line and back-to-top button */
  var readBar = $('[data-read-bar]'), toTop = $('[data-to-top]'), article = $('.doc');
  if (readBar || toTop) {
    var ticking = false;
    var onScroll = function () {
      ticking = false;
      var y = window.pageYOffset || document.documentElement.scrollTop;
      if (toTop) toTop.hidden = y < 700;
      if (readBar && article) {
        var max = document.documentElement.scrollHeight - window.innerHeight;
        readBar.style.width = (max > 0 ? Math.min(100, (y / max) * 100) : 0) + '%';
      }
    };
    window.addEventListener('scroll', function () {
      if (!ticking) { ticking = true; (window.requestAnimationFrame || setTimeout)(onScroll); }
    }, { passive: true });
    onScroll();
    if (toTop) toTop.addEventListener('click', function () {
      var smooth = !(window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches);
      try { window.scrollTo({ top: 0, behavior: smooth ? 'smooth' : 'auto' }); } catch (e) { window.scrollTo(0, 0); }
    });
  }

  /* Close the mobile menu when a lesson link inside it is chosen */
  if (side) side.addEventListener('click', function (e) {
    if (e.target && e.target.closest && e.target.closest('a')) setMenu(false);
  });

  /* Search: results appear as you type */
  var box = $('[data-search]');
  if (box) {
    var input = $('input', box), list = $('.search-results', box), index = null, loading = false, sel = -1;
    var esc = function (s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); };
    var load = function () {
      if (index || loading) return; loading = true;
      if (!window.fetch) return;
      fetch(box.dataset.index).then(function (r) { return r.json(); }).then(function (d) { index = d; render(); }).catch(function () { loading = false; });
    };
    var close = function () { list.hidden = true; input.setAttribute('aria-expanded', 'false'); sel = -1; };
    var mark = function (s, words) {
      var out = esc(s);
      words.forEach(function (w) { out = out.replace(new RegExp('(' + w.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'ig'), '<mark>$1</mark>'); });
      return out;
    };
    function render() {
      var q = input.value.trim().toLowerCase();
      if (!q || !index) { close(); return; }
      var words = q.split(/\s+/);
      var hits = [];
      index.forEach(function (p) {
        var t = p.t.toLowerCase(), rest = (p.d + ' ' + p.k + ' ' + p.h + ' ' + p.s).toLowerCase(), score = 0;
        for (var i = 0; i < words.length; i++) {
          var w = words[i];
          if (t.indexOf(w) === 0) score += 12; else if (t.indexOf(w) > -1) score += 8; else if (rest.indexOf(w) > -1) score += 2; else return;
        }
        if (t === q) score += 20;
        hits.push({ p: p, s: score });
      });
      hits.sort(function (a, b) { return b.s - a.s; });
      hits = hits.slice(0, 8);
      list.innerHTML = hits.length ? hits.map(function (h, i) {
        return '<li role="option" id="sr-' + i + '"><a href="' + esc(h.p.u) + '">' + mark(h.p.t, words) + '<small>' + esc(h.p.s) + ' — ' + esc(h.p.d) + '</small></a></li>';
      }).join('') : '<li class="empty">No lesson matches “' + esc(input.value.trim()) + '”. Try a shorter word, like “list” or “async”.</li>';
      list.hidden = false; input.setAttribute('aria-expanded', 'true'); sel = -1;
    }
    input.addEventListener('focus', load);
    input.addEventListener('input', function () { load(); render(); });
    input.addEventListener('keydown', function (e) {
      var items = $$('li[role="option"]', list);
      if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        if (!items.length) return; e.preventDefault();
        sel = (sel + (e.key === 'ArrowDown' ? 1 : -1) + items.length) % items.length;
        items.forEach(function (li, i) { li.setAttribute('aria-selected', String(i === sel)); });
        items[sel].scrollIntoView({ block: 'nearest' });
      } else if (e.key === 'Enter') {
        var pick = items[sel < 0 ? 0 : sel]; if (pick) { e.preventDefault(); location.href = $('a', pick).href; }
      } else if (e.key === 'Escape') { close(); input.blur(); }
    });
    document.addEventListener('click', function (e) { if (!box.contains(e.target)) close(); });
    document.addEventListener('keydown', function (e) {
      var el = document.activeElement, typing = !!el && (/INPUT|TEXTAREA|SELECT/.test(el.tagName) || el.isContentEditable);
      if ((e.key === '/' && !typing) || (e.key && e.key.toLowerCase() === 'k' && (e.ctrlKey || e.metaKey))) { e.preventDefault(); input.focus(); input.select(); }
    });
  }
})();

/* Language picker: close on outside click or Escape */
(function () {
  var pick = document.querySelector('[data-lang-pick]');
  if (!pick) return;
  document.addEventListener('click', function (e) { if (pick.open && !pick.contains(e.target)) pick.open = false; });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && pick.open) { pick.open = false; pick.querySelector('summary').focus(); } });
})();

/* Translate buttons (Google Translate copy) and share buttons, built on click */
(function () {
  document.addEventListener('click', function (e) {
    var g = e.target.closest('[data-gt]');
    if (g) {
      var l = g.getAttribute('data-gt');
      location.href = 'https://' + g.getAttribute('data-gt-host') + g.getAttribute('data-gt-path') + '?_x_tr_sl=en&_x_tr_tl=' + l + '&_x_tr_hl=' + l + '&_x_tr_pto=wapp';
      return;
    }
    var b = e.target.closest('[data-share]');
    if (!b) return;
    var box = b.closest('[data-share-url]'), u = box.getAttribute('data-share-url'), t = box.getAttribute('data-share-title');
    var eu = encodeURIComponent(u), et = encodeURIComponent(t), k = b.getAttribute('data-share');
    if (k === 'native') { navigator.share({ title: t, url: u }).catch(function () {}); return; }
    if (k === 'copy') {
      (navigator.clipboard ? navigator.clipboard.writeText(u) : Promise.reject()).then(function () { b.textContent = 'Copied ✓'; setTimeout(function () { b.textContent = 'Copy link'; }, 1800); }, function () { prompt('Copy this link', u); });
      return;
    }
    var map = {
      whatsapp: 'https://wa.me/?text=' + et + '%20' + eu,
      facebook: 'https://www.facebook.com/sharer/sharer.php?u=' + eu,
      x: 'https://x.com/intent/post?url=' + eu + '&text=' + et,
      linkedin: 'https://www.linkedin.com/sharing/share-offsite/?url=' + eu
    };
    window.open(map[k], '_blank', 'noopener');
  });
  if (navigator.share) document.querySelectorAll('[data-share="native"]').forEach(function (n) { n.hidden = false; });
})();
