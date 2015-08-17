<cfoutput>
	
	<form id="testEncrypt" role="form" class="form-horizontal">
		<h1>VFD Test Encryption</h1>
	
		<div>
			Master key : #rc.mkey# <br/>
			IV : #rc.useasIV# <br/>
			Secret Encoded : #rc.secretEncoded# <br/>
			Secret Decoded : #rc.decoded# <br/>
		</div>		
	</form>

	
</cfoutput>