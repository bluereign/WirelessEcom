
<style>

#header form #q {height:33px;}

/***************************************************************************************************************************/	
/* http://images.apple.com/v/iphone/d/styles/base.css **********************************************************************/
/***************************************************************************************************************************/	

/* RESET */
html,body,div,ul,ol,li,dl,dt,dd,h1,h2,h3,h4,h5,h6,pre,form,p,blockquote,fieldset,input,abbr,article,aside,command,details,figcaption,figure,footer,header,hgroup,mark,meter,nav,output,progress,section,summary,time { margin: 0; padding: 0; }
h1,h2,h3,h4,h5,h6,pre,code,address,caption,cite,code,em,strong,th,figcaption { font-size: 1em; font-weight: normal; font-style: normal; }
fieldset,iframe { border: none; }
caption,th { text-align: left; }
table { border-collapse: collapse; border-spacing: 0; }
article,aside,footer,header,hgroup,nav,section,figure,figcaption { display: block; }

/* LAYOUT */
html { background-color:#fff; }

.clear { clear: both; }
.clearer { clear: both; display: block; margin: 0; padding: 0; height: 0; line-height: 1px; font-size: 1px; }
.selfclear { zoom:1; }
.selfclear:after { content:'.'; display:block; height:0; clear:both; visibility:hidden; }

img, .search-wrapper .left, .search-wrapper .right, ul.sp-results li.viewall a, ul.sp-results li .replacementimg, 
#globalfooter #breadcrumbs, #globalfooter #breadcrumbs span, #directorynav .capbottom, 
#productheader h1 a, #productheader h2 a, #main .maincap { behavior: url(/global/scripts/lib/iepngfix.htc); }

img { border: 0; }
img.left { float: left; margin: 2px 20px 16px 0; }
img.right { float: right; margin: 2px 0 16px 20px; }
img.across { margin: 2px 0 16px 0; }
img.flushleft { margin-left: -20px; }
img.flushright { margin-right: -20px; }

.replaced { display: block; width: 1px; height: 1px; outline: none; overflow: hidden; text-indent: -9999px; }
#omniture, #top { position: absolute; top: 0; }
#container { width: 980px; margin: 0 auto; position: relative; }
#main { width: 100%; position: relative; }
#content { padding: 18px 20px; position: relative; color: #333; }
#breadcrumb { clear: both; text-align: center; margin: 18px auto; clear: both; font-size: 10px; color: #686868; }

.content { background: #fff; border: 1px solid; border-color: #e5e5e5 #dbdbdb #d2d2d2; -webkit-box-shadow: rgba(0,0,0,0.3) 0 1px 3px; -moz-box-shadow: rgba(0,0,0,0.3) 0 1px 3px; box-shadow: rgba(0,0,0,0.3) 0 1px 3px; }
.content:nth-child(1n) { border: none; } /* reset border for smart browsers */

.content,
.rounded { border-radius: 4px; -webkit-border-radius: 4px; -moz-border-radius: 4px; -o-border-radius: 4px; -khtml-border-radius: 4px; }

.shadow { -webkit-box-shadow: rgba(0,0,0,0.35) 0 1px 3px; -moz-box-shadow: rgba(0,0,0,0.35) 0 1px 3px; box-shadow: rgba(0,0,0,0.35) 0 1px 3px; }
img.shadow { padding: 5px; background: #fff; margin-bottom: 2px; *border: 1px solid #e2e2e2; _position: relative; }


.callout { border-radius: 7px; -webkit-border-radius: 7px; -moz-border-radius: 7px; -o-border-radius: 7px; -khtml-border-radius: 7px; }

.roundedtop { border-radius: 4px 4px 0 0; -webkit-border-top-left-radius:4px; -webkit-border-top-right-radius:4px; -moz-border-radius: 4px 4px 0 0; -o-border-radius: 4px 4px 0 0; -khtml-border-radius: 4px 4px 0 0; }
.roundedbottom { border-radius: 0 0 4px 4px; -webkit-border-bottom-left-radius:4px; -webkit-border-bottom-right-radius:4px; -moz-border-radius: 0 0 4px 4px; -o-border-radius: 0 0 4px 4px; -khtml-border-radius: 0 0 4px 4px; }
.roundedright { border-radius: 0 4px 4px 0; -webkit-border-top-right-radius:4px; -webkit-border-bottom-right-radius:4px; -moz-border-radius: 0 4px 4px 0; -o-border-radius: 0 4px 4px 0; -khtml-border-radius: 0 4px 4px 0; }
.roundedleft { border-radius: 4px 0 0 4px; -webkit-border-top-left-radius:4px; -webkit-border-bottom-left-radius:4px; -moz-border-radius: 4px 0 0 4px; -o-border-radius: 4px 0 0 4px; -khtml-border-radius: 4px 0 0 4px; }
.roundedtopleft { border-radius:4px 0 0; -webkit-border-top-left-radius:4px; -moz-border-radius:4px 0 0; -o-border-radius:4px 0 0; -khtml-border-radius:4px 0 0; }
.roundedtopright { border-radius: 0 4px 0 0; -webkit-border-top-right-radius:4px; -moz-border-radius:0 4px 0 0; -o-border-radius:0 4px 0 0; -khtml-border-radius: 0 4px 0 0; }
.roundedbottomleft { border-radius: 0 0 0 4px; -webkit-border-bottom-left-radius:4px; -moz-border-radius: 0 0 0 4px; -o-border-radius: 0 0 0 4px; -khtml-border-radius: 0 0 0 4px; }
.roundedbottomright { border-radius: 0 0 4px 0; -webkit-border-bottom-right-radius:4px; -moz-border-radius: 0 0 4px 0; -o-border-radius: 0 0 4px 0; -khtml-border-radius: 0 0 4px 0; }

.grabbable { cursor:move; cursor:-webkit-grab; cursor:-moz-grab; cursor:grab; }
.grabbing,
.grabbing .grabbable { cursor:move; cursor:-webkit-grabbing; cursor:-moz-grabbing; cursor:grabbing; }

/* GRID */
.column { float: left; }
.grid2col, .grid2cola, .grid2colb, .grid2colc, .grid2cold, .grid2cole, .grid2colf, .grid3col, .grid3cola, .grid4col, .grid5col, .grid6col { width: 100%; }

.grid2col .column { width: 49%; }
.grid2col .grid2col .column { width: 47.8%; }
.grid3col .grid2col .column { width: 46%; }
.grid4col .grid2col .column { width: 45%; }

.grid2cola .column.first { width: 66%; }
.grid2cola .column.last { width: 32%; }

.grid2colb .column.first { width: 74.9%; }
.grid2colb .column.last { width: 23%; }

.grid2colc .column.first { width: 32%; }
.grid2colc .column.last { width: 66%; }

.grid2cold .column.first { width: 23%; }
.grid2cold .column.last { width: 74.9%; }

.grid2cole .column.first { width: 79%; }
.grid2cole .column.last { width: 19%; }

.grid2colf .column.first { width: 19%; }
.grid2colf .column.last { width: 79%; }

.grid3col .column { width: 32%; margin-left: 2%; }
.grid2col .grid3col .column { width: 31%; }

.grid3cola .column { width: 58%; margin-left: 2%; }
.grid3cola .column.first,
.grid3cola .column.last { width: 19%; }

.grid4col .column { width: 23%; margin-left: 3%; }

.grid5col .column { width: 18.4%; margin-left: 2%; }

.grid6col .column { width: 15%; margin-left: 2%; }

.column.first, .column.last { margin-left: 0 !important; }
.column.last { float: right !important; }

p.last, ul.last, ol.last, li.last { _width: auto !important; _float: none !important; }

#container:after, #content:after, .grid2col:after, .grid2cola:after, .grid2colb:after, .grid2colc:after, .grid2cold:after, .grid2cole:after, .grid2colf:after, .grid3col:after, .grid3cola:after, .grid4col:after, .grid5col:after, .grid6col:after { content: "."; display: block; height: 0; clear: both; visibility: hidden; }
#container, #content, .grid2col, .grid2cola, .grid2colb, .grid2colc, .grid2cold, .grid2cole, .grid2colf, .grid3col, .grid3cola, .grid4col, .grid5col, .grid6col { zoom: 1; }

/* TYPE */
#compare { font: 12px/18px "Lucida Grande", "Lucida Sans Unicode", Helvetica, Arial, Verdana, sans-serif; background-color: transparent; color: #333; -webkit-font-smoothing: antialiased; }
#compare table tbody { font: 14px/18px "Lucida Grande", "Lucida Sans Unicode", Helvetica, Arial, Verdana, sans-serif; background-color: transparent; color: #333; -webkit-font-smoothing: antialiased; }

a { color: #08c; }
a:link, a:visited, a:active { text-decoration: none; }
a:hover { text-decoration: underline; }
a.block { display: block; cursor: pointer; }
a.block span,
a.block em { color:#08c; cursor: pointer; }
a.block:hover { text-decoration: none; }
a.block:hover span,
a.block:hover em { color: #08c; text-decoration: underline; }
a.more, em.more, span.more { white-space: nowrap; padding-right: 10px; background: url(http://images.apple.com/global/elements/arrows/morearrow_08c.gif) no-repeat 100% 50%; cursor: pointer; zoom: 1; }
a.morelarge, em.morelarge, span.morelarge { white-space:nowrap; padding-right:12px; background:url(http://images.apple.com/global/elements/arrows/morearrow_big_08c.gif) no-repeat 100% 50%; cursor:pointer; zoom:1; }
a.lesslarge, em.lesslarge, span.lesslarge { white-space:nowrap; padding-left:12px; background:url(http://images.apple.com/global/elements/arrows/lessarrow_big_08c.gif) no-repeat 0 50%; cursor:pointer; zoom:1; }
@media only screen {
	a.more, em.more, span.more { background-image:url(./../elements/arrows/morearrow_08c.svg); }
	a.morelarge, em.morelarge, span.morelarge { background-image:url(./../elements/arrows/morearrow_big_08c.svg); }
	a.lesslarge, em.lesslarge, span.lesslarge { background-image:url(./../elements/arrows/lessarrow_big_08c.svg); }
}
a.external, em.external, span.external { white-space: nowrap; padding-right: 15px; background: url(http://images.apple.com/global/elements/icons/external10x10.gif) no-repeat 100% 49%; cursor: pointer; zoom: 1; }
a[rel="external"] { white-space: nowrap; padding-right: 15px; background: url(http://images.apple.com/global/elements/icons/external10x10.gif) no-repeat 100% 49%; cursor: pointer; zoom: 1; }
em.more, span.more, em.external, span.external { color:#08c; font-style: normal; cursor: pointer; }
.nowrap { white-space:nowrap; }
strong, b { font-weight: bold; }
em, i, cite { font-style: italic; }
sup { padding-left: 1px; font-size: 10px !important; font-weight: normal !important; line-height:1.5; vertical-align: baseline; position: relative; bottom: 0.33em; _position: static !important; }
sup, sup a { color:#666; }
sup a:hover { color:#08c; text-decoration:none; }
sub { line-height:1; }
abbr { border: 0; }
.sosumi { font-size: 10px !important; line-height:1.5; color:#888; }
.sosumi_features { font-size: 10px !important; line-height:1.5; color:#888; }

h1,h2,h3,h4,h5,h6,strong { color:#000; }
h1,h2,h3,h4 { font-weight: bold; }
h2,h3,h4 { line-height: 18px; }
h1,h2 { margin-bottom: 18px; }
h1 { font-size: 24px; line-height: 36px; }
h2 { font-size: 16px; }
h3 { font-size: 1em; }
h4 { font-size: 10px; }
p { margin-bottom: 18px; }
p.intro { color: #888; font-size: 16px; line-height: 22px; font-weight: normal; }
.more { text-align: right; }

ul { list-style: none outside; }
ol { margin-bottom: 18px; list-style: decimal; margin-left: 2.2em; }
ul.square,
ul.circle,
ul.disc { margin-left: 2em; margin-bottom: 18px; }
ul.square { list-style: square outside; }
ul.circle { list-style: circle outside; }
ul.disc { list-style:disc outside; }
ul ul.square,
ul ul.circle,
ul ul.disc { margin-top: 4px; margin-bottom: 5px; }
ol.sosumi { margin-left: 0; padding-left: 2em; *padding-left: 2.2em; }

a.pdf { background: url(http://images.apple.com/global/elements/icons/globaliconpdf12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.html { background: url(http://images.apple.com/global/elements/icons/globaliconhtml12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.qt { background: url(http://images.apple.com/global/elements/icons/globaliconqt12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.ical { background: url(http://images.apple.com/global/elements/icons/globaliconical12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.dl { background: url(http://images.apple.com/global/elements/icons/globalicondl11x10.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.dmg { background: url(http://images.apple.com/global/elements/icons/globalicondmg12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.zip { background: url(http://images.apple.com/global/elements/icons/globaliconzip12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.keynote { background: url(http://images.apple.com/global/elements/icons/globaliconkeynote12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }
a.audio { background: url(http://images.apple.com/global/elements/icons/globaliconaudio12x12.gif) 0 0.4em no-repeat; display: block; padding-left: 20px; }

.dot-nav { width:100%; margin:0; padding:0; text-align:center; line-height:1px; }
.dot-nav li,
.dot-nav li a { display:-moz-inline-stack; display:inline-block; *display:inline; *zoom:1; }
.dot-nav li { position:relative; z-index:1; margin:0; width:13px; height:15px; overflow:hidden; }
.dot-nav li a { position:absolute; z-index:1; width:13px; height:45px; top:0; left:0; cursor:pointer; text-indent:-1000em; background:url(http://images.apple.com/global/elements/buttons/dots_08c.png) no-repeat 0 0; behavior:url(/global/scripts/lib/ie7pngfix.htc); }
.dot-nav li a:hover { top:-15px; }
.dot-nav li a.active { cursor:default; top:-30px; }

.dot-nav:nth-child(1n) li { width:10px; height:10px; padding:0; margin:0 2px; }
.dot-nav:nth-child(1n) li a { border-radius:5px; width:10px; height:10px; background:#e0e1e3;
	-webkit-box-shadow:inset 0 1px 1px rgba(0, 0, 0, .25);
	   -moz-box-shadow:inset 0 1px 1px rgba(0, 0, 0, .25);
	        box-shadow:inset 0 1px 1px rgba(0, 0, 0, .25);
}
.dot-nav:nth-child(1n) li a:hover { top:0; background:#ccc;}
.dot-nav:nth-child(1n) li a.active { top:0; background:#08c;
	background:-webkit-gradient(linear,lefttop,leftbottom,color-stop(0%,rgb(126,198,234)),color-stop(24%,rgb(70,179,234)),color-stop(100%,rgb(3,135,201)));
	background:-webkit-linear-gradient(top,rgb(126,198,234)0%,rgb(70,179,234)45%,rgb(3,135,201)100%);
	background:   -moz-linear-gradient(top,rgb(126,198,234)0%,rgb(70,179,234)45%,rgb(3,135,201)100%);
	background:        linear-gradient(top,rgb(126,198,234)0%,rgb(70,179,234)45%,rgb(3,135,201)100%);
	-webkit-box-shadow:inset 0 1px 0 rgba(0, 0, 0, .25);
	   -moz-box-shadow:inset 0 1px 0 rgba(0, 0, 0, .25);
	        box-shadow:inset 0 1px 0 rgba(0, 0, 0, .25);
}

.last { margin-bottom: 0; }
#main .sidebar { font-size: 10px; line-height: 18px; color:#333; }
#main .callout { font-size: 11px; line-height: 18px; margin-bottom: 18px; }

body.specs #main { font-size: 11px; line-height: 16px; }

/* PIPED LINKS */
.piped { display: block; zoom: 1; }
.piped:after { content: "."; display: block; height: 0; clear: both; visibility: hidden; }
.piped li { float: left; display: inline; }
.piped a { border-left: 1px solid #797c80; padding: 0 0 0 0.75em; margin-left: 0.75em; }
.piped a.first { border-left: 0 !important; padding-left: 0; margin-left: 0 !important; }

/*--- Global Footer (legacy) ---*/
#globalfooter .gf-buy { float: left; width: 60%; margin: 18px 0 9px; }
#globalfooter .gf-links { float: right; margin: 18px 0 9px; }
#globalfooter .gf-links a { padding: 0 10px; white-space: nowrap; }
#globalfooter .gf-links a.last { padding-right: 0; _float: none !important; width: auto !important; }

/*--- Global Footer ---*/
#globalfooter { width: 980px; color: #888; font-size: 10px; margin: 18px auto 0; padding-bottom: 36px; text-align: left !important; }
#globalfooter a { color: #08c; }
#globalfooter p { margin-bottom: 1em; }
#globalfooter p.gf-buy { float: left; width: 52%; margin: 18px 0 9px 3px; }
#globalfooter ul.piped a { padding: 0 0 0 1.5em; margin-left: 1.5em; border-left: 1px solid #d0d0d0; }
#globalfooter .gf-links { float: right; margin: 18px 3px 9px 0; }
#globalfooter .gf-sosumi { clear: both; width: 100%; border-top: 1px solid #ddd; padding-top: 9px; }
#globalfooter .gf-sosumi a { padding: 0 10px; }
#globalfooter .gf-sosumi p { float: left; margin-left: 3px; }
#globalfooter form { margin: 18px 10px; }
#globalfooter .search-wrapper { margin: 0 auto; }
#globalfooter .search-wrapper input.prettysearch { margin-left: 10px; }
#globalfooter ul.piped a.contact_us { padding-right: 1.5em; border-right: 1px solid #d0d0d0; }
#globalfooter ul.piped a.choose { margin-left: 0; border: 0; }
#globalfooter ul.piped a.choose img { vertical-align: middle; margin-top: -5px; *position: relative; }

/*--- Breadcrumbs (legacy) ---*/
#globalfooter #breadcrumbs { font-size: 11px; color: #444; background: url(http://images.apple.com/global/elements/breadory/breadcrumb_bg.png) no-repeat; overflow: hidden; height: 36px; line-height: 34px; font-weight: bold; text-shadow: 0 1px 0 #fff; }
#globalfooter #breadcrumbs a { color: #444; text-decoration: none; float: left; padding: 0 10px; margin-left: -10px; *position: relative; _cursor: hand; }
#globalfooter #breadcrumbs a:hover { color: #333; text-decoration: none !important; }
#globalfooter #breadcrumbs a.home { margin: 0; width: 15px; height: 0; padding-top: 36px; overflow: hidden; }
#globalfooter #breadcrumbs span { float: left; width: 9px; margin: 0 10px 0 0; height: 0; padding-top: 34px; margin-top: 1px; overflow: hidden; background: url(http://images.apple.com/global/elements/breadory/breadcrumb_sep.png) no-repeat; }

/*--- Breadcrumbs ---*/
#globalfooter ol#breadcrumbs { font-size: 11px; color: #444; background: url(http://images.apple.com/global/elements/breadory/breadcrumb_bg.png) no-repeat; height: 36px; line-height: 34px; margin: 0; list-style: none; font-weight: bold; text-shadow: 0 1px 0 #fff; }
#globalfooter ol#breadcrumbs li { float: left; margin: 0; padding: 0 0 0 20px; background: url(http://images.apple.com/global/elements/breadory/breadcrumb_sep_20080909.png) no-repeat; }
#globalfooter ol#breadcrumbs li a { float: left; color: #444; text-decoration: none; padding: 0 10px; margin-left: -10px; }
#globalfooter ol#breadcrumbs li a:hover { color: #333; text-decoration: none; }
#globalfooter ol#breadcrumbs li.home { background: none; margin: 0; padding: 0; }
#globalfooter ol#breadcrumbs li.home a { margin: 0; padding: 0 10px; width: 15px; text-indent: -9999px; overflow: hidden; }

/*--- Directory Nav ---*/
#directorynav { font-size: 11px; line-height:14px; padding-top:2px; background: url(http://images.apple.com/global/elements/breadory/directory_bg.png) repeat-y; border-top: 1px solid #ddd; float: left; width: 100%; margin-top: -4px; *position: relative; }
#directorynav .column { width: 120px; padding: 9px 0 2px 18px; }
#directorynav .column.last { float: left !important; padding-right: 0; }
#directorynav h3 { color: #666; margin: 0; font-size: 1em; line-height: 14px; font-weight: bold; padding-bottom: 4px; }
#directorynav h3.standalone { margin-bottom: 18px; }
#directorynav a { color: #888; text-decoration: none; display: block; zoom: 1; }
#directorynav h3.standalone a:link,
#directorynav h3.standalone a:visited { color: #444; }
#directorynav a:hover { color: #333 !important; text-decoration: none !important; }
#directorynav .capbottom { clear: both; position: relative; top: 5px; _top: 12px; height: 5px; width: 980px; background: url(http://images.apple.com/global/elements/breadory/directory_capbg.png) no-repeat; }
#directorynav ul { margin-bottom: 0; padding-bottom: 9px; }
#directorynav ul li { padding-bottom: 4px; }
#directorynav.ios .column,
#directorynav.mac .column,
#directorynav.ipod .column,
#directorynav.ipodtouch .column,
#directorynav.ipad .column,
#directorynav.iphone .column,
#directorynav.itunes .column { width: 190px; padding: 9px 0 0 54px; }

/*--- BREADORY ---*/
#breadory { border: 1px solid #ddd; width: 978px; margin: 0 auto; -moz-border-radius: 4px; -webkit-border-radius: 4px; border-radius: 4px; }
#globalfooter #breadory ol#breadcrumbs { background: none; clear: both; float: none; height: 3em; line-height: 3em; font-size: 11px; color: #666; margin: 0; list-style: none; font-weight: bold; text-shadow: 0 1px 0 #fff; }
#breadory ol#breadcrumbs li { background: none; float: left; margin: 0; padding: 0 0 0 1em; }
#breadory ol#breadcrumbs li a { float: left; color: #666; text-decoration: none; padding: 0 1.75em 0 0; margin-left: 0px; background: url(http://images.apple.com/global/elements/breadory/breadcrumb_separator.png) no-repeat 100% 50%; }
#breadory ol#breadcrumbs li a:hover { color: #333; text-decoration: none; }
#breadory ol#breadcrumbs li.home { background: none; margin: 0; padding: 0; }
#breadory ol#breadcrumbs li.home a { background: url(http://images.apple.com/global/elements/breadory/breadcrumb_home.png) no-repeat 1.25em 50%; margin: 0; padding: 0 0 0 1.25em; width: 30px; text-indent: -9999px; overflow: hidden; }
#breadory ol#breadcrumbs li.home a:hover { background-image: url(http://images.apple.com/global/elements/breadory/breadcrumb_home_over.png); }

@media only screen { 
	#breadory ol#breadcrumbs li a { background-image:url(./../elements/breadory/breadcrumb_separator.svg); }
	#breadory ol#breadcrumbs li.home a { background-image:url(./../elements/breadory/breadcrumb_home.svg); }
	#breadory ol#breadcrumbs li.home a:hover { background-image:url(./../elements/breadory/breadcrumb_home_over.svg); }
}

#breadory #directorynav { background: none; clear: both; float: none; margin-top: 0; }
#breadory #directorynav .capbottom { height: 0; font-size: 1px; _display: none; }

/* PRODUCTHEADER */
#productheader { padding: 1em 0 0.2em; overflow: hidden; width: 980px; margin: 0 auto; *position: relative; *height: 39px; }
#productheader h1, 
#productheader h2 { height: 32px; line-height: 32px; display: inline; float: left; margin: 1px 0 6px 8px; padding: 0; margin-bottom: 6px !important; }
#productheader h1 a, 
#productheader h2 a { line-height: 32px; background-position: 0 0; background-repeat: no-repeat; color: #888; display: block; font-weight: normal; height: 32px; outline: none; text-decoration: none; text-indent: -9999px; *position: relative; }
#overview #productheader h1 a, 
#overview #productheader h2 a { cursor: default; }

#productheader ul { display: inline; float: right; margin: 0; }
#productheader ul li { display: inline; }
#productheader ul li a { color: #333; float: left !important; margin-top: 1em; margin-left: 30px; margin-right: 8px; padding: 0; text-decoration: none; }
#productheader ul li a:hover { color: #08c; }

#productheader a.buynow, #productheader span.buynow, /* old */
#productheader a.ordernow, #productheader span.ordernow,
#productheader a.joinnow, #productheader span.joinnow,
#productheader a.preorder, #productheader span.preorder,
#productheader a.preorder_blue, #productheader span.preorder_blue,
#productheader a.howtobuy, #productheader span.howtobuy,
#productheader a.howtoapply, #productheader span.howtoapply,
#productheader a.freetrial, #productheader span.freetrial,
#productheader a.downloadnow, #productheader span.downloadnow,
#productnav a.downloadnow, #productnav span.downloadnow,
#productheader a.upgradenow, #productheader span.upgradenow,
#productheader a.tryamac, #productheader span.tryamac { height: 25px; margin: 0.7em 0 0 20px; background-position: 0 0; background-repeat: no-repeat; display: block; float: right; position: relative; text-decoration: none; text-indent: -9999px; outline: none; overflow: hidden; }
#productheader a.notifyme, #productheader span.notifyme { height: 25px; margin: 0.8em 0 0 20px; background-position: 0 0; background-repeat: no-repeat; display: block; float: right; position: relative; text-decoration: none; text-indent: -9999px; outline: none; overflow: hidden; }

#productheader a.preorder_blue, #productheader span.preorder_blue { width: 75px; background-image: url(http://images.apple.com/global/elements/buttons/preorder_blue.png); }
#productheader a.buynow, #productheader span.buynow { width: 72px; background-image: url(http://images.apple.com/global/elements/buttons/buynows.png); _background-image: url(http://images.apple.com/global/elements/buttons/buynows.gif); }
#productheader a.ordernow, #productheader span.ordernow { width: 81px; background-image: url(http://images.apple.com/global/elements/buttons/ordernows.png); _background-image: url(http://images.apple.com/global/elements/buttons/ordernows.gif); }
#productheader a.joinnow, #productheader span.joinnow { width: 72px; background-image: url(http://images.apple.com/global/elements/buttons/joinnows.png); _background-image: url(http://images.apple.com/global/elements/buttons/joinnows.gif); }
#productheader a.preorder, #productheader span.preorder { width: 99px; background-image: url(http://images.apple.com/global/elements/buttons/preordernows.png); _background-image: url(http://images.apple.com/global/elements/buttons/preordernows.gif); }
#productheader a.howtobuy, #productheader span.howtobuy { width: 86px; background-image: url(http://images.apple.com/global/elements/buttons/howtobuys.png); _background-image: url(http://images.apple.com/global/elements/buttons/howtobuys.gif); }
#productheader a.howtoapply, #productheader span.howtoapply { width: 100px; background-image: url(http://images.apple.com/global/elements/buttons/howtoapplys.png); _background-image: url(http://images.apple.com/global/elements/buttons/howtoapplys.gif); }
#productheader a.freetrial, #productheader span.freetrial { width: 72px; background-image: url(http://images.apple.com/global/elements/buttons/freetrials.png); _background-image: url(http://images.apple.com/global/elements/buttons/freetrials.gif); }
#productheader a.downloadnow, #productheader span.downloadnow { width: 108px; background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.png); _background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.gif); }
#productnav a.downloadnow, #productnav span.downloadnow { width: 108px; background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.png); _background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.gif); }
#productheader a.upgradenow, #productheader span.upgradenow { width: 104px; background-image: url(http://images.apple.com/global/elements/buttons/upgradenows.png); _background-image: url(http://images.apple.com/global/elements/buttons/upgradenows.gif); }
#productheader a.tryamac, #productheader span.tryamac { width: 77px; background-image: url(http://images.apple.com/global/elements/buttons/tryamacs.png); _background-image: url(http://images.apple.com/global/elements/buttons/tryamacs.gif); }
#productheader a.notifyme, #productheader span.notifyme { width: 75px; background-image: url(http://images.apple.com/global/elements/buttons/notifymes.png); _background-image: url(http://images.apple.com/global/elements/buttons/notifymes.gif); }

#productheader a.buynow:hover, #productheader a.buynow:focus,
#productheader a.ordernow:hover, #productheader a.ordernow:focus,
#productheader a.joinnow:hover, #productheader a.joinnow:focus,
#productheader a.preorder:hover, #productheader a.preorder:focus,
#productheader a.howtobuy:hover, #productheader a.howtobuy:focus,
#productheader a.howtoapply:hover, #productheader a.howtoapply:focus,
#productheader a.freetrial:hover, #productheader a.freetrial:focus,
#productheader a.downloadnow:hover, #productheader a.downloadnow:focus,
#productnav a.downloadnow:hover, #productnav a.downloadnow:focus,
#productheader a.upgradenow:hover, #productheader a.upgradenow:focus,
#productheader a.tryamac:hover, #productheader a.tryamac:focus,
#productheader a.notifyme:hover, #productheader a.notifyme:focus { background-position: 0 -25px; }

#productheader a.buynow:active,
#productheader a.ordernow:active,
#productheader a.joinnow:active,
#productheader a.preorder:active,
#productheader a.howtobuy:active,
#productheader a.howtoapply:active,
#productheader a.freetrial:active,
#productheader a.downloadnow:active,
#productnav a.downloadnow:active,
#productheader a.upgradenow:active,
#productheader a.tryamac:active,
#productheader a.notifyme:active { background-position: 0 -50px; }

#productheader span.buynow,
#productheader span.ordernow,
#productheader span.joinnow,
#productheader span.preorder,
#productheader span.howtobuy,
#productheader span.howtoapply,
#productheader span.freetrial,
#productheader span.downloadnow,
#productnav span.downloadnow,
#productheader span.upgradenow,
#productheader span.notifyme { background-position: 0 -75px; }


/* BUTTONS - (U.S.) */
.browsewebappss, .businessstores, .buyiphones, .buynows, .buynows-arrow, .comingsoons, .descargarahoras, .downloadituness, .downloadnows, .finds, .freetrials, .getstarteds, .gos, .howtoapplys, .howtobuys, .joinnows, .learnmores, .nikebuynows, .notifymes, .ordernows, .preordernows, .preorders, .reserves, .startyoursearchs, .submits, .tryamacs, .upgradenows {
	height: 25px; background-position: 0 0; background-repeat: no-repeat; display: block; text-decoration: none; text-indent: -9999px; overflow: hidden;
}
a.browsewebappss:hover, a.businessstores:hover, a.buyiphones:hover, a.buynows:hover, a.buynows-arrow:hover, a.comingsoons:hover, a.descargarahoras:hover, a.downloadituness:hover, a.downloadnows:hover, a.finds:hover, a.freetrials:hover, a.getstarteds:hover, a.gos:hover, a.howtoapplys:hover, a.howtobuys:hover, a.joinnows:hover, a.learnmores:hover, a.nikebuynows:hover, a.notifymes:hover, a.ordernows:hover, a.preordernows:hover, a.preorders:hover, a.reserves:hover, a.startyoursearchs:hover, a.submits:hover, a.tryamacs:hover, a.upgradenows:hover,
a.browsewebappss:focus, a.businessstores:focus, a.buyiphones:focus, a.buynows:focus, a.buynows-arrow:focus, a.comingsoons:focus, a.descargarahoras:focus, a.downloadituness:focus, a.downloadnows:focus, a.finds:focus, a.freetrials:focus, a.getstarteds:focus, a.gos:focus, a.howtoapplys:focus, a.howtobuys:focus, a.joinnows:focus, a.learnmores:focus, a.nikebuynows:focus, a.notifymes:focus, a.ordernows:focus, a.preordernows:focus, a.preorders:focus, a.reserves:focus, a.startyoursearchs:focus, a.submits:focus, a.tryamacs:focus, a.upgradenows:focus {
	background-position: 0 -25px;
}
a.browsewebappss:active, a.businessstores:active, a.buyiphones:active, a.buynows:active, a.buynows-arrow:active, a.comingsoons:active, a.descargarahoras:active, a.downloadituness:active, a.downloadnows:active, a.finds:active, a.freetrials:active, a.getstarteds:active, a.gos:active, a.howtoapplys:active, a.howtobuys:active, a.joinnows:active, a.learnmores:active, a.nikebuynows:active, a.notifymes:active, a.ordernows:active, a.preordernows:active, a.preorders:active, a.reserves:active, a.startyoursearchs:active, a.submits:active, a.tryamacs:active, a.upgradenows:active {
	background-position: 0 -50px;
}
span.browsewebappss, span.businessstores, span.buyiphones, span.buynows, span.comingsoons, span.descargarahoras, span.downloadituness, span.downloadnows, span.finds, span.freetrials, span.getstarteds, span.gos, span.howtoapplys, span.howtobuys, span.joinnows, span.learnmores, span.nikebuynows, span.notifymes, span.ordernows, span.preordernows, span.preorders, span.reserves, span.startyoursearchs, span.submits, span.tryamacs, span.upgradenows {
	background-position: 0 -75px;
}
.browsewebappss { background-image: url(http://images.apple.com/global/elements/buttons/browsewebappss.png); _background-image: url(http://images.apple.com/global/elements/buttons/browsewebappss.gif); width: 123px; }
.businessstores { background-image: url(http://images.apple.com/global/elements/buttons/businessstores.png); _background-image: url(http://images.apple.com/global/elements/buttons/businessstores.gif); width: 105px; }
.buyiphones { background-image: url(http://images.apple.com/global/elements/buttons/buyiphones.png); _background-image: url(http://images.apple.com/global/elements/buttons/buyiphones.gif); width: 87px; }
.buynows { background-image: url(http://images.apple.com/global/elements/buttons/buynows.png); _background-image: url(http://images.apple.com/global/elements/buttons/buynows.gif); width: 72px; }
.buynows-arrow { background-image: url(http://images.apple.com/global/elements/buttons/buynows_arrow.png); _background-image: url(http://images.apple.com/global/elements/buttons/buynows_arrow.gif); width: 86px; }
.comingsoons { background-image: url(http://images.apple.com/global/elements/buttons/comingsoons.png); _background-image: url(http://images.apple.com/global/elements/buttons/comingsoons.gif); width: 97px; }
.descargarahoras { background-image: url(http://images.apple.com/global/elements/buttons/descargarahoras.png); _background-image: url(http://images.apple.com/global/elements/buttons/descargarahoras.gif); width: 108px; }
.downloadituness { background-image: url(http://images.apple.com/global/elements/buttons/downloadituness.png); _background-image: url(http://images.apple.com/global/elements/buttons/downloadituness.gif); width: 116px; }
.downloadnows { background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.png); _background-image: url(http://images.apple.com/global/elements/buttons/downloadnows.gif); width: 108px; }
.finds { background-image: url(http://images.apple.com/global/elements/buttons/finds.png); _background-image: url(http://images.apple.com/global/elements/buttons/finds.gif); width: 52px; }
.freetrials { background-image: url(http://images.apple.com/global/elements/buttons/freetrials.png); _background-image: url(http://images.apple.com/global/elements/buttons/freetrials.gif); width: 72px; }
.getstarteds { background-image: url(http://images.apple.com/global/elements/buttons/getstarteds.png); _background-image: url(http://images.apple.com/global/elements/buttons/getstarteds.gif); width: 90px; }
.gos { background-image: url(http://images.apple.com/global/elements/buttons/gos.png); _background-image: url(http://images.apple.com/global/elements/buttons/gos.gif); width: 44px; }
.howtoapplys { background-image: url(http://images.apple.com/global/elements/buttons/howtoapplys.png); _background-image: url(http://images.apple.com/global/elements/buttons/howtoapplys.gif); width: 100px; }
.howtobuys { background-image: url(http://images.apple.com/global/elements/buttons/howtobuys.png); _background-image: url(http://images.apple.com/global/elements/buttons/howtobuys.gif); width: 86px; }
.joinnows { background-image: url(http://images.apple.com/global/elements/buttons/joinnows.png); _background-image: url(http://images.apple.com/global/elements/buttons/joinnows.gif); width: 72px; }
.learnmores { background-image: url(http://images.apple.com/global/elements/buttons/learnmores.png); _background-image: url(http://images.apple.com/global/elements/buttons/learnmores.gif); width: 89px; }
.nikebuynows { background-image: url(http://images.apple.com/global/elements/buttons/nikebuynows.png); _background-image: url(http://images.apple.com/global/elements/buttons/nikebuynows.gif); width: 72px; }
.notifymes { background-image: url(http://images.apple.com/global/elements/buttons/notifymes.png); _background-image: url(http://images.apple.com/global/elements/buttons/notifymes.gif); width: 80px; }
.ordernows { background-image: url(http://images.apple.com/global/elements/buttons/ordernows.png); _background-image: url(http://images.apple.com/global/elements/buttons/ordernows.gif); width: 81px; }
.preordernows { background-image: url(http://images.apple.com/global/elements/buttons/preordernows.png); _background-image: url(http://images.apple.com/global/elements/buttons/preordernows.gif); width: 99px; }
.preorders { background-image: url(http://images.apple.com/global/elements/buttons/preorders.png); _background-image: url(http://images.apple.com/global/elements/buttons/preorders.gif); width: 77px; }
.reserves { background-image: url(http://images.apple.com/global/elements/buttons/reserves.png); _background-image: url(http://images.apple.com/global/elements/buttons/reserves.gif); width: 68px; }
.startyoursearchs { background-image: url(http://images.apple.com/global/elements/buttons/startyoursearchs.png); _background-image: url(http://images.apple.com/global/elements/buttons/startyoursearchs.gif); width: 120px; }
.submits { background-image: url(http://images.apple.com/global/elements/buttons/submits.png); _background-image: url(http://images.apple.com/global/elements/buttons/submits.gif); width: 67px; }
.tryamacs { background-image: url(http://images.apple.com/global/elements/buttons/tryamacs.png); _background-image: url(http://images.apple.com/global/elements/buttons/tryamacs.gif); width: 77px; }
.upgradenows { background-image: url(http://images.apple.com/global/elements/buttons/upgradenows.png); _background-image: url(http://images.apple.com/global/elements/buttons/upgradenows.gif); width: 104px; }

#productheader .browsewebappss, #productheader .businessstores, #productheader .buyiphones, #productheader .buynows, #productheader .comingsoons, #productheader .descargarahoras, 
#productheader .downloadituness, #productheader .downloadnows, #productheader .finds, #productheader .freetrials, #productheader .getstarteds, 
#productheader .gos, #productheader .howtoapplys, #productheader .howtobuys, #productheader .joinnows, #productheader .learnmores, 
#productheader .notifymes, #productheader .ordernows, #productheader .preordernows, #productheader .preorders, #productheader .reserves, 
#productheader .startyoursearchs, #productheader .submits, #productheader .tryamacs, #productheader .upgradenows {
	margin: 0.8em 0 0 20px; float: left;
}

/* promofooter */
#promofooter { width:984px; margin:18px auto 0; padding-top:17px; background:url(http://images.apple.com/promos/images/promofooter_top.png) no-repeat; zoom:1; _background-image:url(http://images.apple.com/promos/images/promofooter_top.gif); }
#promofooter #promos { width:980px; margin-bottom:0; padding:0 2px 4px; background:url(http://images.apple.com/promos/images/promofooter_bottom.png) no-repeat 0 100%; zoom:1; _background-image:url(http://images.apple.com/promos/images/promofooter_bottom.gif); }
#promofooter #promos:after { content:'.'; display:block; height:0; clear:both; visibility:hidden; }
#promofooter #promos li.promo { position:relative; float:left; width:244px; min-height:15em; _height:15em; padding-right:1px; margin-top:-16px; }
#promofooter #promos li.promo a { color:#777; }
#promofooter #promos li.promo:hover a { color:#08c; text-decoration:none; }

#promofooter #promos img { display:block; }

#promofooter #promos h4 a,
#promofooter #promos p a,
#promofooter #promos ul { display:block; padding-left:15px; padding-right:12px; text-align:left; z-index:101; *position:relative; }

#promofooter #promos h4 a { font-size:18px; font-weight:normal; padding-top:15px; }
#promofooter #promos p { margin-bottom:0; }
#promofooter #promos p a { font-size:11px; line-height:16px; }
#promofooter #promos a.image { height:180px; position:absolute; bottom:0; z-index:100; }

#promofooter #promos .promo.left p a { width:110px; }
#promofooter #promos .promo.right p a { width:112px; padding-left:116px; }
#promofooter #promos .promo.center p a { text-align:center; }

#promofooter #promos li.buy { position:relative; float:left; width:244px; padding-right:1px; margin-top:-17px; color:#777; }
#promofooter #promos li.buy ul { font-size:11px; line-height:1.4; }

#promofooter.grid2col { min-height: 70px; padding:15px 0 8px 0;  border: 1px solid #D2D2D2; }
#promofooter.grid2col { background:#fff;
    background:-webkit-gradient(linear, 0% 0%, 0% 100%, from(#fff), to(#e5e5e5));
    background:-moz-linear-gradient(100% 100% 90deg, #e5e5e5, #fff);
    filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#FFFFFF', endColorstr='#e5e5e5');
 }
#promofooter.grid2col #promos { background: none;}
#promofooter.grid2col #promos li.promo { width: 47%; min-height: 70px; margin-bottom: -10px; }
#promofooter.grid2col #promos li.promo.first { border-right: 1px solid #e8e8e8; }
#promofooter.grid2col li.promo { padding:20px; }

/* PRINT */
@media print {
	body, #main, #content { color: #000 !important; }
	a, a:link, a:visited { color: #000 !important; text-decoration:none !important; }
	#tabs, #globalheader, #globalfooter, #directorynav, .noprint, .hide { display: none !important; }
	#main a.pdf, #main a.html, #main a.qt, #main a.ical, #main a.dl, #main a.dmg, #main a.zip, #main a.keynote, #main a.audio { padding-left: 0 !important; background-image: none !important; }
}

/* iPhone */
@media screen and (max-device-width: 480px) { html { -webkit-text-size-adjust: none; } }


/***************************************************************************************************************************/	
/* http://images.apple.com/v/iphone/d/styles/iphone.css ********************************************************************/
/***************************************************************************************************************************/	

/* typography */
.main .compare-iphones { font-size:1.167em; line-height:1.7143; word-spacing:-1px; } /* 14px/24px */
.mbig { font-size:1.333em; line-height:1.7188; } /* 16px/27px */
.mbig .smaller { font-size:.875em; line-height:1.7143; } /* 14px/24px */

.main h1 { margin-bottom:10px; font-size:1.7142em; line-height:1.1666; font-weight:normal; } /* 24px/28px */
.main h2 { margin-bottom:07px; font-size:1.2857em; line-height:1.3888; font-weight:normal; } /* 18px/25px */
.main h3 { margin-bottom:07px; font-size:1.1428em; line-height:1.5000; } /* 16px/24px */
.main h4 { margin-bottom:07px; font-size:1em; }

.main h1 img,
.main h2 img,
.main h3 img,
.main h4 img { display:block; margin:0; }

.main p { margin-bottom:1.8em; }
.main sup { z-index:1; }
.main .small { font-size:.8571em; line-height:1.5; } /* 12px/18px */
.main .caption { color:#666; }

.main .intro { color:#404040; font-size:1.2857em; line-height:1.7778; font-weight:normal; } /* 18px/32px */
.mbig .intro { font-size:1.125em; line-height:1.8056; } /* 18px/32px */
.main .intro + .more,
.main .intro + .wrap { font-size:1.2857em; } /* 18px */
.mbig .intro + .more,
.mbig .intro + .wrap { font-size:1.125em; } /* 18px */

body.specs #main { font-size:1em; line-height:1.4286; }

/* layout */
.main .column { *display:inline; }

.main .block { display:block; }
.main .inline { display:inline; }
.main .left { float:left; }
.main .right { float:right; }
.main .center { display:block; margin-right:auto; margin-left:auto; text-align:center; }

.flushrow { overflow:hidden; *position:relative; }
.alternate { background:#f6f6f6; }
.flushrow .divider { border-top:1px solid #e2e2e2; }

.flushrow .row { margin:0 auto; width:880px; padding:0 72px; }

.flushrow .flushpad,
.flushrow .padright { padding-right:50px; }

.flushrow .flushpad,
.flushrow .padleft { padding-left:50px; }

.flushrow .flushpad,
.flushrow .flushright { margin-right:-50px; }

.flushrow .flushpad,
.flushrow .flushleft { margin-left:-50px; }

.flushrow .flushtop,
.flushrow .flushbottom,
.flushrow .flushright,
.flushrow .flushleft,
.main .relative { *position:relative; *z-index:1; *zoom:1; }

/* links */
a.more,
em.more,
span.more,
.mbig .smaller a.more,
.mbig .smaller em.more,
.mbig .smaller span.more { display:inline-block; padding-right:.7em; line-height:1.71; line-height:1\9; background-image:url(http://images.apple.com/v/iphone/d/images/more_14.png); background-position:100% 59%; background-size:5px 9px; }

.mbig a.more,
.mbig em.more,
.mbig span.more { background-image:url(http://images.apple.com/v/iphone/d/images/more_16.png); background-size:6px 11px; }

.main .intro + a.more,
.main .intro + em.more,
.main .intro + span.more,
.mbig .intro + a.more,
.mbig .intro + em.more,
.mbig .intro + span.more,
.mbig h3 a.more,
.mbig h3 em.more,
.mbig h3 span.more { background-image:url(http://images.apple.com/v/iphone/d/images/more_18.png); background-size:7px 13px; background-position:100% 55%; }

.mbig a.more.light,
.mbig em.more.light,
.mbig span.more.light { color:#5cc3f6; background-image:url(http://images.apple.com/v/iphone/d/images/more_light_16.png); }

.mbig .more.video { padding-right:1.1875em; background-image:url(http://images.apple.com/v/iphone/d/images/more_video_16.png); background-size:15px 15px; }

@media only screen {
	a.more,
	em.more,
	span.more,
	.mbig .smaller a.more,
	.mbig .smaller em.more,
	.mbig .smaller span.more,
	.mbig a.more,
	.mbig em.more,
	.mbig span.more,
	.main .intro + a.more,
	.main .intro + em.more,
	.main .intro + span.more,
	.mbig .intro + a.more,
	.mbig .intro + em.more,
	.mbig .intro + span.more,
	.mbig h3 a.more,
	.mbig h3 em.more,
	.mbig h3 span.more { background-image:url(/v/iphone/d/images/more.svg); }

	.mbig a.more.light,
	.mbig em.more.light,
	.mbig span.more.light { background-image:url(/v/iphone/d/images/more_light.svg); }

	.mbig .more.video { background-image:url(/v/iphone/d/images/more_video.svg); }
}

.main a { cursor:pointer; }
.main a.block { color:#000; }
.main a.wrap { text-decoration:none; }
.main a.wrap:hover span { text-decoration:underline; cursor:pointer; }

.main p + .more,
.main p + .button,
.main p + .wrap { display:inline-block; position:relative; z-index:1; top:-1.3em; text-align:left; }
.main p + .more + .more,
.main p + .wrap + .more,
.main p + .more + .wrap,
.main p + .wrap + .more { display:inline-block; position:relative; z-index:1; top:-1em; text-align:left; }

.main p + .button { top:-1.9em; }
.button { display:inline-block; padding:5px 28px; border:1px solid #08c; font-size:.75em;
	-webkit-border-radius:3px;
	   -moz-border-radius:3px;
	        border-radius:3px;
}

/* galleries */
.case-content { display:none; }

.gallery,
.gallery .gallery-view { position:relative; z-index:1; }
.gallery .gallery-content { position:absolute; z-index:1; top:0; left:0; }

.gallery-video .gallery-view,
.gallery-video .gallery-content { position:static; }
.moviePanel { position:relative; z-index:2; width:848px !important; height:480px !important; }
.moviePanel + .close { position:absolute; z-index:1; top:0; right:0; bottom:0; left:0; background:#fff url(http://images.apple.com/v/iphone/d/images/close.png) no-repeat 40px 40px; background-size:30px 30px; }
@media only screen {
	.moviePanel + .close { background-image:url(/v/iphone/d/images/close.svg); }
}
@media only screen and (max-device-width:768px) {
	body > .gallery-view { position:fixed; z-index:1; top:0; right:0; bottom:0; left:0; }
	body > .gallery-view .gallery-content-movie { height:100% !important; padding-top:0 !important; }
	body > .gallery-view .moviePanel { position:fixed; }
	body > .gallery-view .moviePanel + .close { position:fixed; }
}

.gallery-slide { width:100%; }
.gallery-slide .gallery-view-wrapper { margin:0 auto; width:1024px; }
.gallery-slide .gallery-view { width:7000px; }
.gallery-slide .gallery-content { float:left; position:relative; z-index:1; -webkit-transform:translateZ(0); }

.gallery-slide .fadeout { position:absolute; top:0; z-index:1002; width:12%; height:100%; background:rgba(255,255,255,1); }
.gallery-slide .fadeout.right { right:0; }
.gallery-slide .fadeout.left { left:0; }
.gallery-slide .fadeout.left:after,
.gallery-slide .fadeout.right:before { position:absolute; z-index:1; width:100%; height:100%; content:''; }
.gallery-slide .fadeout.left:after { right:-100%; background:-webkit-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,.8) 100%); }
.gallery-slide .fadeout.right:before { left:-100%; background:-webkit-linear-gradient(left, rgba(255,255,255,.8) 0%, rgba(255,255,255,1) 100%); }
@media only screen and (max-width:1370px) { /* responsive */
	.gallery-slide .fadeouts { display:none; }
}
@media only screen and (max-width:2700px) { /* responsive */
	.gallery-slide .fadeouts { position:absolute; z-index:1002; min-width:2700px; height:100%; left:50%; margin-left:-1350px; }
}

/* sequences */
.sequence { position:relative; z-index:1; }
.sequence .media { display:none; }
.sequence .end-frame { display:none; }
.sequence .start-frame { display:block; }
.sequence.ready .media { display:block; }
.sequence.ready .start-frame { display:none; }
.sequence.ended .start-frame { display:none; }
.sequence.ended .media { display:none; }
.sequence.ended .end-frame { display:block; }


/* Navigation
------------------------*/

/* product header */
#productheader { border-bottom:1px solid #e6e6e6; }
#productheader h2 a { text-indent:0; }
#productheader h2 a img { margin-top:-3px; }
#productheader li a { text-shadow:#fff 0 1px 0; }
#productheader ul li a { margin-left:24px; }

/* paddles */
.paddle-nav { position:absolute; z-index:1003; top:50%; left:50%; width:100%; height:0; margin-left:-50%; }
.paddle-nav li .arrow { display:block; position:absolute; z-index:1003; top:50%; margin:-65px 25px 0; width:67px; height:130px; opacity:0; filter:alpha(opacity=0); cursor:pointer; outline:none; background-image:url(http://images.apple.com/global/elements/blank.gif);
	-webkit-transition:.25s opacity linear;
	   -moz-transition:.25s opacity linear;
	        transition:.25s opacity linear;
}

.gallery:hover .paddle-nav li .arrow { opacity:.75; filter:alpha(opacity=75); }
.paddle-nav li .arrow:hover { opacity:.8; filter:alpha(opacity=80); }
.paddle-nav li .arrow.disabled { display:none; }
.paddle-nav li .arrow b { display:block; overflow:hidden; width:67px; height:130px; text-indent:-9999px; background:no-repeat 0 0; background-size:67px 130px; behavior:url(/global/scripts/lib/ie7pngfix.htc); }

.paddle-nav li .arrow.previous { left:0; }
.paddle-nav li .arrow.previous b { float:left; background-image:url(http://images.apple.com/v/iphone/d/images/paddle_previous.png); }

.paddle-nav li .arrow.next { right:0; }
.paddle-nav li .arrow.next b { float:right; background-image:url(http://images.apple.com/v/iphone/d/images/paddle_next.png); }

.paddle-nav.solid li .arrow { background-color:#ebebeb;
	-webkit-border-radius:8px;
	   -moz-border-radius:8px;
	        border-radius:8px;
}

@media only screen and (min-width:1408px) { /* responsive */
	.paddle-nav { width:1408px; margin-left:-704px; }
}
@media only screen and (min-width:1620px) { /* responsive */
	.paddle-nav { width:1650px; margin-left:-825px; }
}
@media only screen and (min-width:1900px) { /* responsive */
	.paddle-nav { width:100%; margin-left:-50%; }
	.paddle-nav li .arrow.previous { left:5%; }
	.paddle-nav li .arrow.next { right:5%; }
}

@media only screen and (max-device-width:768px) { /* on device */
	.paddle-nav { display:none; }
}

/* dot nav */
#main .dot-nav li { margin:0 8px; width:12px; height:12px; }
#main .dot-nav li a { top:2px; left:2px; width:6px; height:6px; background:#949494; border:1px solid transparent; outline:none;
	-webkit-box-shadow:none;
	   -moz-box-shadow:none;
	        box-shadow:none;
	-webkit-border-radius:50%;
	   -moz-border-radius:50%;
	        border-radius:50%;
}
#main .dot-nav li a:hover { top:2px; background:#666; }
#main .dot-nav li a.active { top:0; left:0; border:1px solid #08c; background:transparent; width:10px; height:10px;
	-webkit-box-shadow:none;
	   -moz-box-shadow:none;
	        box-shadow:none;
}

@media only screen and (max-device-width:768px) { /* on device */
	#main .dot-nav li a { -webkit-pointer-events:none; pointer-events:none; }
}

/* color picker nav */
.color-nav { text-align:center; }
.color-nav div,
.color-nav ul,
.color-nav li,
.color-nav h4,
.color-nav a { display:inline-block; *display:inline; *zoom:1; }
.color-nav ul { height:40px; }
.color-nav li { position:relative; z-index:1; margin:0 3px; width:40px; height:40px; overflow:hidden; background-color:transparent; }
.color-nav a { position:absolute; z-index:1; top:0; left:0; width:40px; height:120px; background:no-repeat 0 0; background-size:40px 120px; text-indent:-9999px; }
.color-nav a:hover { top:-40px; }
.color-nav a.active { top:-80px; cursor:default; }

.color-nav h4 { font-weight:normal; font-size:.75em; }

.color-nav .none a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_none.png); }

.color-nav.iphone-5c-color-nav .green  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_green.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_green.gif); }
.color-nav.iphone-5c-color-nav .blue   a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_blue.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_blue.gif); }
.color-nav.iphone-5c-color-nav .yellow a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_yellow.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_yellow.gif); }
.color-nav.iphone-5c-color-nav .white  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_white.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_white.gif); }
.color-nav.iphone-5c-color-nav .pink   a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_pink.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_pink.gif); }
.color-nav.iphone-5c-color-nav .black  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_black.png); *background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5c_black.gif); }

.color-nav.iphone-5s-color-nav .silver a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_device_silver.png); }
.color-nav.iphone-5s-color-nav .gold   a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_device_gold.png); }
.color-nav.iphone-5s-color-nav .black  a,
.color-nav.iphone-5s-color-nav .gray   a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_device_gray.png); }

.color-nav.iphone-5s-color-nav .color-nav-cases .brown  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_brown.png); }
.color-nav.iphone-5s-color-nav .color-nav-cases .beige  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_beige.png); }
.color-nav.iphone-5s-color-nav .color-nav-cases .yellow a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_yellow.png); }
.color-nav.iphone-5s-color-nav .color-nav-cases .blue   a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_blue.png); }
.color-nav.iphone-5s-color-nav .color-nav-cases .black  a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_black.png); }
.color-nav.iphone-5s-color-nav .color-nav-cases .red    a { background-image:url(http://images.apple.com/v/iphone/d/images/colornav_iphone_5s_case_red.png); }

/* video thumb */
.videothumb { display:block; width:260px; }
.videothumb .image,
.videothumb .image img {
	-webkit-border-radius:4px;
	   -moz-border-radius:4px;
	        border-radius:4px;
}
.videothumb .image { display:inline-block; border:1px solid #ececec; }
.videothumb:nth-child(1n) .image { border:none;
	-webkit-box-shadow:0 1px 3px rgba(0, 0, 0, .4);
	   -moz-box-shadow:0 1px 3px rgba(0, 0, 0, .4);
	        box-shadow:0 1px 3px rgba(0, 0, 0, .4);
}
.videothumb,
.videothumb .image { position:relative; z-index:1; }
.videothumb img { display:block; }
.videothumb .play { position:absolute; top:49px; left:105px; z-index:2; display:block; width:46px; height:46px; opacity:1; *visibility:visible; background:url(http://images.apple.com/v/iphone/d/images/play_black.png) 0 0 no-repeat; background-size:46px 46px; }
.videothumb .play.blue { background-image:url(http://images.apple.com/v/iphone/d/images/play_blue.png); }
.videothumb .play.white { background-image:url(http://images.apple.com/v/iphone/d/images/play_white.png); }
.videothumb .play.lightblue { background-image:url(http://images.apple.com/v/iphone/d/images/play_lightblue.png); }
@media only screen {
	.videothumb .play { background-image:url(/v/iphone/d/images/play_black.svg); }
	.videothumb .play.blue { background-image:url(/v/iphone/d/images/play_blue.svg); }
	.videothumb .play.white { background-image:url(/v/iphone/d/images/play_white.svg); }
	.videothumb .play.lightblue { background-image:url(/v/iphone/d/images/play_lightblue.svg); }
}

.videothumb .play.top,
.videothumb .play.bottom {
	-webkit-transition:opacity 300ms cubic-bezier(0.445, 0.050, 0.550, 0.950);
	   -moz-transition:opacity 300ms cubic-bezier(0.445, 0.050, 0.550, 0.950);
	        transition:opacity 300ms cubic-bezier(0.445, 0.050, 0.550, 0.950);
}

.videothumb .play.top { z-index:3; opacity:1; *visibility:visible; }
.videothumb .play.bottom { z-index:2; opacity:0; *visibility:hidden; }

.videothumb:hover .play.top,
a:hover .videothumb .play.top,
.videothumb:hover .play.bottom,
a:hover .videothumb .play.bottom { 
	-webkit-transition-duration:150ms;
	   -moz-transition-duration:150ms;
	        transition-duration:150ms;
}

.videothumb:hover .play.top,
a:hover .videothumb .play.top { opacity:0; *visibility:hidden; }

.videothumb:hover .play.bottom,
a:hover .videothumb .play.bottom { opacity:1; *visibility:visible; }

.videothumb:hover,
.videothumb:hover .more { text-decoration:underline; }


/* Footers
------------------------*/

/* buystrip */
#buystrip { margin:0 auto; width:980px; padding-top:30px; color:#333; font-size:12px; line-height:1.4167; text-align:center; border-top:1px solid transparent; }
#buystrip.buystrip-border { border-top-color:#e2e2e2; }

#buystrip a.block { color:#333; }
#buystrip img { display:block; }
#buystrip h3 { margin-bottom:13px; }
#buystrip p { margin:9px auto 13px; width:85%; }

#buystrip span,
#buystrip .more { font-size:1.3333em; line-height:1.5; }
#buystrip .more { background-image:url(http://images.apple.com/v/iphone/d/images/more_16.png); background-size:6px 11px; }
@media only screen {
	#buystrip .more { background-image:url(/v/iphone/d/images/more.svg); }
}

#buystrip .column { position:relative; z-index:1; margin:0 0 24px; width:238px; min-height:229px; }
#buystrip .column img { margin:0 auto; }
#buystrip .column img.icon { margin-top:-3px; margin-bottom:25px; }

#buystrip .column.product { width:263px; }
#buystrip .column.product h3 { margin-top:-4px; margin-bottom:-9px; }
#buystrip .column.product p { color:#666; }
#buystrip .column.product p.price { margin:14px auto 5px; }
#buystrip .column.product .sosumi { margin:0 auto -15px; }
#buystrip .column.product img { margin-bottom:15px; }

#buystrip .online p,
#buystrip .retail p,
#buystrip .call   p { min-height:68px; }

#buystrip .column.call p { margin-left:21px; }

#buystrip .column.app p,
#buystrip .column.app .more { position:relative; z-index:1; }
#buystrip .column.app p { left:14px; }
#buystrip .column.app .more { left:22px; }

#buystrip .strip,
#buystrip .strip .more { font-size:.9167em; }
#buystrip .strip p { display:inline-block; *display:inline; white-space:nowrap; }
#buystrip .strip a.block { display:inline; display:inline-block; margin:0 20px; }
#buystrip .strip a.block.first { margin-left:-30px; }
#buystrip .strip .more { background-image:url(http://images.apple.com/v/iphone/d/images/more_10.png); background-position:100% 55%; *background-position:100% 65%; background-size:4px 7px; }
@media only screen {
	#buystrip .strip .more { background-image:url(/v/iphone/d/images/more.svg); }
}
#buystrip .strip .app img { position:relative; top:-2px; z-index:1; display:inline; margin-right:4px; vertical-align:middle; }

/* sosumi */
.sosumi { margin:24px auto 18px; width:940px; padding:0 20px; }
#buystrip + .sosumi { margin-top:10px; padding-top:24px; border-top:1px solid #e2e2e2; }
.sosumi a { color:#333; }
.sosumi ol { line-height:1.2; margin:0; padding-right:21px; padding-left:21px; }
.sosumi ul { margin:3px 0px 0px 0px; }
.sosumi li { padding-bottom:3px; }
.sosumi ol li { line-height:1; }
.sosumi small { font-size:1em; }


/* Page Specific
------------------------*/

/* battery */
#battery .main { padding-top:60px; }
#battery .main .column { width:415px; }


/* buy */
#buy #globalheader { margin-bottom:-54px; }
#buy .main { padding-bottom:19px; }
#buy .main .row { padding:0 50px 35px; }
#buy .row.hero { margin-bottom:70px; padding-top:132px; padding-bottom:40px; border-bottom:1px solid #ecebeb; }
#buy .row.hero h1 { margin-right:-28px; margin-left:-28px; }
#buy .row.hero .hero { margin-top:50px; }

#buy .grid2col.divider { margin-top:10px; padding:55px 50px 0; }
#buy .grid2col .padright { padding:0 65px 0 0; }

#buy .att img { margin-top:19px; margin-bottom:5px; }
#buy .sprint img { margin-top:17px; margin-bottom:5px; }
#buy .tmobile img { margin-top:45px; margin-bottom:14px; }
#buy .verizon img { margin-top:13px; margin-bottom:5px; }

#buy .main .strip { margin-top:50px; padding-top:20px; padding-bottom:0; }


/***************************************************************************************************************************/	
/* From: http://images.apple.com/v/iphone/compare/a/styles/compare.css *****************************************************/
/***************************************************************************************************************************/
	
/* Sticky table header */
.main { position:relative; z-index:1; padding:0;  }
.main .row { width:962px; padding:0; }
.sticky { position:-webkit-sticky; top:0; z-index:2; display:block;  border-bottom:1px solid #e5e5e5; background:#fff; }
.sticky-container .title div { margin:0 0 0 223px; width:757px; height:25px; padding:16px 0 18px; }

/* General */
#compare .left { float:left; }
#compare .hero h1 img.left { margin:0 0 0 1px; }

#compare .compare-iphones { position:relative; z-index:1; padding-bottom:32px; margin-top:-1px; }
#compare .compare-iphones table { table-layout:fixed; }
#compare .compare-iphones tbody th,
#compare .compare-iphones tbody td { vertical-align:top; border-top:1px solid #e5e5e5; }

#compare .compare-iphones tbody th { width:178px; padding:12px 0 16px 0; border-top:1px solid #e5e5e5; }
#compare .compare-iphones tbody th img { margin-left:8px; }

#compare .compare-iphones tbody tr.row-space { height:30px; }
#compare .compare-iphones tbody tr.row-space th,
#compare .compare-iphones tbody tr.row-space td { border:none; }

#compare .compare-iphones tbody td { width:226px; padding:17px 12px 13px 20px; border-right:1px solid #e5e5e5; }
#compare .compare-iphones tbody td.first { padding-left:0; }
#compare .compare-iphones tbody td.last { border-right:none; }

#compare .compare-iphones tbody td h4 { margin-bottom:7px; }
#compare .compare-iphones tbody td p { margin-bottom:0; }
#compare .compare-iphones tbody td.divide { width:46px; padding:0; border:none; }

#compare .compare-iphones tbody td ul { margin-bottom:-6px; }
#compare .compare-iphones tbody td ul li { margin-bottom:6px; }
#compare .compare-iphones tbody td ul li.two-line { min-height:3.4286em; }
#compare .compare-iphones tbody td ul li.three-line { min-height:5.1429em; }
#compare .compare-iphones tbody .positioned { position:relative; z-index:1; }
#compare .compare-iphones tbody .positioned img { z-index:1; }

/* Page Specific */
#compare .compare-iphones tbody .phone th,
#compare .compare-iphones tbody .phone td,
#compare .compare-iphones tbody .phone td.divide { border-top:1px solid transparent; }
#compare .compare-iphones tbody .phone th { padding-top:28px; }
#compare .compare-iphones tbody .phone td { padding-top:31px; }
#compare .compare-iphones tbody .phone td img { margin-bottom:16px; }

#compare .compare-iphones tbody .capacity-price p { margin-bottom:3px; }
#compare .compare-iphones tbody .capacity-price .alignment { width:100%; } /*height:54px; min-height:54px;*/
#compare .compare-iphones tbody .capacity-price .capacity { margin-top:-2px; padding-right:5px; font-size:0.8571em; }
#compare .compare-iphones tbody .capacity-price .currency { margin-top:-2px; font-size:0.9144em; line-height:1.5em; }
#compare .compare-iphones tbody .capacity-price .price { font-size:1.2857em; line-height:1.15em; }
#compare .compare-iphones tbody .capacity-price .buynows { margin-bottom:5px; }

#compare .compare-iphones tbody .color ul li { padding:0 0 2px 30px; }

#compare .compare-iphones tbody .color .iphone-5s li { background:url(http://images.apple.com/v/iphone/compare/a/images/compare_iphone_5s_colors.jpg) no-repeat; }
#compare .compare-iphones tbody .color .iphone-5s li.black,
#compare .compare-iphones tbody .color .iphone-5s li.gray { background-position:0 0; }
#compare .compare-iphones tbody .color .iphone-5s li.gold { background-position:0 -30px; }
#compare .compare-iphones tbody .color .iphone-5s li.silver { background-position:0 -60px; }

#compare .compare-iphones tbody .color .iphone-5c li { background:url(http://images.apple.com/v/iphone/compare/a/images/compare_iphone_5c_colors.jpg) no-repeat; }
#compare .compare-iphones tbody .color .iphone-5c li.blue { background-position:0 0; }
#compare .compare-iphones tbody .color .iphone-5c li.green { background-position:0 -30px; }
#compare .compare-iphones tbody .color .iphone-5c li.yellow { background-position:0 -60px; }
#compare .compare-iphones tbody .color .iphone-5c li.pink { background-position:0 -90px; }
#compare .compare-iphones tbody .color .iphone-5c li.white { background-position:0 -120px; }

#compare .compare-iphones tbody .color .iphone-4s li { background:url(http://images.apple.com/v/iphone/compare/a/images/compare_iphone_4s_colors.jpg) no-repeat; }
#compare .compare-iphones tbody .color .iphone-4s li.black { background-position:0 0; }
#compare .compare-iphones tbody .color .iphone-4s li.white { background-position:0 -30px; }

#compare .compare-iphones tbody .weight td span { color:#666; }

#compare .compare-iphones tbody .chips td div { clear:both; }
#compare .compare-iphones tbody .chips td img { margin:0 16px 15px 0; }
#compare .compare-iphones tbody .chips td img.last { margin-bottom:7px; }
#compare .compare-iphones tbody .chips td h4 { padding-top:3px; }

#compare .compare-iphones tbody .battery td .batteryTime  { padding-bottom:0; margin-bottom:10px; }
#compare .compare-iphones tbody .battery td .batteryTime h4  { margin-bottom:0; }
#compare .compare-iphones tbody .battery td .batteryTime div.timeTitle  { font-weight:bold; }
#compare .compare-iphones tbody .battery td .batteryTime div.timeData  { line-height:110%; }
#compare .compare-iphones tbody .battery td .batteryTimeLast  { padding-bottom:0; margin-bottom:0px; }
#compare .compare-iphones tbody .battery td .batteryTimeLast h4  { margin-bottom:0; }
#compare .compare-iphones tbody .battery td .batteryTimeLast div.timeTitle  { font-weight:bold; }
#compare .compare-iphones tbody .battery td .batteryTimeLast div.timeData  { line-height:110%; }

#compare .compare-iphones tbody .cellular td h4 { margin-top:39px; }

#compare .compare-iphones tbody .headphones td img { margin:10px -12px 0 0; }
#compare .compare-iphones tbody .headphones td ul,
#compare .compare-iphones tbody .headphones td.last p { width:158px; }
/*#compare .compare-iphones tbody .headphones td.last img { margin-top:40px; }*/

#compare .compare-iphones tbody .connector td img { margin:12px -12px 0 0; }
#compare .compare-iphones tbody .connector td.last img { margin-top:-29px; }

#compare .compare-iphones tbody .buy th { border-top:none; }

/* buy now buttons */
#compare .compare-iphones tbody .buy .buynows { width:95px; background-repeat:no-repeat; }
#compare .compare-iphones tbody .buy .buynows:hover { background-position:0 -25px; }
#compare .compare-iphones tbody .buy .buynows:active { background-position:0 -50px; }
	
	
</style>
	
<div id="compare" class="iphone">
	<div id="main" class="main">
		<div class="flushrow">
			<div class="row">
				<div class="sticky-container">
					
					<header class="title sticky hero selfclear">
						<div>
							<h1>
								<img class="left" width="645" height="25" alt="iPhone 5s - iPhone 5c - iPhone 4s" src="/assets/aafes/images/apple/compare_title.png">
							</h1>
						</div>
					</header>
					
					<section class="compare-iphones selfclear flushpad">
						<table cellspacing="0" cellpadding="0" border="0">
							<tbody>
								<tr class="phone">
									<th>
										<h3>Phone</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<img height="174" alt="iPhone 5s" src="/assets/aafes/images/apple/compare_iphone5s.png">
									</td>
									<td>
										<img height="174" alt="iPhone 5c" src="/assets/aafes/images/apple/compare_iphone5c.png">
									</td>
									<td class="last">
										<img height="174" alt="iPhone 4s" src="/assets/aafes/images/apple/compare_iphone4s.png">
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="capacity-price">
									<th>
										<div class="positioned">
											<h3>Capacity<sup>1</sup></h3>
										</div>
									</th>
									<td class="divide"></td>
									<td class="first">
										<div class="alignment">
											<p><span class="capacity left"><b>16GB</b></span></p>
											<p><span class="capacity left"><b>32GB</b></span></p>
											<p><span class="capacity left"><b>64GB</b></span></p>
										</div>
									</td>
									<td>
										<div class="alignment">
											<p><span class="capacity left"><b>16GB</b></span></p>
											<p><span class="capacity left"><b>32GB</b></span></p>
										</div>
									</td>
									<td class="last">
										<div class="alignment">
											<p><span class="capacity left"><b>8GB</b></span></p>
										</div>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="chips">
									<th>
										<h3>Chips</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<div>
											<h4>A7 chip with 64-bit architecture</h4>
										</div>
										<div>
											<h4>M7 motion coprocessor</h4>
										</div>
									</td>
									<td>
										<h4>A6 chip</h4>
									</td>
									<td class="last">
										<h4>A5 chip</h4>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="display">
									<th>
										<h3>Display</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li><b>4-inch (diagonal) Retina display</b></li>
											<li>1136-by-640 resolution</li>
											<li>326 ppi</li>
										</ul>
									</td>
									<td>
										<ul>
											<li><b>4-inch (diagonal) Retina display</b></li>
											<li>1136-by-640 resolution</li>
											<li>326 ppi</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li><b>3.5-inch (diagonal) Retina display</b></li>
											<li>960-by-640 resolution</li>
											<li>326 ppi</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="touchid">
									<th>
										<h3>Identity Sensor</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<p>Touch ID</p>
									</td>
									<td>
										<p>&mdash;</p>
									</td>
									<td class="last">
										<p>&mdash;</p>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="assistant">
									<th>
										<div class="positioned">
											<h3>Intelligent Assistant<sup>2</sup></h3>
										</div>
									</th>
									<td class="divide"></td>
									<td class="first">
										<p>Siri</p>
									</td>
									<td>
										<p>Siri</p>
									</td>
									<td class="last">
										<p>Siri</p>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="isight-camera">
									<th>
										<h3>iSight Camera</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li><b>8 megapixels with 1.5&#956; pixels</b></li>
											<li>f/2.2 aperture</li>
											<li>Sapphire crystal lens cover</li>
											<li>True Tone flash</li>
											<li>Backside illumination sensor</li>
											<li>Five-element lens</li>
											<li>Hybrid IR filter</li>
											<li>Autofocus</li>
											<li>Tap to focus</li>
											<li>Face detection</li>
											<li>Panorama</li>
											<li>Auto image stabilization</li>
											<li>Burst mode</li>
											<li>Photo geotagging</li>
										</ul>
									</td>
									<td>
										<ul>
											<li><b>8 megapixels</b></li>
											<li>f/2.4 aperture</li>
											<li>Sapphire crystal lens cover</li>
											<li>LED flash</li>
											<li>Backside illumination sensor</li>
											<li>Five-element lens</li>
											<li>Hybrid IR filter</li>
											<li>Autofocus</li>
											<li>Tap to focus</li>
											<li>Face detection</li>
											<li>Panorama</li>
											<li>&mdash;</li>
											<li>&mdash;</li>
											<li>Photo geotagging</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li><b>8 megapixels</b></li>
											<li>f/2.4 aperture</li>
											<li>&mdash;</li>
											<li>LED flash</li>
											<li>Backside illumination sensor</li>
											<li>Five-element lens</li>
											<li>Hybrid IR filter</li>
											<li>Autofocus</li>
											<li>Tap to focus</li>
											<li>Face detection</li>
											<li>Panorama</li>
											<li>&mdash;</li>
											<li>&mdash;</li>
											<li>Photo geotagging</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								<tr class="video-recording">
									<th>
										<h3>Video Recording</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li><b>1080p HD video recording</b></li>
											<li>30 fps</li>
											<li>True Tone flash</li>
											<li>Slo-mo video</li>
											<li>Improved video stabilization</li>
											<li>Take still photo while recording video</li>
											<li>Face detection</li>
											<li>3x zoom</li>
											<li>Video geotagging</li>
											<li>Tap to focus</li>
										</ul>
									</td>
									<td>
										<ul>
											<li><b>1080p HD video recording</b></li>
											<li>30 fps</li>
											<li>LED flash</li>
											<li>&mdash;</li>
											<li>Video stabilization</li>
											<li>Take still photo while recording video</li>
											<li>Face detection</li>
											<li>3x zoom</li>
											<li>Video geotagging</li>
											<li>Tap to focus</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li><b>1080p HD video recording</b></li>
											<li>30 fps</li>
											<li>LED flash</li>
											<li>&mdash;</li>
											<li>Video stabilization</li>
											<li class="two-line">&mdash;</li>
											<li>Face detection</li>
											<li>&mdash;</li>
											<li>Video geotagging</li>
											<li>Tap to focus</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="facetime-camera">
									<th>
										<h3>FaceTime Camera</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li>1.2MP photos (1280 by 960)</li>
											<li>720p&nbsp;HD video recording</li>
											<li>New backside illumination sensor</li>
										</ul>
									</td>
									<td>
										<ul>
											<li>1.2MP photos (1280 by 960)</li>
											<li>720p&nbsp;HD video recording</li>
											<li>New backside illumination sensor</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li>VGA-resolution photos</li>
											<li>VGA-resolution video recording</li>
											<li>Backside illumination sensor</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>

								<tr class="audio-calling">
									<th>
										<div class="positioned">
											<h3>Video and<br/>Audio Calling<sup>3</sup></h3>
										</div>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li><b>FaceTime</b></li>
											<li>iPhone 5s to any FaceTime-enabled device over Wi&ndash;Fi or cellular</li>
										</ul>
									</td>
									<td>
										<ul>
											<li><b>FaceTime</b></li>
											<li>iPhone 5c to any FaceTime-enabled device over Wi&ndash;Fi or cellular</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li><b>FaceTime</b></li>
											<li>iPhone 4s to any FaceTime-enabled device over Wi&ndash;Fi or cellular</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="cellular">
									<th>
										<h3>Cellular and Wireless</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li>LTE<sup>4</sup></li>
											<li>GSM model: GSM/EDGE</li>
											<li>UMTS/HSPA+</li>
											<li>DC-HSDPA</li>
											<li>CDMA model: CDMA EV-DO<br/>Rev. A and Rev. B</li>
											<li>Wi-Fi (802.11a/b/g/n; 802.11n on 2.4GHz and 5GHz)</li>
											<li>Bluetooth 4.0</li>
											<li>GPS and GLONASS</li>
										</ul>
									</td>
									<td>
										<ul>
											<li>LTE<sup>4</sup></li>
											<li>GSM model: GSM/EDGE</li>
											<li>UMTS/HSPA+</li>
											<li>DC-HSDPA</li>
											<li>CDMA model: CDMA EV-DO<br/>Rev. A and Rev. B</li>
											<li>Wi-Fi (802.11a/b/g/n; 802.11n on 2.4GHz and 5GHz)</li>
											<li>Bluetooth 4.0</li>
											<li>GPS and GLONASS</li>
										</ul>
									</td>
									<td class="last">
										<ul>
											<li>&mdash;</li>
											<li>GSM/EDGE</li>
											<li>UMTS/HSPA+</li>
											<li>&mdash;</li>
											<li>CDMA EV-DO Rev. A<sup>5</sup><br/></li>
											<li>Wi-Fi (802.11a/b/g/n; 802.11n on 2.4GHz)</li>
											<li>Bluetooth 4.0</li>
											<li>GPS and GLONASS</li>
										</ul>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>
								
								<tr class="sim-card">
									<th>
										<h3>Sim card</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li>Nano-SIM</li>
										</ul>
									</td>
									<td>
										<ul>
											<li>Nano-SIM</li>
										</ul>
									</td>
									<td class="last">
										<p>Micro-SIM</p>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>

								<tr class="battery">
									<th>
										<h3>Battery Life<sup>6</sup></h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<div class="batteryTime">
											<div class="timeTitle">Talk time:</div>
											<div class="timeData">Up to 10 hours on 3G</div>
										</div>
										<div class="batteryTime">
											<div class="timeTitle">Browsing time:</div>
											<div class="timeData">Up to 10 hours on LTE</div>
											<div class="timeData">Up to 8 hours on 3G</div>
											<div class="timeData">Up to 10 hours on WiFi</div>
										</div>
										<div class="batteryTimeLast">
											<div class="timeTitle">Standby time:</div>
											<div class="timeData">Up to 250 hours</div>
										</div>
									</td>
									<td>
										<div class="batteryTime">
											<div class="timeTitle">Talk time:</div>
											<div class="timeData">Up to 10 hours on 3G</div>
										</div>
										<div class="batteryTime">
											<div class="timeTitle">Browsing time:</div>
											<div class="timeData">Up to 10 hours on LTE</div>
											<div class="timeData">Up to 8 hours on 3G</div>
											<div class="timeData">Up to 10 hours on WiFi</div>
										</div>
										<div class="batteryTimeLast">
											<div class="timeTitle">Standby time:</div>
											<div class="timeData">Up to 250 hours</div>
										</div>
									</td>
									<td class="last">
										<div class="batteryTime">
											<div class="timeTitle">Talk time:</div>
											<div class="timeData">Up to 8 hours on 3G</div>
										</div>
										<div class="batteryTime">
											<div class="timeTitle">Browsing time:</div>
											<div class="timeData">&mdash;</div>
											<div class="timeData">Up to 6 hours on 3G</div>
											<div class="timeData">Up to 9 hours on WiFi</div>
										</div>
										<div class="batteryTimeLast">
											<div class="timeTitle">Standby time:</div>
											<div class="timeData">Up to 200 hours</div>
										</div>
									</td>
								</tr>
								<tr class="row-space">
									<th></th>
									<td class="divide"></td>
									<td class="first"></td>
									<td></td>
									<td class="last"></td>
								</tr>

								<tr class="buy">
									<th>
										<h3>In the Box</h3>
									</th>
									<td class="divide"></td>
									<td class="first">
										<ul>
											<li>Apple EarPods with Remote and Mic</li>
											<li>EarPods storage and travel case</li>
											<li>USB Power Adapter</li>
											<li>Lightening to USB cable</li>
										</ul>
									</td>
									<td>
										<ul>
											<li>Apple EarPods with Remote and Mic</li>
											<li>EarPods storage and travel case</li>
											<li>USB Power Adapter</li>
											<li>Lightening to USB cable</li>
										</ul>										
									</td>
									<td class="last">
										<ul>
											<li>Apple Earphones with Remote and Mic</li>
											<li>&mdash;</li>
											<li>USB Power Adapter</li>
											<li>30-pin to USB cable</li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
					
				</div>
			</div>
		</div>
	</div>
	
	<div class="sosumi">
		<ul>
			<li><small>iPhone 5c colors may vary and change over time.</small></li>
		</ul>
		<ol>
			<li style="list-style: decimal outside none;"><small>1GB = 1 billion bytes; actual formatted capacity less.</small></li>
			<li style="list-style: decimal outside none;"><small>Siri may not be available in all languages or in all areas, and features may vary by area. Cellular data charges may apply.</small></li>
			<li style="list-style: decimal outside none;"><small>FaceTime calling requires a FaceTime-enabled device for the caller and recipient and a Wi-Fi connection. Availability over a cellular network depends on carrier policies; data charges may apply.</small></li>
			<li style="list-style: decimal outside none;"><small>LTE is available in select markets and through select carriers. Speeds will vary based on site conditions. For details on LTE support, contact your carrier and see <a href="http://www.apple.com/iphone/LTE" target="blank">www.apple.com/iphone/LTE</a>.</small></li>
			<li style="list-style: decimal outside none;"><small>CDMA is available only if iPhone 4s is sold and activated for use on a CDMA network.</small></li>
			<li style="list-style: decimal outside none;"><small>All battery claims depend on network configuration and many other factors; actual results will vary. Battery has limited recharge cycles and may eventually need to be replaced by Apple service provider. Battery life and charge cycles vary by use and settings. See <a href="http://www.apple.com/batteries" target="blank">www.apple.com/batteries</a> and <a href="http://www.apple.com/iphone/battery.html" target="blank">www.apple.com/iphone/battery.html</a> for more information.</small></li>
		</ol>
		<ul>
			<li><small>TM and &copy; 2013 Apple Inc. All rights reserved.</small></li>
		</ul>
	</div>
	
</div>
