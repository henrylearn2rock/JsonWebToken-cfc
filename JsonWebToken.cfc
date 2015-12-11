/**
*   JsonWebToken for ColdFusion 10+ 
*
*   Supported algorithms: HS256, HS384 or HS512 
*	
*   Author: Henry Ho  (@henrylearn2rock)
* 	Released under the MIT license
*/
component displayname="JSON Web Token" accessors="true" 
{
	/** in base64url encoding */
	property string header;
	
	/** in base64url encoding */
	property string payload;
	
	/** in base64url encoding */
	property string signature;
	
	
	/** @jwt JSON Web Token string */
	function init(string jwt='') 
	{
		if (len(jwt))
		{
			var parts = listToArray(jwt, '.');
			setHeader(parts[1]);
			setPayload(parts[2]);
			setSignature(parts[3]); 
		}
	}

	
	struct function decode(required string algorithm, required string key)
	{
		if (algorithm != "none")
			verify(algorithm, key, true);
		
		return deserializeJSON(decodeBase64Url(getPayload()));
	}

	
	string function encode(required payload, required string algorithm, required string key, header={})
	{
		var defaultHeader = {"typ":"JWT","alg":algorithm};
		structAppend(header, defaultHeader, false);

		setHeader( encodeBase64Url(serializeJSON(header)) );
		setPayload( encodeBase64Url(serializeJSON(payload)) );
		setSignature( sign(algorithm, key) );
		
		return toJwtString();
	}
	
	
	boolean function verify(required string algorithm, required string key, throwOnError=false) 
	{
		var expected = sign(algorithm, key);
		var actual = getSignature();
		var valid = compare(expected, actual) == 0;
		
		if (!valid && throwOnError)
			throw (type="JWT.InvalidSignature", message="JSON Web Token signature verification failed");
			
		return valid;
	}


	string function toJwtString() 
	{
		return getHeader() & '.' & getPayload() & '.' & getSignature();
	}
	
	
	private string function sign(required string algorithm, required string key) 
	{
		var message = getHeader() & '.' & getPayload();
		var hmacAlgorithm = toHmacAlgorithm(algorithm);
		var hmacHex = hmac(message, key, hmacAlgorithm, 'utf-8');
		var hmacBinary = binaryDecode(hmacHex, "hex");
		var signature = encodeBase64Url(hmacBinary);

		return signature;
	}


	private string function decodeBase64Url(required string input) 
	{
		var base64Url = replaceList(input, "-,_", "+,/");
		var binary = binaryDecode(base64Url, "base64");
		var utf8 = charsetEncode(binary, "utf-8");
		
		return utf8;
	}


	/** @input in binary or string (utf8) */
	private string function encodeBase64Url(required input) 
	{
		var binary = isBinary(input) ? input : charsetDecode(input, "utf-8");
		var base64 = binaryEncode(binary, "base64");
		var base64url = replaceList(base64, "+,/,=", "-,_,"); 
		
		return base64url;
	}

	
	/** translate JWT algorithm naming to HMac() algorithm naming */
	private string function toHmacAlgorithm(required string algorithm)
	{
		switch (algorithm) {
			case "HS256": return "HMACSHA256";
			case "HS384": return "HMACSHA384";	
			case "HS512": return "HMACSHA512";
		}
		
		return algorithm;		// left not translated
	}
}
