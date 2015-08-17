/*
    Version 1.3.2
    The MIT License (MIT)

    Copyright (c) 2014 Dirk Groenen

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
*/
( function ( $ ) {
    $.fn.viewportChecker = function ( useroptions ) {
        // Define options and extend with user
        var options = {
            classToAdd: 'visible',
            classToRemove: 'hidden',
            offset: 100,
            callbackFunction: function ( elem ) {}
        };
        $.extend( options, useroptions );

        // Cache the given element and height of the browser
        var $elem = this,
            windowHeight = $( window ).height();

        this.checkElements = function () {
            // Set some vars to check with
            var scrollElem = ( ( navigator.userAgent.toLowerCase().indexOf( 'webkit' ) != -1 ) ? 'body' : 'html' ),
                viewportTop = $( scrollElem ).scrollTop(),
                viewportBottom = ( viewportTop + windowHeight );

            $elem.each( function () {
                var $obj = $( this );

                // define the top position of the element and include the offset which makes is appear earlier or later
                var elemTop = Math.round( $obj.offset().top ) + options.offset,
                    elemBottom = elemTop + ( $obj.height() );

                // Add class if in viewport
                if ( ( elemTop < viewportBottom ) && ( elemBottom > viewportTop ) ) {
                    $obj.addClass( options.classToAdd );
                    $obj.removeClass( options.classToRemove );

                    // Do the callback function. Callback wil send the jQuery object as parameter
                    options.callbackFunction( $obj );
                }
                else {
                    //else function to reset so it's not just a one-time animation
                    $obj.removeClass( options.classToAdd );
                    $obj.addClass( options.classToRemove );
                }
            } );
        };

        // Run checkelements on load and scroll
        $( window ).scroll( this.checkElements );
        this.checkElements();

        // On resize change the height var
        $( window ).resize( function ( e ) {
            windowHeight = e.currentTarget.innerHeight;
        } );
    };
} )( jQuery );

/*!
 * jQuery Mobile Events
 * by Ben Major (www.ben-major.co.uk)
 *
 * Copyright 2011, Ben Major
 * Licensed under the MIT License:
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
( function ( $ ) {
    $.attrFn = $.attrFn || {};

    // navigator.userAgent.toLowerCase() isn't reliable for Chrome installs
    // on mobile devices. As such, we will create a boolean isChromeDesktop
    // The reason that we need to do this is because Chrome annoyingly
    // purports support for touch events even if the underlying hardware
    // does not!
    var agent = navigator.userAgent.toLowerCase(),
        isChromeDesktop = ( agent.indexOf( 'chrome' ) > -1 && ( ( agent.indexOf( 'windows' ) > -1 ) || ( agent.indexOf( 'macintosh' ) > -1 ) || ( agent.indexOf( 'linux' ) > -1 ) ) && agent.indexOf( 'mobile' ) < 0 && agent.indexOf( 'android' ) < 0 ),

        settings = {
            tap_pixel_range: 5,
            swipe_h_threshold: 50,
            swipe_v_threshold: 50,
            taphold_threshold: 750,
            doubletap_int: 500,

            touch_capable: ( 'ontouchstart' in window && !isChromeDesktop ),
            orientation_support: ( 'orientation' in window && 'onorientationchange' in window ),

            startevent: ( 'ontouchstart' in window && !isChromeDesktop ) ? 'touchstart' : 'mousedown',
            endevent: ( 'ontouchstart' in window && !isChromeDesktop ) ? 'touchend' : 'mouseup',
            moveevent: ( 'ontouchstart' in window && !isChromeDesktop ) ? 'touchmove' : 'mousemove',
            tapevent: ( 'ontouchstart' in window && !isChromeDesktop ) ? 'tap' : 'click',
            scrollevent: ( 'ontouchstart' in window && !isChromeDesktop ) ? 'touchmove' : 'scroll',

            hold_timer: null,
            tap_timer: null
        };

    // Convenience functions:
    $.isTouchCapable = function () {
        return settings.touch_capable;
    };
    $.getStartEvent = function () {
        return settings.startevent;
    };
    $.getEndEvent = function () {
        return settings.endevent;
    };
    $.getMoveEvent = function () {
        return settings.moveevent;
    };
    $.getTapEvent = function () {
        return settings.tapevent;
    };
    $.getScrollEvent = function () {
        return settings.scrollevent;
    };

    // Add Event shortcuts:
    $.each( [ 'tapstart', 'tapend', 'tapmove', 'tap', 'tap2', 'tap3', 'tap4', 'singletap', 'doubletap', 'taphold', 'swipe', 'swipeup', 'swiperight', 'swipedown', 'swipeleft', 'swipeend', 'scrollstart', 'scrollend', 'orientationchange' ], function ( i, name ) {
        $.fn[ name ] = function ( fn ) {
            return fn ? this.on( name, fn ) : this.trigger( name );
        };

        $.attrFn[ name ] = true;
    } );

    // tapstart Event:
    $.event.special.tapstart = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject );

            $this.on( settings.startevent, function ( e ) {
                $this.data( 'callee', arguments.callee );
                if ( e.which && e.which !== 1 ) {
                    return false;
                }

                var origEvent = e.originalEvent,
                    touchData = {
                        'position': {
                            'x': ( ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX ),
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                        },
                        'offset': {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                        },
                        'time': Date.now(),
                        'target': e.target
                    };

                triggerCustomEvent( thisObject, 'tapstart', e, touchData );
                return true;
            } );
        },

        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee );
        }
    };

    // tapmove Event:
    $.event.special.tapmove = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject );

            $this.on( settings.moveevent, function ( e ) {
                $this.data( 'callee', arguments.callee );

                var origEvent = e.originalEvent,
                    touchData = {
                        'position': {
                            'x': ( ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX ),
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                        },
                        'offset': {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                        },
                        'time': Date.now(),
                        'target': e.target
                    };

                triggerCustomEvent( thisObject, 'tapmove', e, touchData );
                return true;
            } );
        },
        remove: function () {
            $( this ).off( settings.moveevent, $( this ).data.callee );
        }
    }

    // tapend Event:
    $.event.special.tapend = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject );

            $this.on( settings.endevent, function ( e ) {
                // Touch event data:
                $this.data( 'callee', arguments.callee );

                var origEvent = e.originalEvent;
                var touchData = {
                    'position': {
                        'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenX : e.screenX,
                        'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenY : e.screenY
                    },
                    'offset': {
                        'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageX - origEvent.changedTouches[ 0 ].target.offsetLeft : e.offsetX,
                        'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageY - origEvent.changedTouches[ 0 ].target.offsetTop : e.offsetY
                    },
                    'time': Date.now(),
                    'target': e.target
                };
                triggerCustomEvent( thisObject, 'tapend', e, touchData );
                return true;
            } );
        },
        remove: function () {
            $( this ).off( settings.endevent, $( this ).data.callee );
        }
    };

    // taphold Event:
    $.event.special.taphold = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                origTarget,
                timer,
                start_pos = {
                    x: 0,
                    y: 0
                },
                end_x = 0,
                end_y = 0;

            $this.on( settings.startevent, function ( e ) {
                if ( e.which && e.which !== 1 ) {
                    return false;
                }
                else {
                    $this.data( 'tapheld', false );
                    origTarget = e.target;

                    var origEvent = e.originalEvent;
                    var start_time = Date.now(),
                        startPosition = {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                        },
                        startOffset = {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                        };

                    start_pos.x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                    start_pos.y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;

                    end_x = start_pos.x;
                    end_y = start_pos.y;

                    settings.hold_timer = window.setTimeout( function () {

                        var diff_x = ( start_pos.x - end_x ),
                            diff_y = ( start_pos.y - end_y );

                        if ( e.target == origTarget && ( ( start_pos.x == end_x && start_pos.y == end_y ) || ( diff_x >= -( settings.tap_pixel_range ) && diff_x <= settings.tap_pixel_range && diff_y >= -( settings.tap_pixel_range ) && diff_y <= settings.tap_pixel_range ) ) ) {
                            $this.data( 'tapheld', true );

                            var end_time = Date.now(),
                                endPosition = {
                                    'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX,
                                    'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                                },
                                endOffset = {
                                    'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                                    'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                                };
                            duration = end_time - start_time;

                            // Build the touch data:
                            var touchData = {
                                'startTime': start_time,
                                'endTime': end_time,
                                'startPosition': startPosition,
                                'startOffset': startOffset,
                                'endPosition': endPosition,
                                'endOffset': endOffset,
                                'duration': duration,
                                'target': e.target
                            }
                            $this.data( 'callee1', arguments.callee );
                            triggerCustomEvent( thisObject, 'taphold', e, touchData );
                        }
                    }, settings.taphold_threshold );

                    return true;
                }
            } ).on( settings.endevent, function () {
                $this.data( 'callee2', arguments.callee );
                $this.data( 'tapheld', false );
                window.clearTimeout( settings.hold_timer );
            } )
                .on( settings.moveevent, function ( e ) {
                    $this.data( 'callee3', arguments.callee );

                    end_x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                    end_y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;
                } );
        },

        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee1 ).off( settings.endevent, $( this ).data.callee2 ).off( settings.moveevent, $( this ).data.callee3 );
        }
    };

    // doubletap Event:
    $.event.special.doubletap = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                origTarget,
                action,
                firstTap,
                origEvent,
                cooloff,
                cooling = false;

            $this.on( settings.startevent, function ( e ) {
                if ( e.which && e.which !== 1 ) {
                    return false;
                }
                $this.data( 'doubletapped', false );
                origTarget = e.target;
                $this.data( 'callee1', arguments.callee );

                origEvent = e.originalEvent;
                firstTap = {
                    'position': {
                        'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX,
                        'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                    },
                    'offset': {
                        'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                        'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                    },
                    'time': Date.now(),
                    'target': e.target
                };

                return true;
            } ).on( settings.endevent, function ( e ) {

                var now = Date.now();
                var lastTouch = $this.data( 'lastTouch' ) || now + 1;
                var delta = now - lastTouch;
                window.clearTimeout( action );
                $this.data( 'callee2', arguments.callee );

                if ( delta < settings.doubletap_int && ( e.target == origTarget ) && delta > 100 ) {
                    $this.data( 'doubletapped', true );
                    window.clearTimeout( settings.tap_timer );

                    // Now get the current event:
                    var lastTap = {
                        'position': {
                            'x': ( settings.touch_capable ) ? e.originalEvent.changedTouches[ 0 ].screenX : e.screenX,
                            'y': ( settings.touch_capable ) ? e.originalEvent.changedTouches[ 0 ].screenY : e.screenY
                        },
                        'offset': {
                            'x': ( settings.touch_capable ) ? e.originalEvent.changedTouches[ 0 ].pageX - e.originalEvent.changedTouches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? e.originalEvent.changedTouches[ 0 ].pageY - e.originalEvent.changedTouches[ 0 ].target.offsetTop : e.offsetY
                        },
                        'time': Date.now(),
                        'target': e.target
                    }

                    var touchData = {
                        'firstTap': firstTap,
                        'secondTap': lastTap,
                        'interval': lastTap.time - firstTap.time
                    };

                    if ( !cooling ) {
                        triggerCustomEvent( thisObject, 'doubletap', e, touchData );
                    }

                    cooling = true;

                    cooloff = window.setTimeout( function ( e ) {
                        cooling = false;
                    }, settings.doubletap_int );

                }
                else {
                    $this.data( 'lastTouch', now );
                    action = window.setTimeout( function ( e ) {
                        window.clearTimeout( action );
                    }, settings.doubletap_int, [ e ] );
                }
                $this.data( 'lastTouch', now );
            } );
        },
        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee1 ).off( settings.endevent, $( this ).data.callee2 );
        }
    };

    // singletap Event:
    // This is used in conjuction with doubletap when both events are needed on the same element
    $.event.special.singletap = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                origTarget = null,
                startTime = null,
                start_pos = {
                    x: 0,
                    y: 0
                };

            $this.on( settings.startevent, function ( e ) {
                if ( e.which && e.which !== 1 ) {
                    return false;
                }
                else {
                    startTime = Date.now();
                    origTarget = e.target;
                    $this.data( 'callee1', arguments.callee );

                    // Get the start x and y position:
                    start_pos.x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                    start_pos.y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;
                    return true;
                }
            } ).on( settings.endevent, function ( e ) {
                $this.data( 'callee2', arguments.callee );
                if ( e.target == origTarget ) {
                    // Get the end point:
                    end_pos_x = ( e.originalEvent.changedTouches ) ? e.originalEvent.changedTouches[ 0 ].pageX : e.pageX;
                    end_pos_y = ( e.originalEvent.changedTouches ) ? e.originalEvent.changedTouches[ 0 ].pageY : e.pageY;

                    // We need to check if it was a taphold:

                    settings.tap_timer = window.setTimeout( function () {
                        if ( !$this.data( 'doubletapped' ) && !$this.data( 'tapheld' ) && ( start_pos.x == end_pos_x ) && ( start_pos.y == end_pos_y ) ) {
                            var origEvent = e.originalEvent;
                            var touchData = {
                                'position': {
                                    'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenX : e.screenX,
                                    'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenY : e.screenY
                                },
                                'offset': {
                                    'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageX - origEvent.changedTouches[ 0 ].target.offsetLeft : e.offsetX,
                                    'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageY - origEvent.changedTouches[ 0 ].target.offsetTop : e.offsetY
                                },
                                'time': Date.now(),
                                'target': e.target
                            };

                            // Was it a taphold?
                            if ( ( touchData.time - startTime ) < settings.taphold_threshold ) {
                                triggerCustomEvent( thisObject, 'singletap', e, touchData );
                            }
                        }
                    }, settings.doubletap_int );
                }
            } );
        },

        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee1 ).off( settings.endevent, $( this ).data.callee2 );
        }
    };

    // tap Event:
    $.event.special.tap = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                started = false,
                origTarget = null,
                start_time,
                start_pos = {
                    x: 0,
                    y: 0
                },
                touches;

            $this.on( settings.startevent, function ( e ) {
                $this.data( 'callee1', arguments.callee );

                if ( e.which && e.which !== 1 ) {
                    return false;
                }
                else {
                    started = true;
                    start_pos.x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                    start_pos.y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;
                    start_time = Date.now();
                    origTarget = e.target;

                    touches = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches : [ e ];
                    return true;
                }
            } ).on( settings.endevent, function ( e ) {
                $this.data( 'callee2', arguments.callee );

                // Only trigger if they've started, and the target matches:
                var end_x = ( e.originalEvent.targetTouches ) ? e.originalEvent.changedTouches[ 0 ].pageX : e.pageX,
                    end_y = ( e.originalEvent.targetTouches ) ? e.originalEvent.changedTouches[ 0 ].pageY : e.pageY,
                    diff_x = ( start_pos.x - end_x ),
                    diff_y = ( start_pos.y - end_y ),
                    eventName;

                if ( origTarget == e.target && started && ( ( Date.now() - start_time ) < settings.taphold_threshold ) && ( ( start_pos.x == end_x && start_pos.y == end_y ) || ( diff_x >= -( settings.tap_pixel_range ) && diff_x <= settings.tap_pixel_range && diff_y >= -( settings.tap_pixel_range ) && diff_y <= settings.tap_pixel_range ) ) ) {
                    var origEvent = e.originalEvent;
                    var touchData = [];

                    for ( var i = 0; i < touches.length; i++ ) {
                        var touch = {
                            'position': {
                                'x': ( settings.touch_capable ) ? origEvent.changedTouches[ i ].screenX : e.screenX,
                                'y': ( settings.touch_capable ) ? origEvent.changedTouches[ i ].screenY : e.screenY
                            },
                            'offset': {
                                'x': ( settings.touch_capable ) ? origEvent.changedTouches[ i ].pageX - origEvent.changedTouches[ i ].target.offsetLeft : e.offsetX,
                                'y': ( settings.touch_capable ) ? origEvent.changedTouches[ i ].pageY - origEvent.changedTouches[ i ].target.offsetTop : e.offsetY
                            },
                            'time': Date.now(),
                            'target': e.target
                        };

                        touchData.push( touch );
                    }

                    switch ( touches.length ) {
                    case 1:
                        eventName = 'tap';
                        break;

                    case 2:
                        eventName = 'tap2';
                        break;

                    case 3:
                        eventName = 'tap3';
                        break;

                    case 4:
                        eventName = 'tap4';
                        break;
                    }

                    triggerCustomEvent( thisObject, eventName, e, touchData );
                }
            } );
        },

        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee1 ).off( settings.endevent, $( this ).data.callee2 );
        }
    };

    // swipe Event (also handles swipeup, swiperight, swipedown and swipeleft):
    $.event.special.swipe = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                started = false,
                hasSwiped = false,
                originalCoord = {
                    x: 0,
                    y: 0
                },
                finalCoord = {
                    x: 0,
                    y: 0
                },
                startEvnt;

            // Screen touched, store the original coordinate

            function touchStart( e ) {
                $this = $( e.target );
                $this.data( 'callee1', arguments.callee );
                originalCoord.x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                originalCoord.y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;
                finalCoord.x = originalCoord.x;
                finalCoord.y = originalCoord.y;
                started = true;
                var origEvent = e.originalEvent;
                // Read event data into our startEvt:
                startEvnt = {
                    'position': {
                        'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX,
                        'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                    },
                    'offset': {
                        'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                        'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                    },
                    'time': Date.now(),
                    'target': e.target
                };
            }

            // Store coordinates as finger is swiping

            function touchMove( e ) {
                $this = $( e.target );
                $this.data( 'callee2', arguments.callee );
                finalCoord.x = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageX : e.pageX;
                finalCoord.y = ( e.originalEvent.targetTouches ) ? e.originalEvent.targetTouches[ 0 ].pageY : e.pageY;

                var swipedir;

                // We need to check if the element to which the event was bound contains a data-xthreshold | data-vthreshold:
                var ele_x_threshold = $this.data( 'xthreshold' ),
                    ele_y_threshold = $this.data( 'ythreshold' ),
                    h_threshold = ( typeof ele_x_threshold !== 'undefined' && ele_x_threshold !== false && parseInt( ele_x_threshold ) ) ? parseInt( ele_x_threshold ) : settings.swipe_h_threshold,
                    v_threshold = ( typeof ele_y_threshold !== 'undefined' && ele_y_threshold !== false && parseInt( ele_y_threshold ) ) ? parseInt( ele_y_threshold ) : settings.swipe_v_threshold;

                if ( originalCoord.y > finalCoord.y && ( originalCoord.y - finalCoord.y > v_threshold ) ) {
                    swipedir = 'swipeup';
                }
                if ( originalCoord.x < finalCoord.x && ( finalCoord.x - originalCoord.x > h_threshold ) ) {
                    swipedir = 'swiperight';
                }
                if ( originalCoord.y < finalCoord.y && ( finalCoord.y - originalCoord.y > v_threshold ) ) {
                    swipedir = 'swipedown';
                }
                if ( originalCoord.x > finalCoord.x && ( originalCoord.x - finalCoord.x > h_threshold ) ) {
                    swipedir = 'swipeleft';
                }
                if ( swipedir != undefined && started ) {
                    originalCoord.x = 0;
                    originalCoord.y = 0;
                    finalCoord.x = 0;
                    finalCoord.y = 0;
                    started = false;

                    // Read event data into our endEvnt:
                    var origEvent = e.originalEvent;
                    endEvnt = {
                        'position': {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenX : e.screenX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].screenY : e.screenY
                        },
                        'offset': {
                            'x': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageX - origEvent.touches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? origEvent.touches[ 0 ].pageY - origEvent.touches[ 0 ].target.offsetTop : e.offsetY
                        },
                        'time': Date.now(),
                        'target': e.target
                    };

                    // Calculate the swipe amount (normalized):
                    var xAmount = Math.abs( startEvnt.position.x - endEvnt.position.x ),
                        yAmount = Math.abs( startEvnt.position.y - endEvnt.position.y );

                    var touchData = {
                        'startEvnt': startEvnt,
                        'endEvnt': endEvnt,
                        'direction': swipedir.replace( 'swipe', '' ),
                        'xAmount': xAmount,
                        'yAmount': yAmount,
                        'duration': endEvnt.time - startEvnt.time
                    }
                    hasSwiped = true;
                    $this.trigger( 'swipe', touchData ).trigger( swipedir, touchData );
                }
            }

            function touchEnd( e ) {
                $this = $( e.target );
                var swipedir = "";
                $this.data( 'callee3', arguments.callee );
                if ( hasSwiped ) {
                    // We need to check if the element to which the event was bound contains a data-xthreshold | data-vthreshold:
                    var ele_x_threshold = $this.data( 'xthreshold' ),
                        ele_y_threshold = $this.data( 'ythreshold' ),
                        h_threshold = ( typeof ele_x_threshold !== 'undefined' && ele_x_threshold !== false && parseInt( ele_x_threshold ) ) ? parseInt( ele_x_threshold ) : settings.swipe_h_threshold,
                        v_threshold = ( typeof ele_y_threshold !== 'undefined' && ele_y_threshold !== false && parseInt( ele_y_threshold ) ) ? parseInt( ele_y_threshold ) : settings.swipe_v_threshold;

                    var origEvent = e.originalEvent;
                    endEvnt = {
                        'position': {
                            'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenX : e.screenX,
                            'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].screenY : e.screenY
                        },
                        'offset': {
                            'x': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageX - origEvent.changedTouches[ 0 ].target.offsetLeft : e.offsetX,
                            'y': ( settings.touch_capable ) ? origEvent.changedTouches[ 0 ].pageY - origEvent.changedTouches[ 0 ].target.offsetTop : e.offsetY
                        },
                        'time': Date.now(),
                        'target': e.target
                    };

                    // Read event data into our endEvnt:
                    if ( startEvnt.position.y > endEvnt.position.y && ( startEvnt.position.y - endEvnt.position.y > v_threshold ) ) {
                        swipedir = 'swipeup';
                    }
                    if ( startEvnt.position.x < endEvnt.position.x && ( endEvnt.position.x - startEvnt.position.x > h_threshold ) ) {
                        swipedir = 'swiperight';
                    }
                    if ( startEvnt.position.y < endEvnt.position.y && ( endEvnt.position.y - startEvnt.position.y > v_threshold ) ) {
                        swipedir = 'swipedown';
                    }
                    if ( startEvnt.position.x > endEvnt.position.x && ( startEvnt.position.x - endEvnt.position.x > h_threshold ) ) {
                        swipedir = 'swipeleft';
                    }

                    // Calculate the swipe amount (normalized):
                    var xAmount = Math.abs( startEvnt.position.x - endEvnt.position.x ),
                        yAmount = Math.abs( startEvnt.position.y - endEvnt.position.y );

                    var touchData = {
                        'startEvnt': startEvnt,
                        'endEvnt': endEvnt,
                        'direction': swipedir.replace( 'swipe', '' ),
                        'xAmount': xAmount,
                        'yAmount': yAmount,
                        'duration': endEvnt.time - startEvnt.time
                    }
                    $this.trigger( 'swipeend', touchData );
                }

                started = false;
                hasSwiped = false;
            }

            $this.on( settings.startevent, touchStart );
            $this.on( settings.moveevent, touchMove );
            $this.on( settings.endevent, touchEnd );
        },

        remove: function () {
            $( this ).off( settings.startevent, $( this ).data.callee1 ).off( settings.moveevent, $( this ).data.callee2 ).off( settings.endevent, $( this ).data.callee3 );
        }
    };

    // scrollstart Event (also handles scrollend):
    $.event.special.scrollstart = {
        setup: function () {
            var thisObject = this,
                $this = $( thisObject ),
                scrolling,
                timer;

            function trigger( event, state ) {
                scrolling = state;
                triggerCustomEvent( thisObject, scrolling ? 'scrollstart' : 'scrollend', event );
            }

            // iPhone triggers scroll after a small delay; use touchmove instead
            $this.on( settings.scrollevent, function ( event ) {
                $this.data( 'callee', arguments.callee );

                if ( !scrolling ) {
                    trigger( event, true );
                }

                clearTimeout( timer );
                timer = setTimeout( function () {
                    trigger( event, false );
                }, 50 );
            } );
        },

        remove: function () {
            $( this ).off( settings.scrollevent, $( this ).data.callee );
        }
    };

    // This is the orientation change (largely borrowed from jQuery Mobile):
    var win = $( window ),
        special_event,
        get_orientation,
        last_orientation,
        initial_orientation_is_landscape,
        initial_orientation_is_default,
        portrait_map = {
            '0': true,
            '180': true
        };

    if ( settings.orientation_support ) {
        var ww = window.innerWidth || win.width(),
            wh = window.innerHeight || win.height(),
            landscape_threshold = 50;

        initial_orientation_is_landscape = ww > wh && ( ww - wh ) > landscape_threshold;
        initial_orientation_is_default = portrait_map[ window.orientation ];

        if ( ( initial_orientation_is_landscape && initial_orientation_is_default ) || ( !initial_orientation_is_landscape && !initial_orientation_is_default ) ) {
            portrait_map = {
                '-90': true,
                '90': true
            };
        }
    }

    $.event.special.orientationchange = special_event = {
        setup: function () {
            // If the event is supported natively, return false so that jQuery
            // will on to the event using DOM methods.
            if ( settings.orientation_support ) {
                return false;
            }

            // Get the current orientation to avoid initial double-triggering.
            last_orientation = get_orientation();

            win.on( 'throttledresize', handler );
            return true;
        },
        teardown: function () {
            if ( settings.orientation_support ) {
                return false;
            }

            win.off( 'throttledresize', handler );
            return true;
        },
        add: function ( handleObj ) {
            // Save a reference to the bound event handler.
            var old_handler = handleObj.handler;

            handleObj.handler = function ( event ) {
                event.orientation = get_orientation();
                return old_handler.apply( this, arguments );
            };
        }
    };

    // If the event is not supported natively, this handler will be bound to
    // the window resize event to simulate the orientationchange event.

    function handler() {
        // Get the current orientation.
        var orientation = get_orientation();

        if ( orientation !== last_orientation ) {
            // The orientation has changed, so trigger the orientationchange event.
            last_orientation = orientation;
            win.trigger( "orientationchange" );
        }
    }

    $.event.special.orientationchange.orientation = get_orientation = function () {
        var isPortrait = true,
            elem = document.documentElement;

        if ( settings.orientation_support ) {
            isPortrait = portrait_map[ window.orientation ];
        }
        else {
            isPortrait = elem && elem.clientWidth / elem.clientHeight < 1.1;
        }

        return isPortrait ? 'portrait' : 'landscape';
    };

    // throttle Handler:
    $.event.special.throttledresize = {
        setup: function () {
            $( this ).on( 'resize', throttle_handler );
        },
        teardown: function () {
            $( this ).off( 'resize', throttle_handler );
        }
    };

    var throttle = 250,
        throttle_handler = function () {
            curr = Date.now();
            diff = curr - lastCall;

            if ( diff >= throttle ) {
                lastCall = curr;
                $( this ).trigger( 'throttledresize' );

            }
            else {
                if ( heldCall ) {
                    window.clearTimeout( heldCall );
                }

                // Promise a held call will still execute
                heldCall = window.setTimeout( handler, throttle - diff );
            }
        },
        lastCall = 0,
        heldCall,
        curr,
        diff;

    // Trigger a custom event:

    function triggerCustomEvent( obj, eventType, event, touchData ) {
        var originalType = event.type;
        event.type = eventType;

        $.event.dispatch.call( obj, event, touchData );
        event.type = originalType;
    }

    // Correctly on anything we've overloaded:
    $.each( {
        scrollend: 'scrollstart',
        swipeup: 'swipe',
        swiperight: 'swipe',
        swipedown: 'swipe',
        swipeleft: 'swipe',
        swipeend: 'swipe',
        tap2: 'tap'
    }, function ( e, srcE, touchData ) {
        $.event.special[ e ] = {
            setup: function () {
                $( this ).on( srcE, $.noop );
            }
        };
    } );

} )( jQuery );



/*!
 * jQuery Mousewheel 3.1.12
 *
 * Copyright 2014 jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 */

( function ( factory ) {
    if ( typeof define === 'function' && define.amd ) {
        // AMD. Register as an anonymous module.
        define( [ 'jquery' ], factory );
    }
    else if ( typeof exports === 'object' ) {
        // Node/CommonJS style for Browserify
        module.exports = factory;
    }
    else {
        // Browser globals
        factory( jQuery );
    }
}( function ( $ ) {

    var toFix = [ 'wheel', 'mousewheel', 'DOMMouseScroll', 'MozMousePixelScroll' ],
        toBind = ( 'onwheel' in document || document.documentMode >= 9 ) ?
            [ 'wheel' ] : [ 'mousewheel', 'DomMouseScroll', 'MozMousePixelScroll' ],
        slice = Array.prototype.slice,
        nullLowestDeltaTimeout, lowestDelta;

    if ( $.event.fixHooks ) {
        for ( var i = toFix.length; i; ) {
            $.event.fixHooks[ toFix[ --i ] ] = $.event.mouseHooks;
        }
    }

    var special = $.event.special.mousewheel = {
        version: '3.1.12',

        setup: function () {
            if ( this.addEventListener ) {
                for ( var i = toBind.length; i; ) {
                    this.addEventListener( toBind[ --i ], handler, false );
                }
            }
            else {
                this.onmousewheel = handler;
            }
            // Store the line height and page height for this particular element
            $.data( this, 'mousewheel-line-height', special.getLineHeight( this ) );
            $.data( this, 'mousewheel-page-height', special.getPageHeight( this ) );
        },

        teardown: function () {
            if ( this.removeEventListener ) {
                for ( var i = toBind.length; i; ) {
                    this.removeEventListener( toBind[ --i ], handler, false );
                }
            }
            else {
                this.onmousewheel = null;
            }
            // Clean up the data we added to the element
            $.removeData( this, 'mousewheel-line-height' );
            $.removeData( this, 'mousewheel-page-height' );
        },

        getLineHeight: function ( elem ) {
            var $elem = $( elem ),
                $parent = $elem[ 'offsetParent' in $.fn ? 'offsetParent' : 'parent' ]();
            if ( !$parent.length ) {
                $parent = $( 'body' );
            }
            return parseInt( $parent.css( 'fontSize' ), 10 ) || parseInt( $elem.css( 'fontSize' ), 10 ) || 16;
        },

        getPageHeight: function ( elem ) {
            return $( elem ).height();
        },

        settings: {
            adjustOldDeltas: true, // see shouldAdjustOldDeltas() below
            normalizeOffset: true // calls getBoundingClientRect for each event
        }
    };

    $.fn.extend( {
        mousewheel: function ( fn ) {
            return fn ? this.bind( 'mousewheel', fn ) : this.trigger( 'mousewheel' );
        },

        unmousewheel: function ( fn ) {
            return this.unbind( 'mousewheel', fn );
        }
    } );


    function handler( event ) {
        var orgEvent = event || window.event,
            args = slice.call( arguments, 1 ),
            delta = 0,
            deltaX = 0,
            deltaY = 0,
            absDelta = 0,
            offsetX = 0,
            offsetY = 0;
        event = $.event.fix( orgEvent );
        event.type = 'mousewheel';

        // Old school scrollwheel delta
        if ( 'detail' in orgEvent ) {
            deltaY = orgEvent.detail * -1;
        }
        if ( 'wheelDelta' in orgEvent ) {
            deltaY = orgEvent.wheelDelta;
        }
        if ( 'wheelDeltaY' in orgEvent ) {
            deltaY = orgEvent.wheelDeltaY;
        }
        if ( 'wheelDeltaX' in orgEvent ) {
            deltaX = orgEvent.wheelDeltaX * -1;
        }

        // Firefox < 17 horizontal scrolling related to DOMMouseScroll event
        if ( 'axis' in orgEvent && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
            deltaX = deltaY * -1;
            deltaY = 0;
        }

        // Set delta to be deltaY or deltaX if deltaY is 0 for backwards compatabilitiy
        delta = deltaY === 0 ? deltaX : deltaY;

        // New school wheel delta (wheel event)
        if ( 'deltaY' in orgEvent ) {
            deltaY = orgEvent.deltaY * -1;
            delta = deltaY;
        }
        if ( 'deltaX' in orgEvent ) {
            deltaX = orgEvent.deltaX;
            if ( deltaY === 0 ) {
                delta = deltaX * -1;
            }
        }

        // No change actually happened, no reason to go any further
        if ( deltaY === 0 && deltaX === 0 ) {
            return;
        }

        // Need to convert lines and pages to pixels if we aren't already in pixels
        // There are three delta modes:
        //   * deltaMode 0 is by pixels, nothing to do
        //   * deltaMode 1 is by lines
        //   * deltaMode 2 is by pages
        if ( orgEvent.deltaMode === 1 ) {
            var lineHeight = $.data( this, 'mousewheel-line-height' );
            delta *= lineHeight;
            deltaY *= lineHeight;
            deltaX *= lineHeight;
        }
        else if ( orgEvent.deltaMode === 2 ) {
            var pageHeight = $.data( this, 'mousewheel-page-height' );
            delta *= pageHeight;
            deltaY *= pageHeight;
            deltaX *= pageHeight;
        }

        // Store lowest absolute delta to normalize the delta values
        absDelta = Math.max( Math.abs( deltaY ), Math.abs( deltaX ) );

        if ( !lowestDelta || absDelta < lowestDelta ) {
            lowestDelta = absDelta;

            // Adjust older deltas if necessary
            if ( shouldAdjustOldDeltas( orgEvent, absDelta ) ) {
                lowestDelta /= 40;
            }
        }

        // Adjust older deltas if necessary
        if ( shouldAdjustOldDeltas( orgEvent, absDelta ) ) {
            // Divide all the things by 40!
            delta /= 40;
            deltaX /= 40;
            deltaY /= 40;
        }

        // Get a whole, normalized value for the deltas
        delta = Math[ delta >= 1 ? 'floor' : 'ceil' ]( delta / lowestDelta );
        deltaX = Math[ deltaX >= 1 ? 'floor' : 'ceil' ]( deltaX / lowestDelta );
        deltaY = Math[ deltaY >= 1 ? 'floor' : 'ceil' ]( deltaY / lowestDelta );

        // Normalise offsetX and offsetY properties
        if ( special.settings.normalizeOffset && this.getBoundingClientRect ) {
            var boundingRect = this.getBoundingClientRect();
            offsetX = event.clientX - boundingRect.left;
            offsetY = event.clientY - boundingRect.top;
        }

        // Add information to the event object
        event.deltaX = deltaX;
        event.deltaY = deltaY;
        event.deltaFactor = lowestDelta;
        event.offsetX = offsetX;
        event.offsetY = offsetY;
        // Go ahead and set deltaMode to 0 since we converted to pixels
        // Although this is a little odd since we overwrite the deltaX/Y
        // properties with normalized deltas.
        event.deltaMode = 0;

        // Add event and delta to the front of the arguments
        args.unshift( event, delta, deltaX, deltaY );

        // Clearout lowestDelta after sometime to better
        // handle multiple device types that give different
        // a different lowestDelta
        // Ex: trackpad = 3 and mouse wheel = 120
        if ( nullLowestDeltaTimeout ) {
            clearTimeout( nullLowestDeltaTimeout );
        }
        nullLowestDeltaTimeout = setTimeout( nullLowestDelta, 200 );

        return ( $.event.dispatch || $.event.handle ).apply( this, args );
    }

    function nullLowestDelta() {
        lowestDelta = null;
    }

    function shouldAdjustOldDeltas( orgEvent, absDelta ) {
        // If this is an older event and the delta is divisable by 120,
        // then we are assuming that the browser is treating this as an
        // older mouse wheel event and that we should divide the deltas
        // by 40 to try and get a more usable deltaFactor.
        // Side note, this actually impacts the reported scroll distance
        // in older browsers and can cause scrolling to be slower than native.
        // Turn this off by setting $.event.special.mousewheel.settings.adjustOldDeltas to false.
        return special.settings.adjustOldDeltas && orgEvent.type === 'mousewheel' && absDelta % 120 === 0;
    }

} ) );



/***
 *** to keep console logs from crashing old browsers
 ***/
if ( typeof console == "undefined" ) {
    window.console = {
        log: function () {}
    };
}


/***
 *** samsung code
 ***/
jQuery( document ).ready( function ( $ ) {

    var isTouch = ( ( 'ontouchstart' in window ) || ( navigator.msMaxTouchPoints > 0 ) );
    if ( isTouch == false ) {
        $( '#play' ).hide();
        $( '#mute' ).show();
    }
    else {
        $( '#play' ).show();
        $( '#mute' ).hide();
    }

    // Video
    var video = $( '#promovid' )[ 0 ];
    var muteButton = $( '#mute' );

    $( '#mute' ).click( function () {
        if ( video.muted == false ) {
            video.muted = true;
            $( this ).removeClass( 'on' );
        }
        else {
            video.muted = false;
            $( this ).addClass( 'on' );
        }
    } );

    var playButton = $( '#play-pause' );
    $( '#play' ).click( function () {
        if ( video.paused == true ) {
            video.play();
            video.muted = false;
            $( '#pause' ).show();
            $( this ).hide();
        }
        else {
            video.pause();
        }
    } );
    $( '#pause' ).click( function () {
        if ( video.paused == false ) {
            video.pause();
            $( this ).hide();
            $( '#play' ).show();
        }
        else {
            video.play();
        }
    } );


    //slideshow
    $( '#slide0' ).css( 'opacity', '0' );

    function slideShow() {
        if ( $( '#slideshow li:eq(5) img' ).hasClass( 'diagonal' ) ) {
            $( '.diagonal' ).css( 'z-index', '1' );
            $( '#diagradient' ).css( 'z-index', '0' );
        }
        $( '#slideshow li:eq(5)' ).animate( {
            left: '0',
            top: '0'

        }, 1500, function () {
            // Animation complete.
            $( '#slideshow li:eq(0)' ).appendTo( '#slideshow ul' );

            var top = $( '#slideshow li:eq(1)' ).attr( 'data-top' );
            var left = $( '#slideshow li:eq(1)' ).attr( 'data-left' );
            $( '#slideshow li:eq(1)' ).css( 'top', top );
            $( '#slideshow li:eq(1)' ).css( 'left', left );
            $( '.diagonal' ).css( 'z-index', 'auto' );
            $( '#diagradient' ).css( 'z-index', '-1' );
        } );
    }
    slideShow();
    setInterval( slideShow, 4000 );

    //viewport shenanigans
    var viewportHeight = $( window ).height();
    var samsungWidth = $( '#samsung-promo' ).width();
    var winWidth = $( window ).width();
    $( '#samsung360' ).css( 'height', viewportHeight - 60 );
    $( '#samsung360' ).css( 'width', 'auto' );
    $( '#samsung360' ).load( function () {
        var phone_width = $( '#samsung360' ).width();
        if ( phone_width > samsungWidth ) {
            $( '#samsung360' ).css( 'width', samsungWidth );
            $( '#samsung360' ).css( 'height', 'auto' );
        }
    } );
    if ( winWidth < 600 ) {
        $( 'dl' ).addClass( 'accordion' ).removeClass( 'modal' );
    }
    else {
        $( 'dl' ).addClass( 'modal' ).removeClass( 'accordion' );
    }
    $( window ).resize( function () {
        viewportHeight = $( window ).height();
        samsungWidth = $( '#samsung-promo' ).width();
        winWidth = $( window ).width();
        $( '#samsung360' ).css( 'height', viewportHeight - 60 );
        $( '#samsung360' ).css( 'width', 'auto' );
        var phone_width = $( '#samsung360' ).width();
        if ( phone_width > samsungWidth ) {
            $( '#samsung360' ).css( 'width', samsungWidth );
            $( '#samsung360' ).css( 'height', 'auto' );
        }
        if ( winWidth < 600 ) {
            $( 'dl' ).addClass( 'accordion' ).removeClass( 'modal' );
        }
        else {
            $( 'dl' ).addClass( 'modal' ).removeClass( 'accordion' );
        }
        setSprite( true );
        $( '.fixed' ).css( 'width', samsungWidth );
        if ( $( '.fixed' ).css( 'position' ) == 'fixed' ) {
            var sleft = $( '#samsung-promo' ).offset().left;
            $( '.fixed' ).css( 'left', sleft )
        }
    } );

    $( window ).scroll( function () {

        var spromo = $( '#samsung-promo' ).offset().top;
        var sleft = $( '#samsung-promo' ).offset().left;
        var wintop = $( window ).scrollTop();
        if ( wintop > spromo ) {
            $( '.fixed' ).css( 'width', samsungWidth ).css( 'position', 'fixed' ).css( 'left', sleft );
        }
        else {
            $( '.fixed' ).css( 'position', 'absolute' ).css( 'left', '0' );
        }
    } );
    var winWidth = $( window ).width();
    if ( ( winWidth < 768 ) && ( isTouch == true ) ) {
        $( '#intro .left' ).removeClass( 'hidden' ).addClass( 'visible' );
        $( '#intro .right' ).removeClass( 'hidden' ).addClass( 'visible' );
        $( '#intro .center' ).removeClass( 'hidden' ).addClass( 'visible' );
        $( '.clip' ).removeClass( 'hidden' ).addClass( 'visible' );
        $( '.fg' ).removeClass( 'hidden' ).addClass( 'visible' );
    }
    else {

        $( '#intro .left' ).viewportChecker( {
            classToAdd: 'visible fadeLeft',
            classToRemove: 'outLeft',
            //offset: viewportHeight*.33
            offset: -80
        } );
        $( '#intro .center' ).viewportChecker( {
            classToAdd: 'visible animated fadeIn',
            //offset: viewportHeight*.33
            offset: 10
        } );
        $( '#intro .right' ).viewportChecker( {
            classToAdd: 'visible fadeRight',
            classToRemove: 'outRight',
            //offset: viewportHeight*.33
            offset: -80
        } );
        // $( '#intro .left' ).viewportChecker( {
        //     classToAdd: 'outLeft',
        //     offset: viewportHeight + 60
        // } );
        // $( '#intro .right' ).viewportChecker( {
        //     classToAdd: 'outRight',
        //     offset: viewportHeight + 60
        // } );
        $( '#intro .center' ).viewportChecker( {
            classToAdd: 'fadeOut',
            offset: viewportHeight + 60
        } );
        $( '#intro .upleft' ).viewportChecker( {
            classToAdd: 'visible animated fadeLeft',
            offset: viewportHeight * .1
        } );
        $( '#intro .upright' ).viewportChecker( {
            classToAdd: 'visible animated fadeRight',
            offset: viewportHeight * .1
        } );
        $( '.clip' ).viewportChecker( {
            classToAdd: 'visible animated fadeIn',
            offset: 20
        } );
        $( '.fg' ).viewportChecker( {
            classToAdd: 'visible longanimated fadeIn',
            offset: viewportHeight / 4
        } );

        $( '.fg' ).viewportChecker( {
            offset: viewportHeight * .9,
            callbackFunction: function () {
                $( '.fg' ).addClass( 'noanim' );
            }
        } );

        var lastScrollTop = 0;
        $( window ).scroll( function ( event ) {
            var st = $( this ).scrollTop();
            if ( st > lastScrollTop ) {
                // downscroll code
                $( '#intro .left' ).removeClass( 'upleft' );
                $( '#intro .right' ).removeClass( 'upright' );
                $( '.fg' ).removeClass( 'upfade' )
            }
            else {
                // upscroll code
                $( '#intro .left' ).addClass( 'upleft' );
                $( '#intro .right' ).addClass( 'upright' );
                $( '.fg' ).addClass( 'upfade' );
            }
            lastScrollTop = st;
        } );

    }
    $( '#threesixty .s360sidebar li' ).click( function () {
        var modal_height = $( '#samsung360' ).height();
        if ( isTouch == false ) {
            $( '.modal' ).css( 'height', modal_height + 40 ).fadeIn();
        }
        else {
            $( '.modal' ).css( 'height', modal_height + 40 ).show();
        }
        var openTarget = $( this ).attr( 'data-modal' );
        $( '.active' ).removeClass( 'active' );
        $( '.visible' ).removeClass( 'visible' ).hide();
        $( '.modal dt[data-target="' + openTarget + '"]' ).addClass( 'active' );
        var dtActive = $( '.active' );
        var bg_target = $( '.active' ).attr( 'data-target' );
        if ( isTouch == false ) {
            $( '.modal-bg' ).attr( 'data-image', bg_target ).show().addClass( 'quickanimated' );
            if ( bg_target == 'beauty' ) {
                $( '.modal-bg' ).addClass( 'zoomRight' );
            }
            else if ( bg_target == 'picture' ) {
                $( '.modal-bg' ).addClass( 'zoomRight' );
            }
            else if ( bg_target == 'multitask' ) {
                $( '.modal-bg' ).addClass( 'zoomLeft' );
            }
            else {
                $( '.modal-bg' ).addClass( 'zoomUp' );

            }
            $( dtActive ).next( 'dd' ).toggleClass( 'visible' ).slideToggle( 350 );
            $( '.s360sidebar' ).addClass( 'blur' );
            $( '#s360container' ).addClass( 'blur' );
        }
        else {
            $( '.modal-bg' ).attr( 'data-image', bg_target ).show();
            $( dtActive ).next( 'dd' ).toggleClass( 'visible' ).show();
        }



        var tgt_top = $( '#border' ).offset().top;
        if ( $( '#intro .left' ).hasClass( 'outLeft' ) ) {
            var panel_offset = $( '#intro .left' ).height();
        } else {
            panel_offset = 0;
        }
        $( 'html, body' ).animate( {
                scrollTop: tgt_top - panel_offset +100
            }, 300 );

        $( '#intro .left' ).show();
        $( '#intro .center' ).show();
        $( '#intro .right' ).show();

    } );
    $( '.close' ).click( function () {
        if ( isTouch == false ) {
            $( '.modal' ).fadeOut();
            $( '.modal-bg' ).removeClass( 'quickanimated zoomLeft zoomRight zoomUp' );
            $( '.s360sidebar' ).removeClass( 'blur' );
            $( '#s360container' ).removeClass( 'blur' );
        }
        else {
            $( '.modal' ).hide();
        }
    } );

    $( 'dt' ).click( function () {

        if ( $( this ).parent().hasClass( 'accordion' ) ) {
            if ( !$( this ).hasClass( 'active' ) ) {
                $( 'dt' ).not( this ).removeClass( 'active' );
                if ( ( winWidth < 768 ) && ( isTouch == true ) ) {
                    $( 'dd:visible' ).removeClass( 'visible' ).hide();
                }
                else {
                    $( 'dd:visible' ).removeClass( 'visible' ).slideUp( 'fast' );
                }
            }
            $( this ).toggleClass( 'active' );
            if ( ( winWidth < 768 ) && ( isTouch == true ) ) {
                $( this ).next( 'dd' ).toggleClass( 'visible' ).toggle();
            }
            else {
                $( this ).next( 'dd' ).toggleClass( 'visible' ).slideToggle( 'fast' );
            }
            setTimeout(
                function () {
                    if ( $( '.active' ).length ) {
                        var target_offset = $( '.active' ).offset();
                        var target_top = target_offset.top;
                        $( 'html, body' ).animate( {
                            scrollTop: target_top - 60
                        }, 100 );
                    }
                }, 200 );
        }
        else {

            if ( !$( this ).hasClass( 'active' ) ) {
                $( 'dt' ).not( this ).removeClass( 'active' );
                $( 'dd:visible' ).removeClass( 'visible' ).fadeOut( 90 );
            }
            $( this ).toggleClass( 'active' );
            $( '.modal-bg' ).attr( 'data-image', '' ).removeClass( 'quickanimated zoomLeft zoomRight zoomUp' );

            var offset_left = $( this ).offset();
            var left = offset_left.left;
            var rt = ( $( '.modal' ).width() - ( offset_left.left + $( this ).children( '.icon' ).width() ) );
            if ( isTouch == false ) {
                $( this ).next( 'dd' ).toggleClass( 'visible' ).slideToggle( 350 );
            }
            else {
                $( this ).next( 'dd' ).toggleClass( 'visible' ).show();
            }

            var bg_target = $( '.active' ).attr( 'data-target' );
            if ( isTouch == false ) {
                //     $( '.modal-bg' ).attr( 'data-image', bg_target ).fadeIn();
                $( '.modal-bg' ).attr( 'data-image', bg_target ).show().addClass( 'quickanimated' );
                if ( bg_target == 'beauty' ) {
                    $( '.modal-bg' ).addClass( 'zoomRight' );
                }
                else if ( bg_target == 'picture' ) {
                    $( '.modal-bg' ).addClass( 'zoomRight' );
                }
                else if ( bg_target == 'multitask' ) {
                    $( '.modal-bg' ).addClass( 'zoomLeft' );
                }
                else {
                    $( '.modal-bg' ).addClass( 'zoomUp' );

                }
            }
            else {
                $( '.modal-bg' ).attr( 'data-image', bg_target ).show();
            }

        }
    } );



    // 360 values
    //------------
    s360 = {
        'timer': null,
        'drag': {
            'x': 0,
            'time': null,
            'speed': 0,
            'speedAtStart': 0
        },
        'freeSpinDuration': null,
        'spriteWidth': null,
        'spriteHeight': null,
        'spriteFile': null,
        'pocket': {
            'width': 300,
            'width': 600
        },
        'fps': 100,
        'defaultSprite': 'sic184358_Interactive_Learnmore_GEN_LargeSprite.jpg',
        'sprites': {
            'sic184358_Interactive_Learnmore_GEN_LargeSprite.jpg': {
                'keyframes': {
                    1: 'front',
                    18: 'left',
                    36: 'back',
                    54: 'right',
                    72: 'front'
                },
                'frames': 72,
                'framesPerScroll': 3,
                'width': 340,
                'height': 900
            },
            'sic184358_Interactive_Learnmore_GEN_MedSprite.jpg': {
                'keyframes': {
                    1: 'front',
                    9: 'left',
                    18: 'back',
                    27: 'right',
                    36: 'front'
                },
                'frames': 36,
                'framesPerScroll': 2,
                'width': 255,
                'height': 675
            },
            'sic184358_Interactive_Learnmore_GEN_SmallSprite.jpg': {
                'keyframes': {
                    1: 'front',
                    9: 'left',
                    18: 'back',
                    27: 'right',
                    36: 'front'
                },
                'frames': 36,
                'framesPerScroll': 1,
                'width': 170,
                'height': 450
            }
        }
    }


    // 360 functions
    //---------------

    // simple quadratic ease out function
    function eoquad( time, beginning_value, change, duration ) {
        return -change * ( time /= duration ) * ( time - 2 ) + beginning_value;
    }

    // move to the next keyframe, optionally forcing around the beginning
    function toPrev( forceIt ) {
        move = true;
        for ( frame in s360.keyframes ) {
            if ( $( '#scrubber360' ).val() == frame )
                move = false;
        }
        if ( move || forceIt ) {
            prevFrame = $( '#scrubber360' ).val() * 1 - 1;
            $( '#scrubber360' ).val( prevFrame ).change();
            s360.timer = setTimeout( toPrev, speed() );
        }
    }

    // move to the next keyframe, optionally forcing around the end
    function toNext( forceIt ) {
        move = true;
        for ( frame in s360.sprites[ s360.spriteFile ].keyframes ) {
            if ( $( '#scrubber360' ).val() == frame )
                move = false;
        }
        if ( move || forceIt ) {
            nextFrame = $( '#scrubber360' ).val() * 1 + 1;
            $( '#scrubber360' ).val( nextFrame ).change();
            s360.timer = setTimeout( toNext, speed() );
        }
    }

    // go to the final frame
    function toEnd() {
        if ( $( '#scrubber360' ).val() != $( '#scrubber360' ).attr( 'max' ) ) {
            $( '#scrubber360' ).val( $( '#scrubber360' ).val() * 1 + 1 ).change();
            s360.timer = setTimeout( toEnd, speed() );
        }
    }

    // go to the first frame
    function toStart() {
        if ( $( '#scrubber360' ).val() != $( '#scrubber360' ).attr( 'min' ) ) {
            $( '#scrubber360' ).val( $( '#scrubber360' ).val() - 1 ).change();
            s360.timer = setTimeout( toStart, speed() );
        }
    }


    // go immediately to a specific number of steps away
    function jumpStep( steps ) {

        stepFrom = $( '#scrubber360' ).val() * 1;
        newStep = stepFrom + steps * 1;
        while ( newStep < $( '#scrubber360' ).attr( 'min' ) ) {
            newStep = newStep + $( '#scrubber360' ).attr( 'max' ) * 1;
        }
        while ( newStep > $( '#scrubber360' ).attr( 'max' ) ) {
            newStep = newStep - $( '#scrubber360' ).attr( 'max' ) * 1;
        }
        $( '#scrubber360' ).val( newStep ).change();
    }

    // return milliseconds based on the preferred frames per second
    function speed() {
        return Math.floor( 1000 / s360.fps );
    }

    // handle free spinning
    function freeSpin( currentStep ) {
        currentStep = currentStep + 1;
        if ( s360.drag.speed && s360.drag.speed != 0 && currentStep < s360.freeSpinDuration ) {
            if ( s360.drag.speed > 0 ) {
                steps = s360.drag.speed / speed();
                jumpStep( steps );
                origDrag = s360.drag.speed;
                s360.drag.speed = Math.floor( eoquad( currentStep, s360.drag.speedAtStart, s360.drag.speedAtStart * -1, s360.freeSpinDuration ) );
            }
            else if ( s360.drag.speed < 0 ) {
                steps = s360.drag.speed / speed();
                jumpStep( steps );
                origDrag = s360.drag.speed;
                s360.drag.speed = Math.ceil( eoquad( currentStep, s360.drag.speedAtStart, s360.drag.speedAtStart * -1, s360.freeSpinDuration ) );
            }
            clearTimeout( s360.timer );
            s360.timer = setTimeout( function () {
                freeSpin( currentStep )
            }, speed() );
        }
    }

    // spin around a certain number of steps frame-by-frame at the proper animation speed, optionally wrapping around the end
    function spinStep( steps, wraparound ) {
        if ( typeof wraparound == 'undefined' )
            wraparound = true;

        if ( steps > 0 ) {
            nextFrame = $( '#scrubber360' ).val() * 1 + 1;
            steps = steps - 1;
            if ( nextFrame > $( '#scrubber360' ).attr( 'max' ) ) {
                if ( wraparound )
                    $( '#scrubber360' ).val( $( '#scrubber360' ).attr( 'min' ) ).change();
                else {
                    $( '#scrubber360' ).val( $( '#scrubber360' ).attr( 'max' ) ).change();
                    steps = 0;
                }
            }
            else
                $( '#scrubber360' ).val( nextFrame ).change();
        }
        else if ( steps < 0 ) {
            nextFrame = $( '#scrubber360' ).val() * 1 - 1;
            steps = steps + 1;
            if ( nextFrame < $( '#scrubber360' ).attr( 'min' ) ) {
                if ( wraparound )
                    $( '#scrubber360' ).val( $( '#scrubber360' ).attr( 'max' ) ).change();
                else {
                    $( '#scrubber360' ).val( $( '#scrubber360' ).attr( 'min' ) ).change();
                    steps = 0;
                }
            }
            else
                $( '#scrubber360' ).val( nextFrame ).change();
        }

        if ( steps != 0 ) {
            spinStep( steps, wraparound );
        }
    }

    // initialize the sprite and resize it to fit
    function setSprite( initEvents ) {
        if ( document.createElement( "s360detect" ).style.backgroundSize === "" ) {
            $( '#samsung360, #samsung360 *' ).unbind();
            if ( initEvents ) {
                // 360 event listeners
                //---------------------

                // individual frames the result of a hidden html range, which controls the movement
                $( '#scrubber360' ).bind( 'input change', function () {
                    clearTimeout( s360.timer );
                    var currentFrame = $( this ).val();
                    $( '#samsung360' ).css( 'background-position', ( currentFrame - 1 ) * s360.spriteWidth * -1 );
                    $( '#Frame' ).val( currentFrame );
                } );

                // arrow keys left and right: 1 px each way
                $( document ).keydown( function ( e ) {
                    switch ( e.which ) {
                    case 37: // left
                        jumpStep( -1 );
                        break;

                    case 39: // right
                        jumpStep( 1 );
                        break;

                    default:
                        return; // exit this handler for other keys
                    }
                    e.preventDefault(); // prevent the default action (scroll / move caret)
                } );

                // mouse wheel, two frames in the appropriate direction
                $( '#samsung360' ).bind( 'mousewheel', function ( e ) {
                    if ( samsungWidth > 400 ) //  only run it if the browser is wide enough to scroll around it
                    {
                        jumpStep( e.deltaY * -1 * s360.sprites[ s360.spriteFile ].framesPerScroll, false );
                        e.preventDefault();
                    }
                } );

                // don't try to use new code on older versions of jQuery
                // result: pre jQuery 1.7 won't have drag events
                if ( typeof jQuery.fn.on == 'undefined' ) {
                    // single-tap: next keyframe
                    $( '#samsung360' ).click( function ( e ) {
                        e.preventDefault();
                        e.stopPropagation();
                        if ( $( '#scrubber360' ).val() == $( '#scrubber360' ).attr( 'max' ) )
                            $( '#scrubber360' ).val( 1 );
                        toNext( true );
                        $( '#samsung360' ).unbind( "tapmove" );
                    } );

                }

                else {

                    // single-tap: next keyframe
                    $( '#samsung360' ).on( 'singletap', function ( e ) {
                        e.preventDefault();
                        e.stopPropagation();
                        if ( $( '#scrubber360' ).val() == $( '#scrubber360' ).attr( 'max' ) )
                            $( '#scrubber360' ).val( 1 );
                        toNext( true );
                        $( '#samsung360' ).unbind( "tapmove" );
                    } );

                    // double-tap: full rotation 
                    $( '#samsung360' ).on( 'doubletap', function ( e ) {
                        e.preventDefault();
                        e.stopPropagation();
                        if ( $( '#scrubber360' ).val() == $( '#scrubber360' ).attr( 'max' ) )
                            $( '#scrubber360' ).val( 1 );
                        toEnd();
                        $( '#samsung360' ).unbind( "tapmove" );
                    } );


                    // listen for taps so we can further listen for dragging
                    $( '#samsung360' ).on( 'tapstart', function ( mousedown, touch ) {
                        mousedown.preventDefault();
                        if ( mousedown.offsetX )
                            s360.drag.x = mousedown.offsetX;
                        else if ( typeof touch.offset.x != 'undefined' )
                            s360.drag.x = touch.offset.x;
                        else
                            s360.drag.x = touch.position.x;
                        increment = 10;
                        s360.drag.time = touch.time;

                        $( '#samsung360' ).bind( 'tapmove', function ( e, move ) {
                            e.preventDefault();
                            // see how far we've moved
                            if ( e.offsetX )
                                newposition = e.offsetX;
                            else if ( typeof move.offset.x != 'undefined' )
                                newposition = move.offset.x;
                            else
                                newposition = move.position.x;
                            diff = ( s360.drag.x - newposition ) * -1;

                            // decide how far we'll move
                            if ( diff < 0 )
                                steps = -1;
                            else if ( diff > 0 )
                                steps = 1;
                            else
                                return true;

                            // move
                            spinStep( steps );

                            duration = move.time - s360.drag.time;
                            s360.drag.speed = Math.round( diff / duration * speed() ); // Gives speed in pixels/frame

                            // put a cap on the speed so it doesn't go crazy if the drag miscounts
                            if ( s360.drag.speed > 0 )
                                s360.drag.speed = Math.min( s360.drag.speed, 300 );
                            else if ( s360.drag.speed < 0 )
                                s360.drag.speed = Math.max( s360.drag.speed, -300 );

                            s360.drag.speedAtStart = s360.drag.speed;
                            s360.drag.x = newposition;
                            s360.drag.time = move.time;
                        } );

                    } );


                    // stop the dragging
                    $( '#samsung360' ).on( 'tapend mouseout', function () {
                        $( '#samsung360' ).unbind( "tapmove" );
                        if ( s360.drag.speed < 0 )
                            s360.freeSpinDuration = Math.floor( s360.drag.speed / speed() * -3 );
                        else
                            s360.freeSpinDuration = Math.floor( s360.drag.speed / speed() * 3 );
                        freeSpin( 0 );
                    } );
                }


                // spin it left when arrow is clicked
                $( '#start360' ).click( function ( e ) {
                    e.stopPropagation();
                    if ( jQuery( '#scrubber360' ).val() == jQuery( '#scrubber360' ).attr( 'min' ) )
                        jQuery( '#scrubber360' ).val( jQuery( '#scrubber360' ).attr( 'max' ) );
                    toStart();
                } );

                // spin it right when arrow is clicked
                $( '#end360' ).click( function ( e ) {
                    e.stopPropagation();
                    if ( jQuery( '#scrubber360' ).val() == jQuery( '#scrubber360' ).attr( 'max' ) )
                        jQuery( '#scrubber360' ).val( 1 );
                    toEnd();
                } );

                // spin it the first time it comes into view
                $( '#start360' ).viewportChecker( {
                    callbackFunction: toEnd
                } );


            } // if (initEvents)


            // clear the image so we don't have junk filling the screen during resizes
            $( '#samsung360' ).css( {
                'background-image': 'none'
            } );

            // determine the size of the pocket we're working with, with min and max
            if ( $( '#threesixty dl' ).hasClass( 'modal' ) ) {
                if ( $( '#s360left' ).css( 'float' ) == 'left' ) { // middle / tablet
                    s360.pocket.height = 600;
                    s360.pocket.width = Math.min( Math.max( $( '#threesixty' ).width() * .7, 170 ), 235 );
                }
                else { // desktop
                    s360.pocket.height = Math.max( $( '#s360left' ).height() * 2, 400 );
                    s360.pocket.width = Math.min( Math.max( $( '#threesixty' ).width() - $( '#s360left' ).width() - $( '#s360right' ).width(), 150 ), 336 );
                }
            }
            else { // mobile
                s360.pocket.height = 400;
                s360.pocket.width = Math.min( Math.max( $( '#threesixty' ).width() * .6, 170 ), 235 );
            }

            // determine which sprite to load
            s360.spriteFile = s360.defaultSprite; // assume the biggest
            for ( i in s360.sprites ) {
                if ( s360.sprites[ i ].width >= s360.pocket.width && s360.sprites[ i ].height >= s360.pocket.height ) {
                    s360.spriteFile = i;
                }
            }

            // resize sprite to fit the pocket
            s360.spriteWidth = s360.sprites[ s360.spriteFile ].width * 1;
            s360.spriteHeight = s360.sprites[ s360.spriteFile ].height * 1;
            s360.frames = s360.sprites[ s360.spriteFile ].frames * 1;
            if ( s360.spriteWidth > s360.pocket.width || s360.spriteHeight > s360.pocket.height ) {
                newWidth = s360.spriteWidth;
                newHeight = s360.spriteHeight;
                prop = newHeight / newWidth;
                while ( newWidth > s360.pocket.width || newHeight > s360.pocket.height ) {
                    newWidth = newWidth - 1;
                    newHeight = Math.floor( newWidth * prop );
                }
                s360.spriteWidth = newWidth;
                s360.spriteHeight = newHeight;
            }

            $( '#samsung360' ).css( {
                'background-size': ( s360.spriteWidth * s360.frames ) + 'px ' + s360.spriteHeight + 'px'
            } );
            $( '#scrubber360' ).attr( 'max', s360.frames );

            // preload the sprite image, then pop it in when it's done loading
            $( '<img class="sprite_preloader" />' ).attr( 'src', 'images/threesixty/' + s360.spriteFile ).appendTo( '#threesixty' ).css( 'display', 'none' ).one( 'load', function () {
                $( '#samsung360' ).css( {
                    'background-image': 'url(images/threesixty/' + s360.spriteFile + ')',
                    'width': s360.spriteWidth,
                    'height': s360.spriteHeight,
                    'background-position': '0 50%'
                } );
                $( '.sprite_preloader' ).remove();
                $( '#spinButtons' ).width( $( '#samsung360' ).width() * 1.2 ).css( {
                    'background-size': '100%',
                    'top': -.21 * $( '#samsung360' ).height()

                } ).fadeIn( 1000 );
                $( '#samsung360 img' ).hide();
            } );
        }
        else // likely ie8 and such, so no 360
        {
            $( '#s360placeholder' ).css( {
                'max-width': $( '#threesixty' ).width() * .5,
                'max-height': 400,
                'display': 'inline',
                'text-align': 'center'
            } );
            $( '#samsung360' ).css( {
                'width': $( '#s360placeholder' ).width(),
                'max-height': 400
            } );
            $( '#threesixty .modal' ).removeClass( 'modal' ).addClass( 'accordion' );
        }
    }

    // 360 go!
    //---------
    setSprite( true );

} );

var s360;