/**
 * @preserve
 * jquery.layout 1.4.4
 * $Date: 2014-11-29 08:00:00 (Sat, 29 November 2014) $
 * $Rev: 1.0404 $
 *
 * Copyright (c) 2014 Kevin Dalman (http://jquery-dev.com)
 * Based on work by Fabrizio Balliano (http://www.fabrizioballiano.net)
 *
 * Dual licensed under the GPL (http://www.gnu.org/licenses/gpl.html)
 * and MIT (http://www.opensource.org/licenses/mit-license.php) licenses.
 *
 * SEE: http://layout.jquery-dev.com/LICENSE.txt
 *
 * Changelog: http://layout.jquery-dev.com/changelog.cfm
 *
 * Docs: http://layout.jquery-dev.com/documentation.html
 * Tips: http://layout.jquery-dev.com/tips.html
 * Help: http://groups.google.com/group/jquery-ui-layout
 */

/* JavaDoc Info: http://code.google.com/closure/compiler/docs/js-for-compiler.html
 * {!Object}	non-nullable type (never NULL)
 * {?string}	nullable type (sometimes NULL) - default for {Object}
 * {number=}	optional parameter
 * {*}			ALL types
 */
/*	TODO for jQ 2.x 
 *	check $.fn.disableSelection - this is in jQuery UI 1.9.x
 */

// NOTE: For best readability, view with a fixed-width font and tabs equal to 4-chars

;(function ($) {

// alias Math methods - used a lot!
var	min		= Math.min
,	max		= Math.max
,	round	= Math.floor

,	isStr	=  function (v) { return $.type(v) === "string"; }

	/**
	 * @param {!Object}			Instance
	 * @param {Array.<string>}	a_fn
	 */
,	runPluginCallbacks = function (Instance, a_fn) {
		if ($.isArray(a_fn))
			for (var i=0, c=a_fn.length; i<c; i++) {
				var fn = a_fn[i];
				try {
					if (isStr(fn)) // 'name' of a function
						fn = eval(fn);
					if ($.isFunction(fn))
						g(fn)( Instance );
				} catch (ex) {}
			}
		function g (f) { return f; }; // compiler hack
	}
;

/*
 *	GENERIC $.layout METHODS - used by all layouts
 */
$.layout = {

	version:	"1.4.4"
,	revision:	1.0404 // eg: ver 1.4.4 = rev 1.0404 - major(n+).minor(nn)+patch(nn+)

	// $.layout.browser REPLACES $.browser
,	browser:	{} // set below

	// *PREDEFINED* EFFECTS & DEFAULTS 
	// MUST list effect here - OR MUST set an fxSettings option (can be an empty hash: {})
,	effects: {

	//	Pane Open/Close Animations
		slide: {
			all:	{ duration:  "fast"	} // eg: duration: 1000, easing: "easeOutBounce"
		,	north:	{ direction: "up"	}
		,	south:	{ direction: "down"	}
		,	east:	{ direction: "right"}
		,	west:	{ direction: "left"	}
		}
	,	drop: {
			all:	{ duration:  "slow"	}
		,	north:	{ direction: "up"	}
		,	south:	{ direction: "down"	}
		,	east:	{ direction: "right"}
		,	west:	{ direction: "left"	}
		}
	,	scale: {
			all:	{ duration:	"fast"	}
		}
	//	these are not recommended, but can be used
	,	blind:		{}
	,	clip:		{}
	,	explode:	{}
	,	fade:		{}
	,	fold:		{}
	,	puff:		{}

	//	Pane Resize Animations
	,	size: {
			all:	{ easing:	"swing"	}
		}
	}

	// INTERNAL CONFIG DATA - DO NOT CHANGE THIS!
,	config: {
		optionRootKeys:	"effects,panes,north,south,west,east,center".split(",")
	,	allPanes:		"north,south,west,east,center".split(",")
	,	borderPanes:	"north,south,west,east".split(",")
	,	oppositeEdge: {
			north:	"south"
		,	south:	"north"
		,	east: 	"west"
		,	west: 	"east"
		}
	//	offscreen data
	,	offscreenCSS:	{ left: "-99999px", right: "auto" } // used by hide/close if useOffscreenClose=true
	,	offscreenReset:	"offscreenReset" // key used for data
	//	CSS used in multiple places
	,	hidden:		{ visibility: "hidden" }
	,	visible:	{ visibility: "visible" }
	//	layout element settings
	,	resizers: {
			cssReq: {
				position: 	"absolute"
			,	padding: 	0
			,	margin: 	0
			,	fontSize:	"1px"
			,	textAlign:	"left"	// to counter-act "center" alignment!
			,	overflow: 	"hidden" // prevent toggler-button from overflowing
			//	SEE $.layout.defaults.zIndexes.resizer_normal
			}
		,	cssDemo: { // DEMO CSS - applied if: options.PANE.applyDemoStyles=true
				background: "#DDD"
			,	border:		"none"
			}
		}
	,	togglers: {
			cssReq: {
				position: 	"absolute"
			,	display: 	"block"
			,	padding: 	0
			,	margin: 	0
			,	overflow:	"hidden"
			,	textAlign:	"center"
			,	fontSize:	"1px"
			,	cursor: 	"pointer"
			,	zIndex: 	1
			}
		,	cssDemo: { // DEMO CSS - applied if: options.PANE.applyDemoStyles=true
				background: "#AAA"
			}
		}
	,	content: {
			cssReq: {
				position:	"relative" /* contain floated or positioned elements */
			}
		,	cssDemo: { // DEMO CSS - applied if: options.PANE.applyDemoStyles=true
				overflow:	"auto"
			,	padding:	"10px"
			}
		,	cssDemoPane: { // DEMO CSS - REMOVE scrolling from 'pane' when it has a content-div
				overflow:	"hidden"
			,	padding:	0
			}
		}
	,	panes: { // defaults for ALL panes - overridden by 'per-pane settings' below
			cssReq: {
				position: 	"absolute"
			,	margin:		0
			//	$.layout.defaults.zIndexes.pane_normal
			}
		,	cssDemo: { // DEMO CSS - applied if: options.PANE.applyDemoStyles=true
				padding:	"10px"
			,	background:	"#FFF"
			,	border:		"1px solid #BBB"
			,	overflow:	"auto"
			}
		}
	,	north: {
			side:			"top"
		,	sizeType:		"Height"
		,	dir:			"horz"
		,	cssReq: {
				top: 		0
			,	bottom: 	"auto"
			,	left: 		0
			,	right: 		0
			,	width: 		"auto"
			//	height: 	DYNAMIC
			}
		}
	,	south: {
			side:			"bottom"
		,	sizeType:		"Height"
		,	dir:			"horz"
		,	cssReq: {
				top: 		"auto"
			,	bottom: 	0
			,	left: 		0
			,	right: 		0
			,	width: 		"auto"
			//	height: 	DYNAMIC
			}
		}
	,	east: {
			side:			"right"
		,	sizeType:		"Width"
		,	dir:			"vert"
		,	cssReq: {
				left: 		"auto"
			,	right: 		0
			,	top: 		"auto" // DYNAMIC
			,	bottom: 	"auto" // DYNAMIC
			,	height: 	"auto"
			//	width: 		DYNAMIC
			}
		}
	,	west: {
			side:			"left"
		,	sizeType:		"Width"
		,	dir:			"vert"
		,	cssReq: {
				left: 		0
			,	right: 		"auto"
			,	top: 		"auto" // DYNAMIC
			,	bottom: 	"auto" // DYNAMIC
			,	height: 	"auto"
			//	width: 		DYNAMIC
			}
		}
	,	center: {
			dir:			"center"
		,	cssReq: {
				left: 		"auto" // DYNAMIC
			,	right: 		"auto" // DYNAMIC
			,	top: 		"auto" // DYNAMIC
			,	bottom: 	"auto" // DYNAMIC
			,	height: 	"auto"
			,	width: 		"auto"
			}
		}
	}

	// CALLBACK FUNCTION NAMESPACE - used to store reusable callback functions
,	callbacks: {}

,	getParentPaneElem: function (el) {
		// must pass either a container or pane element
		var $el = $(el)
		,	layout = $el.data("layout") || $el.data("parentLayout");
		if (layout) {
			var $cont = layout.container;
			// see if this container is directly-nested inside an outer-pane
			if ($cont.data("layoutPane")) return $cont;
			var $pane = $cont.closest("."+ $.layout.defaults.panes.paneClass);
			// if a pane was found, return it
			if ($pane.data("layoutPane")) return $pane;
		}
		return null;
	}

,	getParentPaneInstance: function (el) {
		// must pass either a container or pane element
		var $pane = $.layout.getParentPaneElem(el);
		return $pane ? $pane.data("layoutPane") : null;
	}

,	getParentLayoutInstance: function (el) {
		// must pass either a container or pane element
		var $pane = $.layout.getParentPaneElem(el);
		return $pane ? $pane.data("parentLayout") : null;
	}

,	getEventObject: function (evt) {
		return typeof evt === "object" && evt.stopPropagation ? evt : null;
	}
,	parsePaneName: function (evt_or_pane) {
		var evt = $.layout.getEventObject( evt_or_pane )
		,	pane = evt_or_pane;
		if (evt) {
			// ALWAYS stop propagation of events triggered in Layout!
			evt.stopPropagation();
			pane = $(this).data("layoutEdge");
		}
		if (pane && !/^(west|east|north|south|center)$/.test(pane)) {
			$.layout.msg('LAYOUT ERROR - Invalid pane-name: "'+ pane +'"');
			pane = "error";
		}
		return pane;
	}


	// LAYOUT-PLUGIN REGISTRATION
	// more plugins can added beyond this default list
,	plugins: {
		draggable:		!!$.fn.draggable // resizing
	,	effects: {
			core:		!!$.effects		// animimations (specific effects tested by initOptions)
		,	slide:		$.effects && ($.effects.slide || ($.effects.effect && $.effects.effect.slide)) // default effect
		}
	}

//	arrays of plugin or other methods to be triggered for events in *each layout* - will be passed 'Instance'
,	onCreate:	[]	// runs when layout is just starting to be created - right after options are set
,	onLoad:		[]	// runs after layout container and global events init, but before initPanes is called
,	onReady:	[]	// runs after initialization *completes* - ie, after initPanes completes successfully
,	onDestroy:	[]	// runs after layout is destroyed
,	onUnload:	[]	// runs after layout is destroyed OR when page unloads
,	afterOpen:	[]	// runs after setAsOpen() completes
,	afterClose:	[]	// runs after setAsClosed() completes

	/*
	 *	GENERIC UTILITY METHODS
	 */

	// calculate and return the scrollbar width, as an integer
,	scrollbarWidth:		function () { return window.scrollbarWidth  || $.layout.getScrollbarSize('width'); }
,	scrollbarHeight:	function () { return window.scrollbarHeight || $.layout.getScrollbarSize('height'); }
,	getScrollbarSize:	function (dim) {
		var $c	= $('<div style="position: absolute; top: -10000px; left: -10000px; width: 100px; height: 100px; border: 0; overflow: scroll;"></div>').appendTo("body")
		,	d	= { width: $c.outerWidth - $c[0].clientWidth, height: 100 - $c[0].clientHeight };
		$c.remove();
		window.scrollbarWidth	= d.width;
		window.scrollbarHeight	= d.height;
		return dim.match(/^(width|height)$/) ? d[dim] : d;
	}


,	disableTextSelection: function () {
		var $d	= $(document)
		,	s	= 'textSelectionDisabled'
		,	x	= 'textSelectionInitialized'
		;
		if ($.fn.disableSelection) {
			if (!$d.data(x)) // document hasn't been initialized yet
				$d.on('mouseup', $.layout.enableTextSelection ).data(x, true);
			if (!$d.data(s))
				$d.disableSelection().data(s, true);
		}
	}
,	enableTextSelection: function () {
		var $d	= $(document)
		,	s	= 'textSelectionDisabled';
		if ($.fn.enableSelection && $d.data(s))
			$d.enableSelection().data(s, false);
	}


	/**
	 * Returns hash container 'display' and 'visibility'
	 *
	 * @see	$.swap() - swaps CSS, runs callback, resets CSS
	 * @param  {!Object}		$E				jQuery element
	 * @param  {boolean=}	[force=false]	Run even if display != none
	 * @return {!Object}						Returns current style props, if applicable
	 */
,	showInvisibly: function ($E, force) {
		if ($E && $E.length && (force || $E.css("display") === "none")) { // only if not *already hidden*
			var s = $E[0].style
				// save ONLY the 'style' props because that is what we must restore
			,	CSS = { display: s.display || '', visibility: s.visibility || '' };
			// show element 'invisibly' so can be measured
			$E.css({ display: "block", visibility: "hidden" });
			return CSS;
		}
		return {};
	}

	/**
	 * Returns data for setting size of an element (container or a pane).
	 *
	 * @see  _create(), onWindowResize() for container, plus others for pane
	 * @return JSON  Returns a hash of all dimensions: top, bottom, left, right, outerWidth, innerHeight, etc
	 */
,	getElementDimensions: function ($E, inset) {
		var
		//	dimensions hash - start with current data IF passed
			d	= { css: {}, inset: {} }
		,	x	= d.css			// CSS hash
		,	i	= { bottom: 0 }	// TEMP insets (bottom = complier hack)
		,	N	= $.layout.cssNum
		,	R	= Math.round
		,	off = $E.offset()
		,	b, p, ei			// TEMP border, padding
		;
		d.offsetLeft = off.left;
		d.offsetTop  = off.top;

		if (!inset) inset = {}; // simplify logic below

		$.each("Left,Right,Top,Bottom".split(","), function (idx, e) { // e = edge
			b = x["border" + e] = $.layout.borderWidth($E, e);
			p = x["padding"+ e] = $.layout.cssNum($E, "padding"+e);
			ei = e.toLowerCase();
			d.inset[ei] = inset[ei] >= 0 ? inset[ei] : p; // any missing insetX value = paddingX
			i[ei] = d.inset[ei] + b; // total offset of content from outer side
		});

		x.width		= R($E.width());
		x.height	= R($E.height());
		x.top		= N($E,"top",true);
		x.bottom	= N($E,"bottom",true);
		x.left		= N($E,"left",true);
		x.right		= N($E,"right",true);

		d.outerWidth	= R($E.outerWidth());
		d.outerHeight	= R($E.outerHeight());
		// calc the TRUE inner-dimensions, even in quirks-mode!
		d.innerWidth	= max(0, d.outerWidth  - i.left - i.right);
		d.innerHeight	= max(0, d.outerHeight - i.top  - i.bottom);
		// layoutWidth/Height is used in calcs for manual resizing
		// layoutW/H only differs from innerW/H when in quirks-mode - then is like outerW/H
		d.layoutWidth	= R($E.innerWidth());
		d.layoutHeight	= R($E.innerHeight());

		//if ($E.prop('tagName') === 'BODY') { debugData( d, $E.prop('tagName') ); } // DEBUG

		//d.visible	= $E.is(":visible");// && x.width > 0 && x.height > 0;

		return d;
	}

,	getElementStyles: function ($E, list) {
		var
			CSS	= {}
		,	style	= $E[0].style
		,	props	= list.split(",")
		,	sides	= "Top,Bottom,Left,Right".split(",")
		,	attrs	= "Color,Style,Width".split(",")
		,	p, s, a, i, j, k
		;
		for (i=0; i < props.length; i++) {
			p = props[i];
			if (p.match(/(border|padding|margin)$/))
				for (j=0; j < 4; j++) {
					s = sides[j];
					if (p === "border")
						for (k=0; k < 3; k++) {
							a = attrs[k];
							CSS[p+s+a] = style[p+s+a];
						}
					else
						CSS[p+s] = style[p+s];
				}
			else
				CSS[p] = style[p];
		};
		return CSS
	}

	/**
	 * Return the innerWidth for the current browser/doctype
	 *
	 * @see  initPanes(), sizeMidPanes(), initHandles(), sizeHandles()
	 * @param  {Array.<Object>}	$E  Must pass a jQuery object - first element is processed
	 * @param  {number=}			outerWidth (optional) Can pass a width, allowing calculations BEFORE element is resized
	 * @return {number}			Returns the innerWidth of the elem by subtracting padding and borders
	 */
,	cssWidth: function ($E, outerWidth) {
		// a 'calculated' outerHeight can be passed so borders and/or padding are removed if needed
		if (outerWidth <= 0) return 0;

		var lb	= $.layout.browser
		,	bs	= !lb.boxModel ? "border-box" : lb.boxSizing ? $E.css("boxSizing") : "content-box"
		,	b	= $.layout.borderWidth
		,	n	= $.layout.cssNum
		,	W	= outerWidth
		;
		// strip border and/or padding from outerWidth to get CSS Width
		if (bs !== "border-box")
			W -= (b($E, "Left") + b($E, "Right"));
		if (bs === "content-box")
			W -= (n($E, "paddingLeft") + n($E, "paddingRight"));
		return max(0,W);
	}

	/**
	 * Return the innerHeight for the current browser/doctype
	 *
	 * @see  initPanes(), sizeMidPanes(), initHandles(), sizeHandles()
	 * @param  {Array.<Object>}	$E  Must pass a jQuery object - first element is processed
	 * @param  {number=}			outerHeight  (optional) Can pass a width, allowing calculations BEFORE element is resized
	 * @return {number}			Returns the innerHeight of the elem by subtracting padding and borders
	 */
,	cssHeight: function ($E, outerHeight) {
		// a 'calculated' outerHeight can be passed so borders and/or padding are removed if needed
		if (outerHeight <= 0) return 0;

		var lb	= $.layout.browser
		,	bs	= !lb.boxModel ? "border-box" : lb.boxSizing ? $E.css("boxSizing") : "content-box"
		,	b	= $.layout.borderWidth
		,	n	= $.layout.cssNum
		,	H	= outerHeight
		;
		// strip border and/or padding from outerHeight to get CSS Height
		if (bs !== "border-box")
			H -= (b($E, "Top") + b($E, "Bottom"));
		if (bs === "content-box")
			H -= (n($E, "paddingTop") + n($E, "paddingBottom"));
		return max(0,H);
	}

	/**
	 * Returns the 'current CSS numeric value' for a CSS property - 0 if property does not exist
	 *
	 * @see  Called by many methods
	 * @param {Array.<Object>}	$E					Must pass a jQuery object - first element is processed
	 * @param {string}			prop				The name of the CSS property, eg: top, width, etc.
	 * @param {boolean=}			[allowAuto=false]	true = return 'auto' if that is value; false = return 0
	 * @return {(string|number)}						Usually used to get an integer value for position (top, left) or size (height, width)
	 */
,	cssNum: function ($E, prop, allowAuto) {
		if (!$E.jquery) $E = $($E);
		var CSS = $.layout.showInvisibly($E)
		,	p	= $.css($E[0], prop, true)
		,	v	= allowAuto && p=="auto" ? p : Math.round(parseFloat(p) || 0);
		$E.css( CSS ); // RESET
		return v;
	}

,	borderWidth: function (el, side) {
		if (el.jquery) el = el[0];
		var b = "border"+ side.substr(0,1).toUpperCase() + side.substr(1); // left => Left
		return $.css(el, b+"Style", true) === "none" ? 0 : Math.round(parseFloat($.css(el, b+"Width", true)) || 0);
	}

	/**
	 * Mouse-tracking utility - FUTURE REFERENCE
	 *
	 * init: if (!window.mouse) {
	 *			window.mouse = { x: 0, y: 0 };
	 *			$(document).mousemove( $.layout.trackMouse );
	 *		}
	 *
	 * @param {Object}		evt
	 *
,	trackMouse: function (evt) {
		window.mouse = { x: evt.clientX, y: evt.clientY };
	}
	*/

	/**
	 * SUBROUTINE for preventPrematureSlideClose option
	 *
	 * @param {Object}		evt
	 * @param {Object=}		el
	 */
,	isMouseOverElem: function (evt, el) {
		var
			$E	= $(el || this)
		,	d	= $E.offset()
		,	T	= d.top
		,	L	= d.left
		,	R	= L + $E.outerWidth()
		,	B	= T + $E.outerHeight()
		,	x	= evt.pageX	// evt.clientX ?
		,	y	= evt.pageY	// evt.clientY ?
		;
		// if X & Y are < 0, probably means is over an open SELECT
		return ($.layout.browser.msie && x < 0 && y < 0) || ((x >= L && x <= R) && (y >= T && y <= B));
	}

	/**
	 * Message/Logging Utility
	 *
	 * @example $.layout.msg("My message");				// log text
	 * @example $.layout.msg("My message", true);		// alert text
	 * @example $.layout.msg({ foo: "bar" }, "Title");	// log hash-data, with custom title
	 * @example $.layout.msg({ foo: "bar" }, true, "Title", { sort: false }); -OR-
	 * @example $.layout.msg({ foo: "bar" }, "Title", { sort: false, display: true }); // alert hash-data
	 *
	 * @param {(Object|string)}			info			String message OR Hash/Array
	 * @param {(Boolean|string|Object)=}	[popup=false]	True means alert-box - can be skipped
	 * @param {(Object|string)=}			[debugTitle=""]	Title for Hash data - can be skipped
	 * @param {Object=}					[debugOpts]		Extra options for debug output
	 */
,	msg: function (info, popup, debugTitle, debugOpts) {
		if ($.isPlainObject(info) && window.debugData) {
			if (typeof popup === "string") {
				debugOpts	= debugTitle;
				debugTitle	= popup;
			}
			else if (typeof debugTitle === "object") {
				debugOpts	= debugTitle;
				debugTitle	= null;
			}
			var t = debugTitle || "log( <object> )"
			,	o = $.extend({ sort: false, returnHTML: false, display: false }, debugOpts);
			if (popup === true || o.display)
				debugData( info, t, o );
			else if (window.console)
				console.log(debugData( info, t, o ));
		}
		else if (popup)
			alert(info);
		else if (window.console)
			console.log(info);
		else {
			var id	= "#layoutLogger"
			,	$l = $(id);
			if (!$l.length)
				$l = createLog();
			$l.children("ul").append('<li style="padding: 4px 10px; margin: 0; border-top: 1px solid #CCC;">'+ info.replace(/\</g,"&lt;").replace(/\>/g,"&gt;") +'</li>');
		}

		function createLog () {
			var pos = $.support.fixedPosition ? 'fixed' : 'absolute'
			,	$e = $('<div id="layoutLogger" style="position: '+ pos +'; top: 5px; z-index: 999999; max-width: 25%; overflow: hidden; border: 1px solid #000; border-radius: 5px; background: #FBFBFB; box-shadow: 0 2px 10px rgba(0,0,0,0.3);">'
				+	'<div style="font-size: 13px; font-weight: bold; padding: 5px 10px; background: #F6F6F6; border-radius: 5px 5px 0 0; cursor: move;">'
				+	'<span style="float: right; padding-left: 7px; cursor: pointer;" title="Remove Console" onclick="$(this).closest(\'#layoutLogger\').remove()">X</span>Layout console.log</div>'
				+	'<ul style="font-size: 13px; font-weight: none; list-style: none; margin: 0; padding: 0 0 2px;"></ul>'
				+ '</div>'
				).appendTo("body");
			$e.css('left', $(window).width() - $e.outerWidth() - 5)
			if ($.ui.draggable) $e.draggable({ handle: ':first-child' });
			return $e;
		};
	}

};


/*
 *	$.layout.browser REPLACES removed $.browser, with extra data
 *	Parsing code here adapted from jQuery 1.8 $.browse
 */
(function(){
	var u = navigator.userAgent.toLowerCase()
	,	m = /(chrome)[ \/]([\w.]+)/.exec( u )
		||	/(webkit)[ \/]([\w.]+)/.exec( u )
		||	/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( u )
		||	/(msie) ([\w.]+)/.exec( u )
		||	u.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( u )
		||	[]
	,	b = m[1] || ""
	,	v = m[2] || 0
	,	ie = b === "msie"
	,	cm = document.compatMode
	,	$s = $.support
	,	bs = $s.boxSizing !== undefined ? $s.boxSizing : $s.boxSizingReliable
	,	bm = !ie || !cm || cm === "CSS1Compat" || $s.boxModel || false
	,	lb = $.layout.browser = {
			version:	v
		,	safari:		b === "webkit"	// webkit (NOT chrome) = safari
		,	webkit:		b === "chrome"	// chrome = webkit
		,	msie:		ie
		,	isIE6:		ie && v == 6
			// ONLY IE reverts to old box-model - Note that compatMode was deprecated as of IE8
		,	boxModel:	bm
		,	boxSizing:	!!(typeof bs === "function" ? bs() : bs)
		};
	;
	if (b) lb[b] = true; // set CURRENT browser
	/*	OLD versions of jQuery only set $.support.boxModel after page is loaded
	 *	so if this is IE, use support.boxModel to test for quirks-mode (ONLY IE changes boxModel) */
	if (!bm && !cm) $(function(){ lb.boxModel = $s.boxModel; });
})();


// DEFAULT OPTIONS
$.layout.defaults = {
/*
 *	LAYOUT & LAYOUT-CONTAINER OPTIONS
 *	- none of these options are applicable to individual panes
 */
	name:						""			// Not required, but useful for buttons and used for the state-cookie
,	containerClass:				"ui-layout-container" // layout-container element
,	inset:						null		// custom container-inset values (override padding)
,	scrollToBookmarkOnLoad:		true		// after creating a layout, scroll to bookmark in URL (.../page.htm#myBookmark)
,	resizeWithWindow:			true		// bind thisLayout.resizeAll() to the window.resize event
,	resizeWithWindowDelay:		200			// delay calling resizeAll because makes window resizing very jerky
,	resizeWithWindowMaxDelay:	0			// 0 = none - force resize every XX ms while window is being resized
,	maskPanesEarly:				false		// true = create pane-masks on resizer.mouseDown instead of waiting for resizer.dragstart
,	onresizeall_start:			null		// CALLBACK when resizeAll() STARTS	- NOT pane-specific
,	onresizeall_end:			null		// CALLBACK when resizeAll() ENDS	- NOT pane-specific
,	onload_start:				null		// CALLBACK when Layout inits - after options initialized, but before elements
,	onload_end:					null		// CALLBACK when Layout inits - after EVERYTHING has been initialized
,	onunload_start:				null		// CALLBACK when Layout is destroyed OR onWindowUnload
,	onunload_end:				null		// CALLBACK when Layout is destroyed OR onWindowUnload
,	initPanes:					true		// false = DO NOT initialize the panes onLoad - will init later
,	showErrorMessages:			true		// enables fatal error messages to warn developers of common errors
,	showDebugMessages:			false		// display console-and-alert debug msgs - IF this Layout version _has_ debugging code!
//	Changing this zIndex value will cause other zIndex values to automatically change
,	zIndex:						null		// the PANE zIndex - resizers and masks will be +1
//	DO NOT CHANGE the zIndex values below unless you clearly understand their relationships
,	zIndexes: {								// set _default_ z-index values here...
		pane_normal:			0			// normal z-index for panes
	,	content_mask:			1			// applied to overlays used to mask content INSIDE panes during resizing
	,	resizer_normal:			2			// normal z-index for resizer-bars
	,	pane_sliding:			100			// applied to *BOTH* the pane and its resizer when a pane is 'slid open'
	,	pane_animate:			1000		// applied to the pane when being animated - not applied to the resizer
	,	resizer_drag:			10000		// applied to the CLONED resizer-bar when being 'dragged'
	}
,	errors: {
		pane:					"pane"		// description of "layout pane element" - used only in error messages
	,	selector:				"selector"	// description of "jQuery-selector" - used only in error messages
	,	addButtonError:			"Error Adding Button\nInvalid "
	,	containerMissing:		"UI Layout Initialization Error\nThe specified layout-container does not exist."
	,	centerPaneMissing:		"UI Layout Initialization Error\nThe center-pane element does not exist.\nThe center-pane is a required element."
	,	noContainerHeight:		"UI Layout Initialization Warning\nThe layout-container \"CONTAINER\" has no height.\nTherefore the layout is 0-height and hence 'invisible'!"
	,	callbackError:			"UI Layout Callback Error\nThe EVENT callback is not a valid function."
	}
/*
 *	PANE DEFAULT SETTINGS
 *	- settings under the 'panes' key become the default settings for *all panes*
 *	- ALL pane-options can also be set specifically for each panes, which will override these 'default values'
 */
,	panes: { // default options for 'all panes' - will be overridden by 'per-pane settings'
		applyDemoStyles: 		false		// NOTE: renamed from applyDefaultStyles for clarity
	,	closable:				true		// pane can open & close
	,	resizable:				true		// when open, pane can be resized 
	,	slidable:				true		// when closed, pane can 'slide open' over other panes - closes on mouse-out
	,	initClosed:				false		// true = init pane as 'closed'
	,	initHidden: 			false 		// true = init pane as 'hidden' - no resizer-bar/spacing
	//	SELECTORS
	//,	paneSelector:			""			// MUST be pane-specific - jQuery selector for pane
	,	contentSelector:		".ui-layout-content" // INNER div/element to auto-size so only it scrolls, not the entire pane!
	,	contentIgnoreSelector:	".ui-layout-ignore"	// element(s) to 'ignore' when measuring 'content'
	,	findNestedContent:		false		// true = $P.find(contentSelector), false = $P.children(contentSelector)
	//	GENERIC ROOT-CLASSES - for auto-generated classNames
	,	paneClass:				"ui-layout-pane"	// Layout Pane
	,	resizerClass:			"ui-layout-resizer"	// Resizer Bar
	,	togglerClass:			"ui-layout-toggler"	// Toggler Button
	,	buttonClass:			"ui-layout-button"	// CUSTOM Buttons	- eg: '[ui-layout-button]-toggle/-open/-close/-pin'
	//	ELEMENT SIZE & SPACING
	//,	size:					100			// MUST be pane-specific -initial size of pane
	,	minSize:				0			// when manually resizing a pane
	,	maxSize:				0			// ditto, 0 = no limit
	,	spacing_open:			6			// space between pane and adjacent panes - when pane is 'open'
	,	spacing_closed:			6			// ditto - when pane is 'closed'
	,	togglerLength_open:		50			// Length = WIDTH of toggler button on north/south sides - HEIGHT on east/west sides
	,	togglerLength_closed: 	50			// 100% OR -1 means 'full height/width of resizer bar' - 0 means 'hidden'
	,	togglerAlign_open:		"center"	// top/left, bottom/right, center, OR...
	,	togglerAlign_closed:	"center"	// 1 => nn = offset from top/left, -1 => -nn == offset from bottom/right
	,	togglerContent_open:	""			// text or HTML to put INSIDE the toggler
	,	togglerContent_closed:	""			// ditto
	//	RESIZING OPTIONS
	,	resizerDblClickToggle:	true		// 
	,	autoResize:				true		// IF size is 'auto' or a percentage, then recalc 'pixel size' whenever the layout resizes
	,	autoReopen:				true		// IF a pane was auto-closed due to noRoom, reopen it when there is room? False = leave it closed
	,	resizerDragOpacity:		1			// option for ui.draggable
	//,	resizerCursor:			""			// MUST be pane-specific - cursor when over resizer-bar
	,	maskContents:			false		// true = add DIV-mask over-or-inside this pane so can 'drag' over IFRAMES
	,	maskObjects:			false		// true = add IFRAME-mask over-or-inside this pane to cover objects/applets - content-mask will overlay this mask
	,	maskZindex:				null		// will override zIndexes.content_mask if specified - not applicable to iframe-panes
	,	resizingGrid:			false		// grid size that the resizers will snap-to during resizing, eg: [20,20]
	,	livePaneResizing:		false		// true = LIVE Resizing as resizer is dragged
	,	liveContentResizing:	false		// true = re-measure header/footer heights as resizer is dragged
	,	liveResizingTolerance:	1			// how many px change before pane resizes, to control performance
	//	SLIDING OPTIONS
	,	sliderCursor:			"pointer"	// cursor when resizer-bar will trigger 'sliding'
	,	slideTrigger_open:		"click"		// click, dblclick, mouseenter
	,	slideTrigger_close:		"mouseleave"// click, mouseleave
	,	slideDelay_open:		300			// applies only for mouseenter event - 0 = instant open
	,	slideDelay_close:		300			// applies only for mouseleave event (300ms is the minimum!)
	,	hideTogglerOnSlide:		false		// when pane is slid-open, should the toggler show?
	,	preventQuickSlideClose:	$.layout.browser.webkit // Chrome triggers slideClosed as it is opening
	,	preventPrematureSlideClose: false	// handle incorrect mouseleave trigger, like when over a SELECT-list in IE
	//	PANE-SPECIFIC TIPS & MESSAGES
	,	tips: {
			Open:				"Open"		// eg: "Open Pane"
		,	Close:				"Close"
		,	Resize:				"Resize"
		,	Slide:				"Slide Open"
		,	Pin:				"Pin"
		,	Unpin:				"Un-Pin"
		,	noRoomToOpen:		"Not enough room to show this panel."	// alert if user tries to open a pane that cannot
		,	minSizeWarning:		"Panel has reached its minimum size"	// displays in browser statusbar
		,	maxSizeWarning:		"Panel has reached its maximum size"	// ditto
		}
	//	HOT-KEYS & MISC
	,	showOverflowOnHover:	false		// will bind allowOverflow() utility to pane.onMouseOver
	,	enableCursorHotkey:		true		// enabled 'cursor' hotkeys
	//,	customHotkey:			""			// MUST be pane-specific - EITHER a charCode OR a character
	,	customHotkeyModifier:	"SHIFT"		// either 'SHIFT', 'CTRL' or 'CTRL+SHIFT' - NOT 'ALT'
	//	PANE ANIMATION
	//	NOTE: fxSss_open, fxSss_close & fxSss_size options (eg: fxName_open) are auto-generated if not passed
	,	fxName:					"slide" 	// ('none' or blank), slide, drop, scale -- only relevant to 'open' & 'close', NOT 'size'
	,	fxSpeed:				null		// slow, normal, fast, 200, nnn - if passed, will OVERRIDE fxSettings.duration
	,	fxSettings:				{}			// can be passed, eg: { easing: "easeOutBounce", duration: 1500 }
	,	fxOpacityFix:			true		// tries to fix opacity in IE to restore anti-aliasing after animation
	,	animatePaneSizing:		false		// true = animate resizing after dragging resizer-bar OR sizePane() is called
	/*  NOTE: Action-specific FX options are auto-generated from the options above if not specifically set:
		fxName_open:			"slide"		// 'Open' pane animation
		fnName_close:			"slide"		// 'Close' pane animation
		fxName_size:			"slide"		// 'Size' pane animation - when animatePaneSizing = true
		fxSpeed_open:			null
		fxSpeed_close:			null
		fxSpeed_size:			null
		fxSettings_open:		{}
		fxSettings_close:		{}
		fxSettings_size:		{}
	*/
	//	CHILD/NESTED LAYOUTS
	,	children:				null		// Layout-options for nested/child layout - even {} is valid as options
	,	containerSelector:		''			// if child is NOT 'directly nested', a selector to find it/them (can have more than one child layout!)
	,	initChildren:			true		// true = child layout will be created as soon as _this_ layout completes initialization
	,	destroyChildren:		true		// true = destroy child-layout if this pane is destroyed
	,	resizeChildren:			true		// true = trigger child-layout.resizeAll() when this pane is resized
	//	EVENT TRIGGERING
	,	triggerEventsOnLoad:	false		// true = trigger onopen OR onclose callbacks when layout initializes
	,	triggerEventsDuringLiveResize: true	// true = trigger onresize callback REPEATEDLY if livePaneResizing==true
	//	PANE CALLBACKS
	,	onshow_start:			null		// CALLBACK when pane STARTS to Show	- BEFORE onopen/onhide_start
	,	onshow_end:				null		// CALLBACK when pane ENDS being Shown	- AFTER  onopen/onhide_end
	,	onhide_start:			null		// CALLBACK when pane STARTS to Close	- BEFORE onclose_start
	,	onhide_end:				null		// CALLBACK when pane ENDS being Closed	- AFTER  onclose_end
	,	onopen_start:			null		// CALLBACK when pane STARTS to Open
	,	onopen_end:				null		// CALLBACK when pane ENDS being Opened
	,	onclose_start:			null		// CALLBACK when pane STARTS to Close
	,	onclose_end:			null		// CALLBACK when pane ENDS being Closed
	,	onresize_start:			null		// CALLBACK when pane STARTS being Resized ***FOR ANY REASON***
	,	onresize_end:			null		// CALLBACK when pane ENDS being Resized ***FOR ANY REASON***
	,	onsizecontent_start:	null		// CALLBACK when sizing of content-element STARTS
	,	onsizecontent_end:		null		// CALLBACK when sizing of content-element ENDS
	,	onswap_start:			null		// CALLBACK when pane STARTS to Swap
	,	onswap_end:				null		// CALLBACK when pane ENDS being Swapped
	,	ondrag_start:			null		// CALLBACK when pane STARTS being ***MANUALLY*** Resized
	,	ondrag_end:				null		// CALLBACK when pane ENDS being ***MANUALLY*** Resized
	}
/*
 *	PANE-SPECIFIC SETTINGS
 *	- options listed below MUST be specified per-pane - they CANNOT be set under 'panes'
 *	- all options under the 'panes' key can also be set specifically for any pane
 *	- most options under the 'panes' key apply only to 'border-panes' - NOT the the center-pane
 */
,	north: {
		paneSelector:			".ui-layout-north"
	,	size:					"auto"		// eg: "auto", "30%", .30, 200
	,	resizerCursor:			"n-resize"	// custom = url(myCursor.cur)
	,	customHotkey:			""			// EITHER a charCode (43) OR a character ("o")
	}
,	south: {
		paneSelector:			".ui-layout-south"
	,	size:					"auto"
	,	resizerCursor:			"s-resize"
	,	customHotkey:			""
	}
,	east: {
		paneSelector:			".ui-layout-east"
	,	size:					200
	,	resizerCursor:			"e-resize"
	,	customHotkey:			""
	}
,	west: {
		paneSelector:			".ui-layout-west"
	,	size:					200
	,	resizerCursor:			"w-resize"
	,	customHotkey:			""
	}
,	center: {
		paneSelector:			".ui-layout-center"
	,	minWidth:				0
	,	minHeight:				0
	}
};

$.layout.optionsMap = {
	// layout/global options - NOT pane-options
	layout: ("name,instanceKey,stateManagement,effects,inset,zIndexes,errors,"
	+	"zIndex,scrollToBookmarkOnLoad,showErrorMessages,maskPanesEarly,"
	+	"outset,resizeWithWindow,resizeWithWindowDelay,resizeWithWindowMaxDelay,"
	+	"onresizeall,onresizeall_start,onresizeall_end,onload,onload_start,onload_end,onunload,onunload_start,onunload_end").split(",")
//	borderPanes: [ ALL options that are NOT specified as 'layout' ]
	// default.panes options that apply to the center-pane (most options apply _only_ to border-panes)
,	center: ("paneClass,contentSelector,contentIgnoreSelector,findNestedContent,applyDemoStyles,triggerEventsOnLoad,"
	+	"showOverflowOnHover,maskContents,maskObjects,liveContentResizing,"
	+	"containerSelector,children,initChildren,resizeChildren,destroyChildren,"
	+	"onresize,onresize_start,onresize_end,onsizecontent,onsizecontent_start,onsizecontent_end").split(",")
	// options that MUST be specifically set 'per-pane' - CANNOT set in the panes (defaults) key
,	noDefault: ("paneSelector,resizerCursor,customHotkey").split(",")
};

/**
 * Processes options passed in converts flat-format data into subkey (JSON) format
 * In flat-format, subkeys are _currently_ separated with 2 underscores, like north__optName
 * Plugins may also call this method so they can transform their own data
 *
 * @param  {!Object}	hash			Data/options passed by user - may be a single level or nested levels
 * @param  {boolean=}	[addKeys=false]	Should the primary layout.options keys be added if they do not exist?
 * @return {Object}						Returns hash of minWidth & minHeight
 */
$.layout.transformData = function (hash, addKeys) {
	var	json = addKeys ? { panes: {}, center: {} } : {} // init return object
	,	branch, optKey, keys, key, val, i, c;

	if (typeof hash !== "object") return json; // no options passed

	// convert all 'flat-keys' to 'sub-key' format
	for (optKey in hash) {
		branch	= json;
		val		= hash[ optKey ];
		keys	= optKey.split("__"); // eg: west__size or north__fxSettings__duration
		c		= keys.length - 1;
		// convert underscore-delimited to subkeys
		for (i=0; i <= c; i++) {
			key = keys[i];
			if (i === c) {	// last key = value
				if ($.isPlainObject( val ))
					branch[key] = $.layout.transformData( val ); // RECURSE
				else
					branch[key] = val;
			}
			else {
				if (!branch[key])
					branch[key] = {}; // create the subkey
				// recurse to sub-key for next loop - if not done
				branch = branch[key];
			}
		}
	}
	return json;
};

// INTERNAL CONFIG DATA - DO NOT CHANGE THIS!
$.layout.backwardCompatibility = {
	// data used by renameOldOptions()
	map: {
	//	OLD Option Name:			NEW Option Name
		applyDefaultStyles:			"applyDemoStyles"
	//	CHILD/NESTED LAYOUTS
	,	childOptions:				"children"
	,	initChildLayout:			"initChildren"
	,	destroyChildLayout:			"destroyChildren"
	,	resizeChildLayout:			"resizeChildren"
	,	resizeNestedLayout:			"resizeChildren"
	//	MISC Options
	,	resizeWhileDragging:		"livePaneResizing"
	,	resizeContentWhileDragging:	"liveContentResizing"
	,	triggerEventsWhileDragging:	"triggerEventsDuringLiveResize"
	,	maskIframesOnResize:		"maskContents"
	//	STATE MANAGEMENT
	,	useStateCookie:				"stateManagement.enabled"
	,	"cookie.autoLoad":			"stateManagement.autoLoad"
	,	"cookie.autoSave":			"stateManagement.autoSave"
	,	"cookie.keys":				"stateManagement.stateKeys"
	,	"cookie.name":				"stateManagement.cookie.name"
	,	"cookie.domain":			"stateManagement.cookie.domain"
	,	"cookie.path":				"stateManagement.cookie.path"
	,	"cookie.expires":			"stateManagement.cookie.expires"
	,	"cookie.secure":			"stateManagement.cookie.secure"
	//	OLD Language options
	,	noRoomToOpenTip:			"tips.noRoomToOpen"
	,	togglerTip_open:			"tips.Close"	// open   = Close
	,	togglerTip_closed:			"tips.Open"		// closed = Open
	,	resizerTip:					"tips.Resize"
	,	sliderTip:					"tips.Slide"
	}

/**
* @param {Object}	opts
*/
,	renameOptions: function (opts) {
		var map = $.layout.backwardCompatibility.map
		,	oldData, newData, value
		;
		for (var itemPath in map) {
			oldData	= getBranch( itemPath );
			value	= oldData.branch[ oldData.key ];
			if (value !== undefined) {
				newData = getBranch( map[itemPath], true );
				newData.branch[ newData.key ] = value;
				delete oldData.branch[ oldData.key ];
			}
		}

		/**
		 * @param {string}	path
		 * @param {boolean=}	[create=false]	Create path if does not exist
		 */
		function getBranch (path, create) {
			var a = path.split(".") // split keys into array
			,	c = a.length - 1
			,	D = { branch: opts, key: a[c] } // init branch at top & set key (last item)
			,	i = 0, k, undef;
			for (; i<c; i++) { // skip the last key (data)
				k = a[i];
				if (D.branch[ k ] == undefined) { // child-key does not exist
					if (create) {
						D.branch = D.branch[ k ] = {}; // create child-branch
					}
					else // can't go any farther
						D.branch = {}; // branch is undefined
				}
				else
					D.branch = D.branch[ k ]; // get child-branch
			}
			return D;
		};
	}

/**
* @param {Object}	opts
*/
,	renameAllOptions: function (opts) {
		var ren = $.layout.backwardCompatibility.renameOptions;
		// rename root (layout) options
		ren( opts );
		// rename 'defaults' to 'panes'
		if (opts.defaults) {
			if (typeof opts.panes !== "object")
				opts.panes = {};
			$.extend(true, opts.panes, opts.defaults);
			delete opts.defaults;
		}
		// rename options in the the options.panes key
		if (opts.panes) ren( opts.panes );
		// rename options inside *each pane key*, eg: options.west
		$.each($.layout.config.allPanes, function (i, pane) {
			if (opts[pane]) ren( opts[pane] );
		});	
		return opts;
	}
};




/*	============================================================
 *	BEGIN WIDGET: $( selector ).layout( {options} );
 *	============================================================
 */
$.fn.layout = function (opts) {
	var

	// local aliases to global data
	browser	= $.layout.browser
,	_c		= $.layout.config

	// local aliases to utlity methods
,	cssW	= $.layout.cssWidth
,	cssH	= $.layout.cssHeight
,	elDims	= $.layout.getElementDimensions
,	styles	= $.layout.getElementStyles
,	evtObj	= $.layout.getEventObject
,	evtPane	= $.layout.parsePaneName

/**
 * options - populated by initOptions()
 */
,	options = $.extend(true, {}, $.layout.defaults)
,	effects	= options.effects = $.extend(true, {}, $.layout.effects)

/**
 * layout-state object
 */
,	state = {
		// generate unique ID to use for event.namespace so can unbind only events added by 'this layout'
		id:				"layout"+ $.now()	// code uses alias: sID
	,	initialized:	false
	,	paneResizing:	false
	,	panesSliding:	{}
	,	container:	{ 	// list all keys referenced in code to avoid compiler error msgs
			innerWidth:		0
		,	innerHeight:	0
		,	outerWidth:		0
		,	outerHeight:	0
		,	layoutWidth:	0
		,	layoutHeight:	0
		}
	,	north:		{ childIdx: 0 }
	,	south:		{ childIdx: 0 }
	,	east:		{ childIdx: 0 }
	,	west:		{ childIdx: 0 }
	,	center:		{ childIdx: 0 }
	}

/**
 * parent/child-layout pointers
 */
//,	hasParentLayout	= false	- exists ONLY inside Instance so can be set externally
,	children = {
		north:		null
	,	south:		null
	,	east:		null
	,	west:		null
	,	center:		null
	}

/*
 * ###########################
 *  INTERNAL HELPER FUNCTIONS
 * ###########################
 */

	/**
	 * Manages all internal timers
	 */
,	timer = {
		data:	{}
	,	set:	function (s, fn, ms) { timer.clear(s); timer.data[s] = setTimeout(fn, ms); }
	,	clear:	function (s) { var t=timer.data; if (t[s]) {clearTimeout(t[s]); delete t[s];} }
	}

	/**
	 * Alert or console.log a message - IF option is enabled.
	 *
	 * @param {(string|!Object)}	msg				Message (or debug-data) to display
	 * @param {boolean=}			[popup=false]	True by default, means 'alert', false means use console.log
	 * @param {boolean=}			[debug=false]	True means is a widget debugging message
	 */
,	_log = function (msg, popup, debug) {
		var o = options;
		if ((o.showErrorMessages && !debug) || (debug && o.showDebugMessages))
			$.layout.msg( o.name +' / '+ msg, (popup !== false) );
		return false;
	}

	/**
	 * Executes a Callback function after a trigger event, like resize, open or close
	 *
	 * @param {string}				evtName					Name of the layout callback, eg "onresize_start"
	 * @param {(string|boolean)=}	[pane=""]				This is passed only so we can pass the 'pane object' to the callback
	 * @param {(string|boolean)=}	[skipBoundEvents=false]	True = do not run events bound to the elements - only the callbacks set in options
	 */
,	_runCallbacks = function (evtName, pane, skipBoundEvents) {
		var	hasPane	= pane && isStr(pane)
		,	s		= hasPane ? state[pane] : state
		,	o		= hasPane ? options[pane] : options
		,	lName	= options.name
			// names like onopen and onopen_end separate are interchangeable in options...
		,	lng		= evtName + (evtName.match(/_/) ? "" : "_end")
		,	shrt	= lng.match(/_end$/) ? lng.substr(0, lng.length - 4) : ""
		,	fn		= o[lng] || o[shrt]
		,	retVal	= "NC" // NC = No Callback
		,	args	= []
		,	$P		= hasPane ? $Ps[pane] : 0
		;
		if (hasPane && !$P) // a pane is specified, but does not exist!
			return retVal;
		if ( !hasPane && $.type(pane) === "boolean" ) {
			skipBoundEvents = pane; // allow pane param to be skipped for Layout callback
			pane = "";
		}

		// first trigger the callback set in the options
		if (fn) {
			try {
				// convert function name (string) to function object
				if (isStr( fn )) {
					if (fn.match(/,/)) {
						// function name cannot contain a comma, 
						// so must be a function name AND a parameter to pass
						args = fn.split(",")
						,	fn = eval(args[0]);
					}
					else // just the name of an external function?
						fn = eval(fn);
				}
				// execute the callback, if exists
				if ($.isFunction( fn )) {
					if (args.length)
						retVal = g(fn)(args[1]); // pass the argument parsed from 'list'
					else if ( hasPane )
						// pass data: pane-name, pane-element, pane-state, pane-options, and layout-name
						retVal = g(fn)( pane, $Ps[pane], s, o, lName );
					else // must be a layout/container callback - pass suitable info
						retVal = g(fn)( Instance, s, o, lName );
				}
			}
			catch (ex) {
				_log( options.errors.callbackError.replace(/EVENT/, $.trim((pane || "") +" "+ lng)), false );
				if ($.type(ex) === "string" && string.length)
					_log("Exception:  "+ ex, false );
			}
		}

		// trigger additional events bound directly to the pane
		if (!skipBoundEvents && retVal !== false) {
			if ( hasPane ) { // PANE events can be bound to each pane-elements
				o	= options[pane];
				s	= state[pane];
				$P.triggerHandler("layoutpane"+ lng, [ pane, $P, s, o, lName ]);
				if (shrt)
					$P.triggerHandler("layoutpane"+ shrt, [ pane, $P, s, o, lName ]);
			}
			else { // LAYOUT events can be bound to the container-element
				$N.triggerHandler("layout"+ lng, [ Instance, s, o, lName ]);
				if (shrt)
					$N.triggerHandler("layout"+ shrt, [ Instance, s, o, lName ]);
			}
		}

		// ALWAYS resizeChildren after an onresize_end event - even during initialization
		// IGNORE onsizecontent_end event because causes child-layouts to resize TWICE
		if (hasPane && evtName === "onresize_end") // BAD: || evtName === "onsizecontent_end"
			resizeChildren(pane+"", true); // compiler hack -force string

		return retVal;

		function g (f) { return f; }; // compiler hack
	}


	/**
	 * cure iframe display issues in IE & other browsers
	 */
,	_fixIframe = function (pane) {
		if (browser.mozilla) return; // skip FireFox - it auto-refreshes iframes onShow
		var $P = $Ps[pane];
		// if the 'pane' is an iframe, do it
		if (state[pane].tagName === "IFRAME")
			$P.css(_c.hidden).css(_c.visible); 
		else // ditto for any iframes INSIDE the pane
			$P.find('IFRAME').css(_c.hidden).css(_c.visible);
	}

	/**
	 * @param  {string}		pane		Can accept ONLY a 'pane' (east, west, etc)
	 * @param  {number=}		outerSize	(optional) Can pass a width, allowing calculations BEFORE element is resized
	 * @return {number}		Returns the innerHeight/Width of el by subtracting padding and borders
	 */
,	cssSize = function (pane, outerSize) {
		var fn = _c[pane].dir=="horz" ? cssH : cssW;
		return fn($Ps[pane], outerSize);
	}

	/**
	 * @param  {string}		pane		Can accept ONLY a 'pane' (east, west, etc)
	 * @return {Object}		Returns hash of minWidth & minHeight
	 */
,	cssMinDims = function (pane) {
		// minWidth/Height means CSS width/height = 1px
		var	$P	= $Ps[pane]
		,	dir	= _c[pane].dir
		,	d	= {
				minWidth:	1001 - cssW($P, 1000)
			,	minHeight:	1001 - cssH($P, 1000)
			}
		;
		if (dir === "horz") d.minSize = d.minHeight;
		if (dir === "vert") d.minSize = d.minWidth;
		return d;
	}

	// TODO: see if these methods can be made more useful...
	// TODO: *maybe* return cssW/H from these so caller can use this info

	/**
	 * @param {(string|!Object)}		el
	 * @param {number=}				outerWidth
	 * @param {boolean=}				[autoHide=false]
	 */
,	setOuterWidth = function (el, outerWidth, autoHide) {
		var $E = el, w;
		if (isStr(el)) $E = $Ps[el]; // west
		else if (!el.jquery) $E = $(el);
		w = cssW($E, outerWidth);
		$E.css({ width: w });
		if (w > 0) {
			if (autoHide && $E.data('autoHidden') && $E.innerHeight() > 0) {
				$E.show().data('autoHidden', false);
				if (!browser.mozilla) // FireFox refreshes iframes - IE does not
					// make hidden, then visible to 'refresh' display after animation
					$E.css(_c.hidden).css(_c.visible);
			}
		}
		else if (autoHide && !$E.data('autoHidden'))
			$E.hide().data('autoHidden', true);
	}

	/**
	 * @param {(string|!Object)}		el
	 * @param {number=}				outerHeight
	 * @param {boolean=}				[autoHide=false]
	 */
,	setOuterHeight = function (el, outerHeight, autoHide) {
		var $E = el, h;
		if (isStr(el)) $E = $Ps[el]; // west
		else if (!el.jquery) $E = $(el);
		h = cssH($E, outerHeight);
		$E.css({ height: h, visibility: "visible" }); // may have been 'hidden' by sizeContent
		if (h > 0 && $E.innerWidth() > 0) {
			if (autoHide && $E.data('autoHidden')) {
				$E.show().data('autoHidden', false);
				if (!browser.mozilla) // FireFox refreshes iframes - IE does not
					$E.css(_c.hidden).css(_c.visible);
			}
		}
		else if (autoHide && !$E.data('autoHidden'))
			$E.hide().data('autoHidden', true);
	}


	/**
	 * Converts any 'size' params to a pixel/integer size, if not already
	 * If 'auto' or a decimal/percentage is passed as 'size', a pixel-size is calculated
	 *
	/**
	 * @param  {string}				pane
	 * @param  {(string|number)=}	size
	 * @param  {string=}				[dir]
	 * @return {number}
	 */
,	_parseSize = function (pane, size, dir) {
		if (!dir) dir = _c[pane].dir;

		if (isStr(size) && size.match(/%/))
			size = (size === '100%') ? -1 : parseInt(size, 10) / 100; // convert % to decimal

		if (size === 0)
			return 0;
		else if (size >= 1)
			return parseInt(size, 10);

		var o = options, avail = 0;
		if (dir=="horz") // north or south or center.minHeight
			avail = sC.innerHeight - ($Ps.north ? o.north.spacing_open : 0) - ($Ps.south ? o.south.spacing_open : 0);
		else if (dir=="vert") // east or west or center.minWidth
			avail = sC.innerWidth - ($Ps.west ? o.west.spacing_open : 0) - ($Ps.east ? o.east.spacing_open : 0);

		if (size === -1) // -1 == 100%
			return avail;
		else if (size > 0) // percentage, eg: .25
			return round(avail * size);
		else if (pane=="center")
			return 0;
		else { // size < 0 || size=='auto' || size==Missing || size==Invalid
			// auto-size the pane
			var	dim	= (dir === "horz" ? "height" : "width")
			,	$P	= $Ps[pane]
			,	$C	= dim === 'height' ? $Cs[pane] : false
			,	vis	= $.layout.showInvisibly($P) // show pane invisibly if hidden
			,	szP	= $P.css(dim) // SAVE current pane size
			,	szC	= $C ? $C.css(dim) : 0 // SAVE current content size
			;
			$P.css(dim, "auto");
			if ($C) $C.css(dim, "auto");
			size = (dim === "height") ? $P.outerHeight() : $P.outerWidth(); // MEASURE
			$P.css(dim, szP).css(vis); // RESET size & visibility
			if ($C) $C.css(dim, szC);
			return size;
		}
	}

	/**
	 * Calculates current 'size' (outer-width or outer-height) of a border-pane - optionally with 'pane-spacing' added
	 *
	 * @param  {(string|!Object)}	pane
	 * @param  {boolean=}			[inclSpace=false]
	 * @return {number}				Returns EITHER Width for east/west panes OR Height for north/south panes
	 */
,	getPaneSize = function (pane, inclSpace) {
		var 
			$P	= $Ps[pane]
		,	o	= options[pane]
		,	s	= state[pane]
		,	oSp	= (inclSpace ? o.spacing_open : 0)
		,	cSp	= (inclSpace ? o.spacing_closed : 0)
		;
		if (!$P || s.isHidden)
			return 0;
		else if (s.isClosed || (s.isSliding && inclSpace))
			return cSp;
		else if (_c[pane].dir === "horz")
			return $P.outerHeight() + oSp;
		else // dir === "vert"
			return $P.outerWidth() + oSp;
	}

	/**
	 * Calculate min/max pane dimensions and limits for resizing
	 *
	 * @param  {string}		pane
	 * @param  {boolean=}	[slide=false]
	 */
,	setSizeLimits = function (pane, slide) {
		if (!isInitialized()) return;
		var 
			o				= options[pane]
		,	s				= state[pane]
		,	c				= _c[pane]
		,	dir				= c.dir
		,	type			= c.sizeType.toLowerCase()
		,	isSliding		= (slide != undefined ? slide : s.isSliding) // only open() passes 'slide' param
		,	$P				= $Ps[pane]
		,	paneSpacing		= o.spacing_open
		//	measure the pane on the *opposite side* from this pane
		,	altPane			= _c.oppositeEdge[pane]
		,	altS			= state[altPane]
		,	$altP			= $Ps[altPane]
		,	altPaneSize		= (!$altP || altS.isVisible===false || altS.isSliding ? 0 : (dir=="horz" ? $altP.outerHeight() : $altP.outerWidth()))
		,	altPaneSpacing	= ((!$altP || altS.isHidden ? 0 : options[altPane][ altS.isClosed !== false ? "spacing_closed" : "spacing_open" ]) || 0)
		//	limitSize prevents this pane from 'overlapping' opposite pane
		,	containerSize	= (dir=="horz" ? sC.innerHeight : sC.innerWidth)
		,	minCenterDims	= cssMinDims("center")
		,	minCenterSize	= dir=="horz" ? max(options.center.minHeight, minCenterDims.minHeight) : max(options.center.minWidth, minCenterDims.minWidth)
		//	if pane is 'sliding', then ignore center and alt-pane sizes - because 'overlays' them
		,	limitSize		= (containerSize - paneSpacing - (isSliding ? 0 : (_parseSize("center", minCenterSize, dir) + altPaneSize + altPaneSpacing)))
		,	minSize			= s.minSize = max( _parseSize(pane, o.minSize), cssMinDims(pane).minSize )
		,	maxSize			= s.maxSize = min( (o.maxSize ? _parseSize(pane, o.maxSize) : 100000), limitSize )
		,	r				= s.resizerPosition = {} // used to set resizing limits
		,	top				= sC.inset.top
		,	left			= sC.inset.left
		,	W				= sC.innerWidth
		,	H				= sC.innerHeight
		,	rW				= o.spacing_open // subtract resizer-width to get top/left position for south/east
		;
		switch (pane) {
			case "north":	r.min = top + minSize;
							r.max = top + maxSize;
							break;
			case "west":	r.min = left + minSize;
							r.max = left + maxSize;
							break;
			case "south":	r.min = top + H - maxSize - rW;
							r.max = top + H - minSize - rW;
							break;
			case "east":	r.min = left + W - maxSize - rW;
							r.max = left + W - minSize - rW;
							break;
		};
	}

	/**
	 * Returns data for setting the size/position of center pane. Also used to set Height for east/west panes
	 *
	 * @return JSON  Returns a hash of all dimensions: top, bottom, left, right, (outer) width and (outer) height
	 */
,	calcNewCenterPaneDims = function () {
		var d = {
			top:	getPaneSize("north", true) // true = include 'spacing' value for pane
		,	bottom:	getPaneSize("south", true)
		,	left:	getPaneSize("west", true)
		,	right:	getPaneSize("east", true)
		,	width:	0
		,	height:	0
		};

		// NOTE: sC = state.container
		// calc center-pane outer dimensions
		d.width		= sC.innerWidth - d.left - d.right;  // outerWidth
		d.height	= sC.innerHeight - d.bottom - d.top; // outerHeight
		// add the 'container border/padding' to get final positions relative to the container
		d.top		+= sC.inset.top;
		d.bottom	+= sC.inset.bottom;
		d.left		+= sC.inset.left;
		d.right		+= sC.inset.right;

		return d;
	}


	/**
	 * @param {!Object}		el
	 * @param {boolean=}		[allStates=false]
	 */
,	getHoverClasses = function (el, allStates) {
		var
			$El		= $(el)
		,	type	= $El.data("layoutRole")
		,	pane	= $El.data("layoutEdge")
		,	o		= options[pane]
		,	root	= o[type +"Class"]
		,	_pane	= "-"+ pane // eg: "-west"
		,	_open	= "-open"
		,	_closed	= "-closed"
		,	_slide	= "-sliding"
		,	_hover	= "-hover " // NOTE the trailing space
		,	_state	= $El.hasClass(root+_closed) ? _closed : _open
		,	_alt	= _state === _closed ? _open : _closed
		,	classes = (root+_hover) + (root+_pane+_hover) + (root+_state+_hover) + (root+_pane+_state+_hover)
		;
		if (allStates) // when 'removing' classes, also remove alternate-state classes
			classes += (root+_alt+_hover) + (root+_pane+_alt+_hover);

		if (type=="resizer" && $El.hasClass(root+_slide))
			classes += (root+_slide+_hover) + (root+_pane+_slide+_hover);

		return $.trim(classes);
	}
,	addHover	= function (evt, el) {
		var $E = $(el || this);
		if (evt && $E.data("layoutRole") === "toggler")
			evt.stopPropagation(); // prevent triggering 'slide' on Resizer-bar
		$E.addClass( getHoverClasses($E) );
	}
,	removeHover	= function (evt, el) {
		var $E = $(el || this);
		$E.removeClass( getHoverClasses($E, true) );
	}

,	onResizerEnter	= function (evt) { // ALSO called by toggler.mouseenter
		var pane	= $(this).data("layoutEdge")
		,	s		= state[pane]
		,	$d		= $(document)
		;
		// ignore closed-panes and mouse moving back & forth over resizer!
		// also ignore if ANY pane is currently resizing
		if ( s.isResizing || state.paneResizing ) return;

		if (options.maskPanesEarly)
			showMasks( pane, { resizing: true });
	}
,	onResizerLeave	= function (evt, el) {
		var	e		= el || this // el is only passed when called by the timer
		,	pane	= $(e).data("layoutEdge")
		,	name	= pane +"ResizerLeave"
		,	$d		= $(document)
		;
		timer.clear(pane+"_openSlider"); // cancel slideOpen timer, if set
		timer.clear(name); // cancel enableSelection timer - may re/set below
		// this method calls itself on a timer because it needs to allow
		// enough time for dragging to kick-in and set the isResizing flag
		// dragging has a 100ms delay set, so this delay must be >100
		if (!el) // 1st call - mouseleave event
			timer.set(name, function(){ onResizerLeave(evt, e); }, 200);
		// if user is resizing, dragStop will reset everything, so skip it here
		else if (options.maskPanesEarly && !state.paneResizing) // 2nd call - by timer
			hideMasks();
	}

/*
 * ###########################
 *   INITIALIZATION METHODS
 * ###########################
 */

	/**
	 * Initialize the layout - called automatically whenever an instance of layout is created
	 *
	 * @see  none - triggered onInit
	 * @return  mixed	true = fully initialized | false = panes not initialized (yet) | 'cancel' = abort
	 */
,	_create = function () {
		// initialize config/options
		initOptions();
		var o = options
		,	s = state;

		// TEMP state so isInitialized returns true during init process
		s.creatingLayout = true;

		// init plugins for this layout, if there are any (eg: stateManagement)
		runPluginCallbacks( Instance, $.layout.onCreate );

		// options & state have been initialized, so now run beforeLoad callback
		// onload will CANCEL layout creation if it returns false
		if (false === _runCallbacks("onload_start"))
			return 'cancel';

		// initialize the container element
		_initContainer();

		// bind hotkey function - keyDown - if required
		initHotkeys();

		// bind window.onunload
		$(window).bind("unload."+ sID, unload);

		// init plugins for this layout, if there are any (eg: customButtons)
		runPluginCallbacks( Instance, $.layout.onLoad );

		// if layout elements are hidden, then layout WILL NOT complete initialization!
		// initLayoutElements will set initialized=true and run the onload callback IF successful
		if (o.initPanes) _initLayoutElements();

		delete s.creatingLayout;

		return state.initialized;
	}

	/**
	 * Initialize the layout IF not already
	 *
	 * @see  All methods in Instance run this test
	 * @return  boolean	true = layoutElements have been initialized | false = panes are not initialized (yet)
	 */
,	isInitialized = function () {
		if (state.initialized || state.creatingLayout) return true;	// already initialized
		else return _initLayoutElements();	// try to init panes NOW
	}

	/**
	 * Initialize the layout - called automatically whenever an instance of layout is created
	 *
	 * @see  _create() & isInitialized
	 * @param {boolean=}		[retry=false]	// indicates this is a 2nd try
	 * @return  An object pointer to the instance created
	 */
,	_initLayoutElements = function (retry) {
		// initialize config/options
		var o = options;
		// CANNOT init panes inside a hidden container!
		if (!$N.is(":visible")) {
			// handle Chrome bug where popup window 'has no height'
			// if layout is BODY element, try again in 50ms
			// SEE: http://layout.jquery-dev.com/samples/test_popup_window.html
			if ( !retry && browser.webkit && $N[0].tagName === "BODY" )
				setTimeout(function(){ _initLayoutElements(true); }, 50);
			return false;
		}

		// a center pane is required, so make sure it exists
		if (!getPane("center").length) {
			return _log( o.errors.centerPaneMissing );
		}

		// TEMP state so isInitialized returns true during init process
		state.creatingLayout = true;

		// update Container dims
		$.extend(sC, elDims( $N, o.inset )); // passing inset means DO NOT include insetX values

		// initialize all layout elements
		initPanes();	// size & position panes - calls initHandles() - which calls initResizable()

		if (o.scrollToBookmarkOnLoad) {
			var l = self.location;
			if (l.hash) l.replace( l.hash ); // scrollTo Bookmark
		}

		// check to see if this layout 'nested' inside a pane
		if (Instance.hasParentLayout)
			o.resizeWithWindow = false;
		// bind resizeAll() for 'this layout instance' to window.resize event
		else if (o.resizeWithWindow)
			$(window).bind("resize."+ sID, windowResize);

		delete state.creatingLayout;
		state.initialized = true;

		// init plugins for this layout, if there are any
		runPluginCallbacks( Instance, $.layout.onReady );

		// now run the onload callback, if exists
		_runCallbacks("onload_end");

		return true; // elements initialized successfully
	}

	/**
	 * Initialize nested layouts for a specific pane - can optionally pass layout-options
	 *
	 * @param {(string|Object)}	evt_or_pane	The pane being opened, ie: north, south, east, or west
	 * @param {Object=}			[opts]		Layout-options - if passed, will OVERRRIDE options[pane].children
	 * @return  An object pointer to the layout instance created - or null
	 */
,	createChildren = function (evt_or_pane, opts) {
		var	pane = evtPane.call(this, evt_or_pane)
		,	$P	= $Ps[pane]
		;
		if (!$P) return;
		var	$C	= $Cs[pane]
		,	s	= state[pane]
		,	o	= options[pane]
		,	sm	= options.stateManagement || {}
		,	cos = opts ? (o.children = opts) : o.children
		;
		if ( $.isPlainObject( cos ) )
			cos = [ cos ]; // convert a hash to a 1-elem array
		else if (!cos || !$.isArray( cos ))
			return;

		$.each( cos, function (idx