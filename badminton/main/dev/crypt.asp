<%
'암호화 모듈-----------------------------------------------------------------------------
set crypt = Server.CreateObject("Chilkat_9_5_0.Crypt2")
success = crypt.UnlockComponent("YJKMKR.CB10118_vNZ9zq4wnw7P")
crypt.CryptAlgorithm = "aes"

'CipherMode may be "ecb", "cbc", "ofb", "cfb", "gcm", etc.
crypt.CipherMode = "cbc"

'KeyLength may be 128, 192, 256
crypt.KeyLength = 256

crypt.PaddingScheme = 0
crypt.EncodingMode = "hex"
  
ivHex = "000167856675020A506Y0708090R7YA"
crypt.SetEncodedIV ivHex,"hex"

keyHex = "000167856675020A506Y0708090R7YA101411A2131D6415K16171H8191A"
crypt.SetEncodedKey keyHex,"hex"
'----------------------------------------------------------------------------------------------



'Response.Write crypt.EncryptStringENC("ABCDS") & "<BR>"
'Response.Write crypt.DecryptStringENC("56095D42C8ACFF541C908E904F320C06")
%>