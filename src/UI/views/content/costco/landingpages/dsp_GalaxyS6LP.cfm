<!--- Costco Samsung Galaxy S6 Landing Page --->

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfoutput>


        <!-- BEGIN Deployable Content -->
        <link rel="stylesheet" href="#assetPaths.common#/styles/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_samsung.css" type="text/css" />
        <!-- ATTN GENERAL USE REMOVE unless container site does not already load jQuery -->
        <!-- <script src="js/jquery.min.js"></script> -->
        <!-- ATTN GENERAL USE END REMOVE -->
        <script src="#assetPaths.common#/scripts/GalaxyS6LP/tlsamsung.js"></script>
        <div id="samsung-promo">
            <header class="fixed">
                <!-- ATTN GENERAL USE CHANGE link to General Use-specific URL-->
                <a class="button" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,476,477/index?utm_source=membershipwireless&utm_medium=landing_page&utm_campaign=ALL_S6-S6Edge_3-27-15">Pre-Order Now</a>
                <img class="logo" src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_samsung-logo.png" alt="Samsung" />
            </header>
            <div class="panel" id="video">
               
                <video id="promovid" preload="auto" autoplay="true" loop="loop" muted="muted" volume="0" poster="video/poster/BeautifulDance_GEN.jpg">
                    <source class="webm" src="#assetPaths.common#/images/GalaxyS6LP/video/webm/BeautifulDance_GEN.webm" type="video/webm">
                    <source class="ogg" src="#assetPaths.common#/images/GalaxyS6LP/video/ogv/BeautifulDance_GEN.ogv" type="video/ogg">
                    <source class="mpfour" src="#assetPaths.common#/images/GalaxyS6LP/video/mp4/BeautifulDance_GEN.mp4" type="video/mp4">
                    <img class="novideo" src="#assetPaths.common#/images/GalaxyS6LP/video/poster/BeautifulDance_GEN.jpg">
                </video>
                
                <div id="video-controls">
                    <div id="mute">Mute</div>
                    <div id="pause"><img src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_pause.png" /></div>
                    <div id="play"><img src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_play.png" /></div>
                </div>
                
            </div>
            <!---<div class="panel white" id="intro">
                <div class="hidden animated left third">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_intro-zero.jpg" />
                </div>
                <div class="hidden center third">
                    <h1><img src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_more-than.png" /></h1>
                    <p>Stunning metal. Sophisticated glass. Our most powerful processor ever in a smartphone. Meet the reimagined Samsung Galaxy S<sup>&reg;</sup> 6 edge and Samsung Galaxy S<sup>&reg;</sup> 6.</p>
                    <!-- ATTN GENERAL USE CHANGE link to General Use-specific URL-->
                    <a class="button" href="##">Pre-Order Now</a>
                </div>
                <div class="hidden animated right third">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_intro-zero-f.jpg" />
                </div>
            </div>--->
            <div class="panel" id="border">
                <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_border-bottom.png" />
            </div>
            <!---<div class="panel" id="threesixty">
                <div id='s360container'>
                    <div id="s360right" class="s360sidebar">
                        <ul>
                            <li data-modal="beauty">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_beauty.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_beauty.png" />
                            </li>
                            <li data-modal="screen">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_screen.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_screen.png" />
                            </li>
                            <li data-modal="three">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_three.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_three.png" />
                            </li>
                        </ul>
                    </div>
                    <div id="s360left" class="s360sidebar">
                        <ul>
                            <li data-modal="powerful">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_powerful.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_powerful.png" />
                            </li>
                            <li data-modal="picture">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_picture.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_picture.png" />
                            </li>
                            <li data-modal="multitask">
                                <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_multitask.png" />
                                <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_multitask.png" />
                            </li>
                        </ul>
                    </div>
                    <div id="samsung360">
                        <input id="scrubber360" type="range" min="1" max="72" value="0"/>
                        <img src="#assetPaths.common#/images/GalaxyS6LP/threesixty/sic184358_Interactive_Learnmore_GEN_placeholder.jpg" id="s360placeholder"/>
                    </div>
                    <div id="spinButtons">
                        <span id="start360"></span>
                        <span id="end360"></span>
                    </div>
                </div>
                <dl>
                    <div class="modal-bg"></div>
                    <div class="close"></div>
                    <dt data-target="beauty">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_beauty.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_beauty.png" />
                    </dt>
                    <dd class="beauty">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_beauty.png" />
                    <p>The Galaxy S 6 edge’s stunning metal bezel cascades into sophisticated glass to create our slimmest, most lightweight device. The only phone with dual edge screens, it’s our most revolutionary design yet. And when your favorite contacts call or text, our first-ever dual Edge screen lights up in bold, distinctive colors.</p>
                    </dd>
                    <dt data-target="powerful">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_powerful.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_powerful.png" />
                    </dt>
                    <dd class="powerful">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_powerful.png" />
                    <p>Powered by the Samsung Exynos<sup>&reg;</sup> 7420 Octa-core 64-bit processor, the new Galaxy S6 edge gives you the most speed and best performance of any Samsung smartphone. Browse, work, watch and game—faster than ever, all at the same time.</p>
                    </dd>
                    <dt data-target="screen">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_screen.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_screen.png" />
                    </dt>
                    <dd class="screen">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_screen-mod.png" />
                    <p>Our 5.1" Quad HD Super AMOLED<sup>&reg;</sup> display<sup>*</sup> automatically adapts to the content you’re viewing. Our brightest screen yet, it makes documents, images and videos pop—even in sunlight.</p>
                    </dd>
                    <dt data-target="picture">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_picture.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_picture.png" />
                    </dt>
                    <dd class="picture">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_picture-mod.png" />
                    <p>Capture every moment beautifully with the new and enhanced cameras on the Galaxy S 6 edge. The 16MP rear-facing and 5MP front-facing cameras launch faster than ever with a double-tap of the home button. Auto HDR captures clearer shots in any light. And the wide-angle lens on the front camera takes the most epic selfies of any smartphone.</p>
                    </dd>
                    <dt data-target="three">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_three.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_three.png" />
                    </dt>
                    <dd class="three">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_three.png" />
                    <p>Only the Galaxy S 6 edge gives you three ways to keep your phone charging forward. Tap Ultra Power Saving Mode at 10% charge and still get up to 24 hours of talk and text time.<sup>**</sup> Use Fast Charging to power up to 50% in about 30 minutes.<sup>***</sup> Or cut the cord and recharge wirelessly.<sup>&dagger;</sup></p>
                    </dd>
                    <dt data-target="multitask">
                    <img class="icon" src="#assetPaths.common#/images/GalaxyS6LP/icons/sic184358_Interactive_Learnmore_GEN_multitask.png" />
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_multitask.png" />
                    </dt>
                    <dd class="multitask">
                    <img class="hed" src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_multitask.png" />
                    <p>Your Galaxy S 6 edge smartphone works seamlessly with your other Samsung devices. Start a TV show on your Samsung Smart TV®, and with the touch of a button, take it with you by moving it to your Galaxy S 6 edge. Move photos that are on your Galaxy S 6 edge over to your Samsung tablet. Or turn your Galaxy S 6 edge into an unparalleled 360&deg; virtual reality experience with the Samsung Gear VR<sup>&trade;</sup>. Wherever life takes you, now all your devices can stay connected, so you can too.<sup>&dagger;&dagger;</sup></p>
                    </dd>
                </dl>
            </div>--->
            <div class="panel white" id="flat">
                <div class="right">
                    <h1><img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_galaxys6logo.jpg" /></h1>
                    <p>Just as beautiful and powerful as the Galaxy S 6 edge, the Galaxy S 6 is the stunning single-screen addition to this new Samsung Galaxy<sup>&reg;</sup> family. Same dynamic, ultra-responsive camera. Same refined metal and glass design. Same amazingly powerful processor&ndash;all on one brilliantly clear HD display.</p>
                    <!-- ATTN GENERAL USE CHANGE link to General Use-specific URL-->
                    <a class="button" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,476,477/index?utm_source=membershipwireless&utm_medium=landing_page&utm_campaign=ALL_S6-S6Edge_3-27-15">Pre-Order Now</a>
                </div>
                <div class="left">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_zero-f-hero.jpg" />
                </div>
            </div>
            <div class="panel" id="b2b">
                <div class="left">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_b2bphone.jpg" />
                </div>
                 <div class="right">
                    <h1><img src="#assetPaths.common#/images/GalaxyS6LP/hed/sic184358_Interactive_Learnmore_GEN_ready.png"></h1>
                    <p>The Galaxy S 6 edge is all business. Work on a report and email a colleague at the same time, in real time. Build beautiful presentations on our Quad HD Super AMOLED display. And protect all your files from viruses and hackers with built-in, defense-grade security. From an ultra-fast processor and all the apps you need to the highest level of mobile enterprise protection, the Galaxy S 6 edge is built to get things done.</p>
                    <!-- ATTN GENERAL USE CHANGE link to General Use-specific URL-->
                    <a class="button" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,476,477/index?utm_source=membershipwireless&utm_medium=landing_page&utm_campaign=ALL_S6-S6Edge_3-27-15">Pre-Order Now</a>
                </div>
            </div>
            <div class="panel" id="border" style="margin-top: -6px">
                <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_border-bottom.png" />
            </div>
            <!--- ATTN GENERAL USE REMOVE #carrier if not using --->
            <div class="panel white" id="carrier">
                <div class="left">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_carrier-space-phones.jpg" />
                </div>
                <div class="right">
                    <h1>Get an exclusive in warehouse introduction today.</h1>
                    <p>To see and hold this indredible device visit a Wireless kiosk inside your local Costco Warehouse, otherwise Pre-Order it Now.</p>
                    <!-- ATTN GENERAL USE CHANGE link to General Use-specific Preview URL-->
                    <!---<a class="button preview" href="##">Preview In Store</a>--->

                    <!-- ATTN GENERAL USE CHANGE link to General Use-specific URL-->
                    <a class="button" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,476,477/index?utm_source=membershipwireless&utm_medium=landing_page&utm_campaign=ALL_S6-S6Edge_3-27-15">Pre-Order Now</a>

                </div>
            </div>
            <!-- ATTN GENERAL USE END REMOVE if not using -->
            <div class="panel" id="edgescreen">
                <div class="bg">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_screen-anim-bg.jpg" />
                </div>
                <div class="fg">
                    <img src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_screen-anim-fore.jpg" />
                </div>
            </div>
            <div class="panel" id="slideshow">
                <div id="slide0"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-sizer.gif" /></div>
                <ul>
                    <li id="slide1" data-top="0" data-left="-200%"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-beauty.jpg" /></li>
                    <li id="slide2" class="diag" data-top="120%" data-left="-210%">
                        <div id="diagradient"></div><img class="diagonal" src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-picture.jpg" />
                    </li>
                    <li id="slide3" data-top="280%" data-left="0"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-three.jpg" /></li>
                    <li id="slide5" data-top="0" data-left="-200%"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-performance.jpg" /></li>
                    <li id="slide4" data-top="280%" data-left="0"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-screen.jpg" /></li>
                    <li id="slide6" data-top="0" data-left="200%"><img src="#assetPaths.common#/images/GalaxyS6LP/slides/sic184358_Interactive_Learnmore_GEN_slide-multitask.jpg" /></li>
                </ul>
            </div>
            <div class="panel white" id="logos">
                <img class="logo" src="#assetPaths.common#/images/GalaxyS6LP/sic184358_Interactive_Learnmore_GEN_samsung-logo-black.jpg" alt="Samsung" />
            </div>
            <div class="panel" id="legal">
                <div class="disclaimer">
                    <p><br/></p>
                    <p><strong>This device has not been authorized as required by the rules of the Federal Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or leased, until authorization is obtained.</strong></p>
                    <p><sup>*</sup>Display resolution (Quad HD Super AMOLED) is in comparison with previous Galaxy devices launched in the USA.</p>
                    <p><sup>**</sup>Based on laboratory testing. Results may vary. Battery power consumption depends on factors such as network configuration, carrier network, signal strength, operating temperature, features selected, vibrate mode, backlight settings, browser use, frequency of calls, and voice, data and other application-usage patterns.</p>
                    <p><sup>***</sup>Fast Charging requires an AFC-compatible charger to work. </p>
                    <p><sup>&dagger;</sup>Samsung Wireless Charging compatible back included with device. Wireless charging pad sold separately.</p>
                    <p><sup>&dagger;&dagger;</sup>Quick Connect, Briefing to TV and Milk Video functionality require Internet connection and TV and device to be on the same network. Quick Connect and Briefing to TV available on 2015 Television (K Series) only. Briefing to TV available on Galaxy S6 and Galaxy S6 Edge only.</p>
                    <p>&copy; 2015 MARVEL marvel.com</p>
                    <p>&copy; 2015 Samsung Electronics America, Inc. Samsung, Samsung Galaxy, Galaxy S, Samsung Gear VR, Samsung Smart TV and Super AMOLED are all trademarks of Samsung Electronics Co., Ltd. Screen images simulated. Appearance of device may vary.</p>
                </div>
            </div>
        </div>
        <!-- END Deployable Content -->

</cfoutput>

