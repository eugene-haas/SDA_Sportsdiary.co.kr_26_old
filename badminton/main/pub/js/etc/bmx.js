/* =================================================================================== 
    * 2018. 11. 26        
    * java script에서 사용하는 작은 utility function이다. 
                                                                    By Aramdry
   =================================================================================== */


   var bmx = bmx || {}

   /* =================================================================================== 
       Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
       =================================================================================== */
       bmx.TeamGBtoSimple = function(text)
       {
         var tempText;
         var strSrc = "" + text;       

         if(strSrc == ""){
            tempText = "";
         }
         else {
            // tempText = String(text).replace("여자중학교","여중");
            tempText = strSrc.replace("여자중학교","여중");
            tempText = tempText.replace("여자고등학교","여고");
            tempText = tempText.replace("여자대학교","여대");
            tempText = tempText.replace("남자중학교","남중");
            tempText = tempText.replace("남자고등학교","남고");
            tempText = tempText.replace("남자대학교","남대");
            tempText = tempText.replace("체육중학교","체중");
            tempText = tempText.replace("체육고등학교","체고");
            tempText = tempText.replace("체육대학교","체대");
            tempText = tempText.replace("초등학교","초");
            tempText = tempText.replace("중학교","중");
            tempText = tempText.replace("고등학교","고");
            tempText = tempText.replace("대학교","대");
         }
         return tempText
       };

   /* =================================================================================== 
         playType - Single Game / Double Game ( 단식/복식 유무 )
       =================================================================================== */
       bmx.IsDoublePlay = function(playType) {
          return (playType == "B0020002");
       }

/* =================================================================================== 
       Round, seed Count를 입력받아 현재 Round에 적절한 Seed를 설정했는지 검사한다. 
   =================================================================================== */
   bmx.IsValidSeedCnt = function(nRound, nSeed)
   {
      var nMax = bmx.getSeedCnt(nRound);

      if(nSeed>nMax) return false; 
      return true; 
   }

/* =================================================================================== 
       Round를 입력받아 허용가능한 Seed Count를 반환한다. 
   =================================================================================== */
   bmx.getSeedCnt = function(nRound)
   {
      var nMax = 0;
      if(nRound < 3) nMax = 0; 
      else if(nRound < 16) nMax = 2; 
      else if(nRound < 32) nMax = 4; 
      else if(nRound < 64) nMax = 8; 
      else if(nRound < 256) nMax = 16; 

      return nMax; 
   }

/* ==================================================================================
      팀명 축약 
   ================================================================================== */  
   bmx.GetSimpleTeamName = function(strTeam)
   {
      var nMax = 8, bReduceMark = false; 
      if(strTeam.indexOf("여자중학교") != -1)        strTeam = String(strTeam).replace("여자중학교","여중");
      else if(strTeam.indexOf("여자고등학교") != -1) strTeam = String(strTeam).replace("여자고등학교","여고");
      else if(strTeam.indexOf("여자대학교") != -1)   strTeam = String(strTeam).replace("여자대학교","여대");
      else if(strTeam.indexOf("남자중학교") != -1)   strTeam = String(strTeam).replace("남자중학교","남중");
      else if(strTeam.indexOf("남자고등학교") != -1) strTeam = String(strTeam).replace("남자고등학교","남고");
      else if(strTeam.indexOf("남자대학교") != -1)   strTeam = String(strTeam).replace("남자대학교","남대");
      else if(strTeam.indexOf("체육중학교") != -1)   strTeam = String(strTeam).replace("체육중학교","체중");
      else if(strTeam.indexOf("체육고등학교") != -1) strTeam = String(strTeam).replace("체육고등학교","체고");
      else if(strTeam.indexOf("체육대학교") != -1)   strTeam = String(strTeam).replace("체육대학교","체대");
      else if(strTeam.indexOf("초등학교") != -1)     strTeam = String(strTeam).replace("초등학교","초");
      else if(strTeam.indexOf("중학교") != -1)       strTeam = String(strTeam).replace("중학교","중");
      else if(strTeam.indexOf("고등학교") != -1)     strTeam = String(strTeam).replace("고등학교","고");      
      else if(strTeam.indexOf("대학교") != -1)       strTeam = String(strTeam).replace("대학교","대");
      else {
         strTeam = utx.reduceStr(strTeam, nMax, bReduceMark);  
      }

      return strTeam; 
	}
	

	/* ==================================================================================
      seed no를 받아서 seed text를 반환한다. 1, 2, 3/4, 5/8, 9/16 시드 표시
   ================================================================================== */
	bmx.getStrSeed = function(nSeed) {
		var strSeed = nSeed;
		nSeed = Number(nSeed);

		if (nSeed > 2 && nSeed < 5) strSeed = "3/4";
		else if (nSeed > 4 && nSeed < 9) strSeed = "5/8";
		else if (nSeed > 8 && nSeed < 17) strSeed = "9/16";

		return strSeed;
	}
