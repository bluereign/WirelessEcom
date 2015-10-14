function swapDeviceImage(src) {
	var $mainImage = $('.device-main img');

	$mainImage.attr('src', src);
}

function showHideText(text) {
	var	SHOW_TEXT = 'Show Plan Details',
		HIDE_TEXT = 'Hide Plan Details';

	return  text === SHOW_TEXT ? HIDE_TEXT : SHOW_TEXT;
}

function toggleDiv(divToHide, divToShow) {
	$(divToHide).hide();
	$(divToShow).show();
}

function buildSlider(div) {
   
    
		var	$this = $(div),
			children = $this.children('.info'),
			featuredChildIndex = $this.find('.featured').index(),
			childrenLength = children.length,
			options = {
				dots: false,
				infinite: false,
				initialSlide: (featuredChildIndex >= 0 ? featuredChildIndex : 1) - 1,
				speed: 300,
				slidesToShow: 3,
				slidesToScroll: 1,
				responsive: [
					{
						breakpoint: 480,
						settings: {
							slidesToShow: 1
						}
					}
				]
			};

		if (childrenLength < 3) {
			options['arrows'] = false;
		}

		$(div).slick(options);
}

$(document).ready(function() {
	var $carousel = $('.carousel'),
		$newCustomer1 = $('#new-customer1'),
		$newCustomer2 = $('#new-customer2'),
		$thumbnails = $('.device-thumb'),
		$products = $('.accessories .product');
		$filterableProducts = $('.tab-pane .product');

	$carousel.each(function(index, el){
		buildSlider(el);
	});

	// Swap text on Show/Hide Cart Details
	$('.plan-details').on('click', function() {
		var $this = $(this);

		$(this).text(showHideText($this.text()));
	});

	// Modal for Verizon Wireless Customer Type
	$newCustomer2.hide();

	$newCustomer1.on('click', '.btn', function(e) {
		e.preventDefault();
		toggleDiv('#new-customer1', '#new-customer2');
	});

	// Filters on accessories
	$('.nav-tabs a').on('click', function(e) {
		var parentClass = $(this).parent().attr('class'),
			$filterProducts = $filterableProducts.parent();

		if ($filterableProducts) {
			$filterProducts.hide();

			if (parentClass === 'all') {
				$filterProducts.show();
			} else if (parentClass) {
				$('.' + parentClass).parent().show();
			}
		}
	});

	$('.plans #choose-a-new-plan').on('click', function (e) {
	    e.preventDefault();
	    $('#plan-options').show();
	    $('.plan-chooser .plan-seperator').hide();
	    $('#choose-a-new-plan').hide();
	    $carousel.each(function (index, el) {
	        $carousel[index].slick.setPosition();
	    });
	});

	$('.nav-tabs').on('shown.bs.tab', function (e, index) {
        $carousel.each(function(index, el){
			$carousel[index].slick.setPosition();
		});
	});

	// View Details Mouseover
	$products
		.on('mouseover', function() {
			$(this).addClass('hover');
		})
		.on('mouseout', function() {
			$(this).removeClass('hover');
		})
		.find('.info-wrap').on('mouseover', function(e) {
			e.stopPropagation();
		});

	// Swap images on thumbnail click in view details modal
	$thumbnails.on('click', function(e) {
		e.preventDefault();
		var $this = $(this),
			newSrc = $this.children('img').data('full-src');

		$thumbnails.removeClass('active');
		$this.addClass('active');

		swapDeviceImage(newSrc);
	});
});

