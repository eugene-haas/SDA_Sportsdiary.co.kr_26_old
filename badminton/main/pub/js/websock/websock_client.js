/* ========================================================================================= 
    Purpose : WebSocket Client
    Make    : 2020. 04.22
    Author  :                                                                 By Aramdry
	========================================================================================= */

/* ========================================================================================= 
    // **아래 정의된 함수 호출시 유의점 
   // $(function () {} 정의의 의미가 Document OnReady 이후에 활성화          
	// OnReady가 된 다음에 호출하여야 한다.  OnReady 이전에 호출시 not Defined Message를 받는다. 
	
	- port, addr 분리 한 범용 socket
	- call back function 적용 
	========================================================================================= */

$(
	()=>{
		CWebSock = function() {
			this.sock = null; 
			this.bIsConn = false; 

			this.cb_sockOpen = null; 
			this.cb_sockClose = null; 
			this.cb_sockError = null; 
			this.cb_sockMessage = null; 
		}

		CWebSock.prototype.SetCallBack = function(cb_sockOpen, cb_sockClose, cb_sockErr, cb_sockMsg) {
			this.cb_sockOpen = cb_sockOpen; 
			this.cb_sockClose = cb_sockClose; 
			this.cb_sockError = cb_sockErr; 
			this.cb_sockMessage = cb_sockMsg; 
		}

		CWebSock.prototype.Init = function(svrAddr, svrPort) {
			var strSvrInfo = svrAddr + svrPort; 

			// if user is running mozilla then use it's built-in WebSocket
			window.WebSocket = window.WebSocket || window.MozWebSocket;
			// if browser doesn't support WebSocket, just show
			// some notification and exit
			if (!window.WebSocket) {
				console.log("'Sorry, but your browser doesn\'t support WebSocket.'");
				return;
			}

			this.sock = new WebSocket(strSvrInfo); 

			this.sock.onopen 		= ()=>{ 
				this.bIsConn = true; 
				this.cb_sockOpen();  
			}

			this.sock.onclose 	= ()=>{ 
				this.bIsConn = false; 
				this.sock = null; 
				this.cb_sockClose(); 
			} 

			this.sock.onerror 	= (error)=>{ 
				this.cb_sockError(error); 
			} 
			this.sock.onmessage 	= (msg)=>{ 
				var that = this; 
				try {
					if(msg.type === 'utf8' || msg.type === 'message') {						
						var msgObj = JSON.parse(msg.data);

						setTimeout(function() {
							that.cb_sockMessage(msgObj);
						}, 10); 												
					}
				}
				catch(e) {
					console.log('Invalid JSON: ', msg.data);
					return;
				}
				
			}
		}

		CWebSock.prototype.Send = function(strMsg) {
			var SOCK_OPEN = 1; 

			if(!this.bIsConn) return false; 
			if(this.sock == undefined || this.sock == null) return false;
			if(this.sock.readyState != SOCK_OPEN) return false; 

			this.sock.send(strMsg);
			strMsg = null; 
		}

		CWebSock.prototype.SendEx = function(packObj) {
			var SOCK_OPEN = 1; 
			
			if(packObj == undefined || packObj == null) return false; 
			if(packObj.getExportStr == undefined) return false; 
			if(!this.bIsConn) return false; 
			if(this.sock == undefined || this.sock == null) return false;
			if(this.sock.readyState != SOCK_OPEN) return false; 

			var strMsg = packObj.getExportStr(); 
			this.sock.send(strMsg);
			strMsg = null; 
			packObj = null; 

			return true; 
		}

		CWebSock.prototype.CloseSock = function() {
			if(this.sock != undefined && this.sock != null) this.sock.close(); 
			this.sock = null; 
			this.bIsConn = false; 
		}

		CWebSock.prototype.Close = function() {
			this.sock = null; 
			this.bIsConn = false; 

			this.cb_sockOpen = null; 
			this.cb_sockClose = null; 
			this.cb_sockError = null; 
			this.cb_sockMessage = null; 
		}
	}
);