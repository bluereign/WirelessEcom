<cfset qEditorRanks = application.model.PropertyManager.getEditorAccessoriesRankings() />


<style>
	#sortable { list-style-type: none; margin: 0; padding: 0; width: 60%; }
	#sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
	#sortable li span { position: absolute; margin-left: -1.3em; }
</style>

<script>
		
		
	$(document).ready(function()	{
		$( "#sortable" ).sortable();
		$( "#sortable" ).disableSelection();
		
		console.log('Ready!!!!');
		
	});		
		
		
	function submitForm() 
	{
		console.log('SUBMIT!!!!');
	}
	
</script>


<div class="demo">

<ul id="sortable" style="width:85%;">
	<cfoutput query="qEditorRanks" >
		<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>#SortRank# #ProductTitle# (#GersSku#|#ProductId#)</li>
	</cfoutput>
</ul>

<button onclick="javascript:submitForm();">Submit</button>




