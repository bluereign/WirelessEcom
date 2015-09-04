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
	var	children = $(div).children('.info'),
		featuredChildIndex = $('.featured').index(),
		childrenLength = children.length,
		options = {
			dots: false,
			infinite: true,
			initialSlide: featuredChildIndex - 1,
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

	// Carousel on Update Data Plan Page
	buildSlider($carousel);

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

	$thumbnails.on('click', function(e) {
		e.preventDefault();
		var $this = $(this),
			newSrc = $this.children('img').data('full-src');

		$thumbnails.removeClass('active');
		$this.addClass('active');

		swapDeviceImage(newSrc);
	});

	// Filters on accessories
	$('.nav-tabs a').on('click', function() {
		var parentClass = $(this).parent().attr('class');

		$filterableProducts.parent().hide();

		if (parentClass === 'all') {
			$filterableProducts.parent().show();
		} else {
			$('.' + parentClass).parent().show();
		}
	});

	$products.on('mouseover', function() {
		$(this).addClass('hover');
	});

	$products.find('.info-wrap').on('mouseover', function(e) {
		e.stopPropagation();
	});

	$products.on('mouseout', function() {
		$(this).removeClass('hover');
	});
});

