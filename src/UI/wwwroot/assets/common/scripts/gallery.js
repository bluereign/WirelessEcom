var $j = jQuery; //Avoid conflict with Prototype lib

$j(document).ready(function() {
	/* This code is executed after the DOM has been completely loaded */
	
	var totWidth=0;
	var positions = new Array();
	var xStartPos = 0;
	var yStartPos = 0;
	
	$j('#slides .slide').each(function(i){
		
		if (i == 0)
		{
			xStartPos = $j(this).position().left;
			yStartPos = $j(this).position().top;
		}
		else
		{
			$j(this).position({ top: xStartPos, left: yStartPos });
			$j(this).hide();
		}
		
		/* Traverse through all the slides and store their accumulative widths in totWidth */
		
		//positions[i]= totWidth;
		//totWidth += $j(this).width();
		
		/* The positions array contains each slide's commulutative offset from the left part of the container */
		
		if(!$j(this).width())
		{
			alert("Please, fill in width & height for all your images!");
			return false;
		}
		
	});
	
	//$j('#slides').width(totWidth);

	/* Change the cotnainer div's width to the exact width of all the slides combined */

	$j('#menu ul li a').click(function(e,keepScroll){

			/* On a thumbnail click */

			$j('li.menuItem').removeClass('act').addClass('inact');
			$j(this).parent().addClass('act');
			
			var pos = $j(this).parent().prevAll('.menuItem').length;
			
			var slides = jQuery.makeArray( $j('#slides .slide') );
			
			$j('#slides .slide').each(function(i){
				$j(this).hide();
				
				if (i == pos)
				{
					$j(this).fadeIn(750);
				}
			});
			
			//$j('#slides').stop().animate({marginLeft:-positions[pos]+'px'},450);
			/* Start the sliding animation */
			
			e.preventDefault();
			/* Prevent the default action of the link */
			
			
			// Stopping the auto-advance if an icon has been clicked:
			if(!keepScroll) clearInterval(itvl);
			
			//console.log( $j(this).children().attr('alt') );
			
			$j('#thumb-message').text( $j(this).children().attr('alt') );
	});
	
	/* On page load, mark the first thumbnail as active */
	$j('#menu ul li.menuItem:first').addClass('act').siblings().addClass('inact');
	$j('#thumb-message').text( $j('#menu ul li.act a img').attr('alt') );
	
	/*****
	 *
	 *	Enabling auto-advance.
	 *
	 ****/
	 
	var current=1;
	function autoAdvance()
	{
		if(current==-1) return false;
		
		$j('#menu ul li a').eq(current%$j('#menu ul li a').length).trigger('click',[true]);	// [true] will be passed as the keepScroll parameter of the click function on line 28
		current++;
		
		
	}
	
	function updateMessage()
	{
		$j('#thumb-message').text('Shit' + current);
		console.log(current);
	}

	// The number of seconds that the slider will auto-advance in:
	
	var changeEvery = 7;

	var itvl = setInterval(function(){autoAdvance()},changeEvery*1000);

	/* End of customizations */
});