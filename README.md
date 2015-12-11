# JsonWebToken-cfc
A lightweight implemention of JSON Web Token (http://jwt.io/) for ColdFusion 10+

A single CFC written in very readable pure CFScript with no third party dependency.

Here is an example JWT from http://jwt.io/ :

    jwt = new JsonWebToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ");
    
    payload = jwt.decode('HS256', 'secret');

If you are looking for RS256 / RS384 / RS512 support, check out https://github.com/bennadel/JSONWebTokens.cfc