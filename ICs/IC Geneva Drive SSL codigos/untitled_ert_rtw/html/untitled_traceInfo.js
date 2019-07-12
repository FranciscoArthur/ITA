function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <Root>/Gain */
	this.urlHashMap["untitled:1"] = "msg=rtwMsg_reducedBlock&block=untitled:1";
	/* <Root>/Gain1 */
	this.urlHashMap["untitled:5"] = "msg=rtwMsg_reducedBlock&block=untitled:5";
	/* <Root>/Gain2 */
	this.urlHashMap["untitled:6"] = "msg=rtwMsg_reducedBlock&block=untitled:6";
	/* <Root>/Integrator */
	this.urlHashMap["untitled:3"] = "untitled.c:149,186,226&untitled.h:62,68,74,80";
	/* <Root>/Integrator1 */
	this.urlHashMap["untitled:4"] = "untitled.c:153,189,229&untitled.h:69,75,81";
	/* <Root>/Scope */
	this.urlHashMap["untitled:7"] = "msg=rtwMsg_reducedBlock&block=untitled:7";
	/* <Root>/Sum */
	this.urlHashMap["untitled:2"] = "untitled.c:152&untitled.h:63";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "untitled"};
	this.sidHashMap["untitled"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<Root>/Gain"] = {sid: "untitled:1"};
	this.sidHashMap["untitled:1"] = {rtwname: "<Root>/Gain"};
	this.rtwnameHashMap["<Root>/Gain1"] = {sid: "untitled:5"};
	this.sidHashMap["untitled:5"] = {rtwname: "<Root>/Gain1"};
	this.rtwnameHashMap["<Root>/Gain2"] = {sid: "untitled:6"};
	this.sidHashMap["untitled:6"] = {rtwname: "<Root>/Gain2"};
	this.rtwnameHashMap["<Root>/Integrator"] = {sid: "untitled:3"};
	this.sidHashMap["untitled:3"] = {rtwname: "<Root>/Integrator"};
	this.rtwnameHashMap["<Root>/Integrator1"] = {sid: "untitled:4"};
	this.sidHashMap["untitled:4"] = {rtwname: "<Root>/Integrator1"};
	this.rtwnameHashMap["<Root>/Scope"] = {sid: "untitled:7"};
	this.sidHashMap["untitled:7"] = {rtwname: "<Root>/Scope"};
	this.rtwnameHashMap["<Root>/Sum"] = {sid: "untitled:2"};
	this.sidHashMap["untitled:2"] = {rtwname: "<Root>/Sum"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
