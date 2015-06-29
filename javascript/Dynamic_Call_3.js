
	var eGHBLink ;
	var eGHBMode ;
    var HBLink ;
	var HBNoCookies = "true";
	var helpWindow = 'help_window';
		var hipboneLauncher = "../librarian/hipboneLauncher.html?host=interact4.247ref.org&affinity=Default";
	
	var HB_LINK = '';
	
	var helperWindowObj;
	function startHelpApp() {
	          windowParams = "";
	          if(document.all)
	                    windowParams = "resizable=yes,";
	          windowParams = windowParams +"width=30,height=35";
	          
			  helperWindowObj = window.open(hipboneLauncher, helpWindow, windowParams);
	}
	//Note: Hipbhone Dynamic Start Page uses the function "startVarApp"
	
	function startVarApp() {
		helperWindowObj.close();
		window.focus() ;
		if( eGHBMode==1 )
			window.location = eGHBLink ;
		else
			openHelp( eGHBLink ) ;
	}
	
	function eGHBDynamicPage( url, mode, lib_url)
	{   
	    HBLink = "http://www.library.ucla.edu/onlinelibrarian/escort.html";
		//alert(HBLink);
		eGHBLink = url ;
		if( mode == 1 )
			eGHBLink = eGHBLink + "&referer=" + escape(window.location.href);
	
		eGHBMode = mode ;
		startHelpApp() ;
     }            