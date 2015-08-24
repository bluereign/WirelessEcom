function changeText(text) {
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
		$newCustomer2 = $('#new-customer2');

	// Carousel on Update Data Plan Page
	buildSlider($carousel);

	// Swap text on Show/Hide Cart Details
	$('.plan-details').on('click', function() {
		var $this = $(this);
		$(this).text(changeText($this.text()));
	});

	// Modal for Verizon Wireless Customer Type
	$newCustomer2.hide();

	$newCustomer1.on('click', '.btn', function() {
		toggleDiv('#new-customer1', '#new-customer2');
	});
});

