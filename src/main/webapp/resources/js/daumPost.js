function daumPost(){
    new daum.Postcode({
        oncomplete: function(data) {
			console.log( data );
			const addr1 = document.getElementById("addr1");
			const addr2 = document.getElementById("addr2");
			const addr3 = document.getElementById("addr3");
			let addr = "";
			if(data.userSelectedType === "R"){
				addr = data.roadAddress;
			}else{
				addr = data.jibunAddress;
			}
			addr1.value = data.zonecode;
			addr2.value = addr;
			addr3.focus();
        }
    }).open();
}