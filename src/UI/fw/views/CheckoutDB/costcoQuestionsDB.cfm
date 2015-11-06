<style>
.sidebar
{
	width: 220px;
	padding: 0 0 0 10px;
	 border-left: 1px; 
	border-right: none !important;
	font-size: 1.2em;
}
.sidebar h4 {
  border-bottom: 1px solid #b3b3b3;
  border-top: 1px solid #b3b3b3;
  background-color: #f6f7f8;
  background-image: -moz-linear-gradient(top, #fefefe, #e8eaeb);
  background-image: -ms-linear-gradient(top, #fefefe, #e8eaeb);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#fefefe), to(#e8eaeb));
  background-image: -webkit-linear-gradient(top, #fefefe, #e8eaeb);
  background-image: -o-linear-gradient(top, #fefefe, #e8eaeb);
  background-image: linear-gradient(top, #fefefe, #e8eaeb);
  background-repeat: repeat-x;
  font-size: 16px;
  font-size: 1rem;
  line-height: 1.5625;
  margin: 0;
  padding: 5px 10px;
}
.sidebar h4:first-child {
  border-top-right-radius: 5px;
  border-top-left-radius: 5px;
  border-top: 0;
}
.sidebar ul {
  list-style: none;
  margin: 0;
  padding: 0;
}
.sidebar ul li {
  background: #f2f2f2;
  font-size: 12px;
  font-size: 0.75rem;
  margin: 10px 0;
}
.sidebar ul li:first-child {
  margin-top: 0;
}
.sidebar ul li:last-child {
  border-bottom-right-radius: 5px;
  border-bottom-left-radius: 5px;
  margin-bottom: 0;
}
.sidebar ul li a {
  color: #157efb;
  display: block;
  padding: 10px;
}
</style>
<cfoutput>
  <div class="sidebar">
        <h4>Have Questions?</h4>
        <ul>
          <li><a href="/index.cfm/go/content/do/customerService" target="_blank">Call us at #request.config.customerServiceNumber#</a></li>
          <li><a href="##">Chat with one of our representatives</a></li>
          <li><a href="mailto:#requset.config.CustomerCareEmail#">E-mail one of our experts</a></li>
          <li><a href="##">Frequently Asked Questions</a></li>
        </ul>
        <h4>Our Signature Promise</h4>
        <ul>
          <li><a href="##">Free UPS ground shipping</a></li>
          <li><a href="##">90 day return policy</a></li>
          <li><a href="##">Return in store</a></li>
        </ul>
      </div>
</cfoutput>