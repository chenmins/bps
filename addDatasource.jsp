<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/governor/frame/common.jsp"%>


<script type="text/javascript">
	function checkJndiName(obj){
		var jndiNames = "<b:write property='jndiNames'/>";
		if (obj.value == "") {
			return true;
		}
		
		if (jndiNames.indexOf(","+obj.value+",")>=0){
			f_alert(obj,"<b:message key="gov_alert.jndiNameExists"/>");
			return false;
		}
		return true;
	}
	
	function checkDsName(obj){
		var datasourceNames = "<b:write property='datasourceNames'/>".toLowerCase();
		
		if (datasourceNames.indexOf(","+obj.value.toLowerCase()+",")>=0){
			f_alert($id("groupName"),"<b:message key="gov_alert.dataSourceNameExists"/>");
			return false;
		}
		return true;
	}

	function DBDriver(name,displayName,driverName,url){
		this.name=name;
		this.displayName=displayName;
		this.driverName=driverName;
		this.url=url;
	}

	function DBType(typeName){
		this.typeName=typeName;
		this.size=0;
		this.drivers = new Array();
		
		this.addDriver = function(name,displayName,driverName,url){
			if(name==null)
				return;
			this.drivers[this.size]=new DBDriver(name,displayName,driverName,url);
			this.size=this.size+1;
		}
	}
	
	var dbTypes = new Array();
	dbTypes[0]=new DBType('Other');
	dbTypes[0].addDriver('Other','Other','','');
	var i=1;
	<l:iterate id="dblist" property="supportDBInfos">
		dbTypes[i]=new DBType('<b:write iterateId="dblist" property="dbType"/>');
		
		<l:iterate id="driverlist" iterateId="dblist" property="supportedDrivers">
			dbTypes[i].addDriver('<b:write iterateId="driverlist" property="name"/>',
				'<b:write iterateId="driverlist" property="/"/>',
				'<b:write iterateId="driverlist" property="driverName"/>',
				'<b:write iterateId="driverlist" property="url"/>');
		</l:iterate>
		i=i+1;
	</l:iterate>
	
	
	function findDBType(type){
		for(var i=0;i<dbTypes.length;i++){
			if(dbTypes[i].typeName==type){
				return dbTypes[i];
			}
		}
		return null;
	}

	function findDBDriver(type,drvName){
		var dbType=findDBType(type);
		if(dbType!=null){
			for(var i=0;i<dbType.drivers.length;i++){
				if(dbType.drivers[i].name==drvName){
					return dbType.drivers[i];
				}
			}
		}
		return null;
	}

	//added by wwb
	var username_onblur ;
	var password_onblur;
	var username_validateAttr;
	
	function changeCheck(){
		if($id("jdbc_databaseType").value=="Other"){
			//
			if (username_validateAttr=='undefined'||username_validateAttr==null)
				username_validateAttr = $id("jdbc_c3p0_username").validateAttr;
			if (username_onblur=='undefined'||username_onblur==null)
				username_onblur = $id("jdbc_c3p0_username").onblur;
			if (password_onblur=='undefined'||password_onblur==null)
				password_onblur = $id("jdbc_c3p0_password").onblur;
			f_alert_verify_successful($id("jdbc_c3p0_username"));
			f_alert_verify_successful($id("jdbc_c3p0_url"));
			f_alert_verify_successful($id("jdbc_c3p0_driver_class"));
			f_alert_hidden_all_message();
			$id("jdbc_c3p0_username").validateAttr=null;		
			$id("jdbc_c3p0_username").onblur=null;			
			$id("jdbc_c3p0_password").onblur=null;
		} else {	
			if (username_validateAttr!='undefined'&&username_validateAttr!=null){
				$id("jdbc_c3p0_username").validateAttr = username_validateAttr;
			}
			if (username_onblur!='undefined'&&username_onblur!=null){
				$id("jdbc_c3p0_username").onblur = username_onblur;
			}
			if (password_onblur!='undefined'&&password_onblur!=null){
				$id("jdbc_c3p0_password").onblur = password_onblur;
			}
		}	
	}
	//over

	function changeDB(){
		var selectObj=$id("jdbc_driverType");
		var findDB=findDBType($id("jdbc_databaseType").value);	
	
		changeCheck();

		if(findDB!=null){
			for (var q=selectObj.options.length;q>=0;q--) selectObj.options[q]=null;
			for(var i=0;i<findDB.drivers.length;i++){
				newopt = document.createElement("option") ;
				newopt.value=findDB.drivers[i].name;
				newopt.text=findDB.drivers[i].displayName;	
				selectObj.options[i]=newopt;
			}
			selectObj.onchange();
		}
	}
	
	function changeDriver(){
		var driver=findDBDriver($id("jdbc_databaseType").value,$id("jdbc_driverType").value);
		
		if(driver!=null){
			$id("jdbc_c3p0_driver_class").value=driver.driverName;
			$id("jdbc_c3p0_url").value=driver.url;

			f_alert_hidden_message($id("jdbc_c3p0_driver_class"));
			f_alert_hidden_message($id("jdbc_c3p0_url"));
		}
	}

</script>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form id="mgrForm" method="post" name="mgrForm"	action="com.primeton.governor.config.DataSourceConfig.flow?_eosFlowAction=actAdd" onsubmit="return checkForm(this);">
<h:hidden property="_eosFlowKey" />
<h:hidden property="optType" value="add"/>
<h:hidden property="jndiPort"/>
<h:hidden property="ip"/>
<h:hidden property="port"/>
<h:hidden property="appName"/>
<h:hidden property="serverType"/>
<h:hidden property="started"/>
<table border="0" class="EOS_panel_body" width="100%">
	<tr>
		<td class="EOS_panel_head"><b:message key="gov_title.addDataSource"/></td>
	</tr>
	<tr>
		<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="form_table">
<tbody>
			<tr>
				<td class="form_label" width="20%"><b:message key="gov_title.dataSourceName"/></td>
				<td width="80%"><h:text id="groupName" property="groupName"	maxlength="64" validateAttr="allowNull=false;type=LetterAhead_NumLettMidDown;"
					onblur="checkInput(this);checkDsName(this);" /></td>
			</tr>

			<tr>
				<td class="form_label"><b:message key="gov_title.dataSourceType"/></td>
				<td>
					<h:radio id="check_radio" onclick="changeDisplay('jndialias');" property="datasourceType" value="jndialias" /> JNDI 
					<l:in property="serverType" targetValue="tomcat,Other">
					<h:radio id="check_radio2" property="datasourceType" value="jdbc" onclick="changeDisplay('jdbc');" /> C3P0
					</l:in>
					<span style="display:none" id="isNotSupportJtaWarning" class="warn_msg_area"><b:message key="gov_tip.dsNotSupportJtaGlobalTransaction"/></span>
				</td>
			</tr>
</tbody>
<tbody id="jndialias" style="display:none;" >
				<tr>
					<td class="form_label" width="20%"><b:message key="gov_title.jndiName"/></td>
					<td width="80%"><h:text id="jndialias_datasource" size="50" maxlength="64"
						property="jndialias/jndiName"
						validateAttr="allowNull=false;"
						onblur="checkInput(this);checkJndiName(this);" /></td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.isolationLevel"/></td>
					<td><h:select id="jndialias_transaction_isolation"
						property="jndialias/isolation"
						validateAttr="allowNull=false" onblur="checkInput(this)">
						<h:option label="ISOLATION_DEFAULT" value="ISOLATION_DEFAULT" />
						<h:option label="ISOLATION_READ_COMMITTED"
							value="ISOLATION_READ_COMMITTED" />
						<h:option label="ISOLATION_READ_UNCOMMITTED"
							value="ISOLATION_READ_UNCOMMITTED" />
						<h:option label="ISOLATION_REPEATABLE_READ"
							value="ISOLATION_REPEATABLE_READ" />
						<h:option label="ISOLATION_SERIALIZABLE"
							value="ISOLATION_SERIALIZABLE" />
					</h:select>
					
					</td>
				</tr>
				
				<tr>
					<td class="form_label"><b:message key="gov_title.connectionRetryTimes"/></td>
					<td><h:text id="jndialias_retryConnectCount" property="jndialias/retryConnectCount"	value="-1" maxlength="4"
					validateAttr="allowNull=false;type=integer;minValue=-1" onblur="checkInput(this)" />(-1<b:message key="gov_title.meanNotLimited"/>)
					</td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.testSqlStatement"/></td>
					<td><h:textarea id="jndialias_testConnectSql" 	property="jndialias/testConnectSql"	value="SELECT 1 from EOS_UNIQUE_TABLE"
					validateAttr="allowNull=false;" onblur="checkInput(this)" cols="40"/>
					</td>
				</tr>
				
</tbody>
<tbody id="jdbc" style="display:none;" >
				<tr>
					<td class="form_label" width="20%"><b:message key="gov_title.databaseType"/></td>
					<td width="80%">
						<h:select id="jdbc_databaseType" onchange="changeDB();" property="jdbc/databaseType">
							<l:iterate id="dblist2" property="supportDBInfos">
								<h:option iterateId="dblist2" valueField="dbType" labelField="dbType"/>
							</l:iterate>
						</h:select>
					</td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.driverType"/></td>
					<td>
						<h:select id="jdbc_driverType" onchange="changeDriver();" property="jdbc/jdbcType">
						</h:select>
					</td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.driverClass"/></td>
					<td><h:text id="jdbc_c3p0_driver_class"
						property="jdbc/c3p0DriverClass" size="70"
						validateAttr="allowNull=false" onblur="checkInput(this)" /></td>
				</tr>

				<tr>
					<td class="form_label"><b:message key="gov_title.jdbcConnectionURL"/></td>
					<td><h:text id="jdbc_c3p0_url" property="jdbc/c3p0Url"
						size="70" validateAttr="allowNull=false" onblur="checkInput(this)" /></td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.userName"/></td>
					<td>
					<h:text id="jdbc_c3p0_username"	property="jdbc/c3p0Username" maxlength="64"
					validateAttr="allowNull=false;type=LetterAhead_NumLettMidDown;" onblur="checkInput(this)" />
					</td>
				</tr>

				<tr>
					<td class="form_label"><b:message key="gov_title.password"/></td>
					<td><h:password id="jdbc_c3p0_password"	property="jdbc/c3p0Password" maxlength="20"
						 validateAttr="allowNull=false" onblur="checkInput(this)" /></td>
				</tr>

				<tr>
					<td class="form_label"><b:message key="gov_title.initConnectionNumInPool"/></td>
					<td><h:text id="jdbc_c3p0_pool_size"
						property="jdbc/c3p0Poolsize" maxlength="3"
						validateAttr="allowNull=false;type=integer;minValue=1"
						value="20"
						onblur="checkInput(this);" /></td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.maxConnectionNumInPool"/></td>
					<td><h:text id="jdbc_c3p0_max_pool_size"
						property="jdbc/c3p0Maxpoolsize" maxlength="3"
						value="200"
						validateAttr="allowNull=false;type=integer;minValue=1"
						onblur="checkInput(this);" /></td>
				</tr>

				<tr>
					<td class="form_label"><b:message key="gov_title.minConnectionNumInPool"/></td>
					<td><h:text id="jdbc_c3p0_min_pool_size"
						property="jdbc/c3p0Minpoolsize" maxlength="3"
						validateAttr="allowNull=false;type=integer;minValue=1"
						value="1"
						onblur="checkInput(this);" /></td>
				</tr>
				<tr>
			      <td class="form_label"><b:message key="gov_title.maxIdleTime"/></td>
			      <td><h:text id="jdbc_c3p0_max_idle_time" name="jdbc/c3p0_maxIdleTime" property="item/c3p0_maxIdleTime" value="0" maxlength="9" validateAttr="allowNull=false;type=naturalNumber;minValue=0" onblur="checkInput(this);"/></td>
			    </tr>
			    <tr>
			      <td class="form_label"><b:message key="gov_title.idleConnectionTestPeriod"/></td>
			      <td><h:text id="jdbc_c3p0_idle_connection_test_period" name="jdbc/c3p0_idleConnectionTestPeriod" property="item/c3p0_idleConnectionTestPeriod" value="0" maxlength="9" validateAttr="allowNull=false;type=naturalNumber;minValue=0" onblur="checkInput(this);"/></td>
			    </tr>
			    <tr>
			      <td class="form_label"><b:message key="gov_title.maxStatements"/></td>
			      <td><h:text id="jdbc_c3p0_max_statements" name="jdbc/c3p0_maxStatements" property="item/c3p0_maxStatements" value="0" maxlength="9" validateAttr="allowNull=false;type=naturalNumber;minValue=0" onblur="checkInput(this);"/></td>
			    </tr>
			    <tr>
			      <td class="form_label"><b:message key="gov_title.numHelperThreads"/></td>
			      <td><h:text id="jdbc_c3p0_num_helper_threads" name="jdbc/c3p0_numHelperThreads" property="item/c3p0_numHelperThreads" value="1" maxlength="3" validateAttr="allowNull=false;type=naturalNumber;minValue=0" onblur="checkInput(this);"/></td>
			    </tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.isolationLevel"/></td>
					<td><h:select id="jdbc_transaction_isolation"
						property="jdbc/isolation"
						validateAttr="allowNull=false" onblur="checkInput(this)">
						<h:option label="ISOLATION_DEFAULT" value="ISOLATION_DEFAULT" />
						<h:option label="ISOLATION_READ_COMMITTED" value="ISOLATION_READ_COMMITTED" />
						<h:option label="ISOLATION_READ_UNCOMMITTED" value="ISOLATION_READ_UNCOMMITTED" />
						<h:option label="ISOLATION_REPEATABLE_READ"	value="ISOLATION_REPEATABLE_READ" />
						<h:option label="ISOLATION_SERIALIZABLE"	value="ISOLATION_SERIALIZABLE" />
					</h:select>
					</td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.connectionRetryTimes"/></td>
					<td><h:text id="jdbc_retryConnectCount" property="jdbc/retryConnectCount" value="-1" maxlength="4"	
					validateAttr="allowNull=false;type=integer;minValue=-1" onblur="checkInput(this)" />(-1<b:message key="gov_title.meanNotLimited"/>)
					</td>
				</tr>
				<tr>
					<td class="form_label"><b:message key="gov_title.testSqlStatement"/></td>
					<td><h:textarea id="jdbc_testConnectSql" property="jdbc/testConnectSql"	value="SELECT 1 from EOS_UNIQUE_TABLE"
					validateAttr="allowNull=false;" onblur="checkInput(this)" cols="40"/>
					</td>
				</tr>
				
</tbody>
<tbody>
			<tr>
				<td colspan="2" class="form_bottom">
				<input type="button"
					name="submitbtn" value="<b:message key="gov_button.ok"/>" onclick="chckFrm(true);" class="button" />
				<input type="button" name="cancelbtn" value="<b:message key="gov_button.return"/>" class="button"
					onClick="javascript:history.back();" />
				<input type="button" value="<b:message key="gov_button.testDBConnection"/>" class=button onclick="validateDSConn();">	
			    <span class="warn_msg_area"><b:message key="addDatasource_jsp.pkNote"/></span>					
				</td>
			</tr>	
</tbody>

		</table>


		</td>
	</tr>

</table>
</form>
<script language="JavaScript" type="text/JavaScript">

<l:present  property="result">
<l:equal property="result" targetValue="-1">
alert("<b:message key="gov_alert.dataSourceExistsCannotAdd"/>");
</l:equal>
</l:present> 

var uniqueJndiName = "<b:write property='uniqueJndiName'/>";
var submitType="jndi";
var serverType="<b:write property='serverType' scope='s'/>";
function changeDisplay(dsType){
	//f_alert_hidden_all_message();//doesn't work
	internalAllHiddenMessage();//????????????????????????
	if (dsType=="jdbc"){
		$id("jdbc").style.display="";
		$id("jndialias").style.display="none";
		$id("jdbc").disabled=false;
		$id("jndialias").disabled=true;
		submitType="jdbc";
		changeDB();
		if ((serverType == "jboss") || (serverType == "weblogic") || (serverType == "websphere")) {
			$id("isNotSupportJtaWarning").style.display = "";
		} else {
			$id("isNotSupportJtaWarning").style.display = "none";			
		}
	}else if(dsType=="jndialias"){
		$id("jdbc").style.display="none";
		$id("jndialias").style.display="";
		$id("jdbc").disabled=true;
		$id("jndialias").disabled=false;
		submitType="jndialias";
		$id("isNotSupportJtaWarning").style.display = "none";
	}
	$id("groupName").style.display="";
}

window.onload=function init(){
	<l:notIn property="serverType" targetValue="tomcat,Other">
	$id("check_radio").checked=true;
	changeDisplay("jndialias");
	</l:notIn>
	
	<l:in property="serverType" targetValue="tomcat,Other">
	$id("check_radio2").checked=true;
	changeDisplay('jdbc');
	</l:in>
}

//added by wwb
addOtherOptionInDatabaseSelect();
changeCheck();
function addOtherOptionInDatabaseSelect(){
	var databaseSelect = $id("jdbc_databaseType");
	var option = new Option("Other","Other");
	addOption(databaseSelect,option);
}

function addOption(selectObj,option){
	var oldOptions = new Array();
	for (var index=0;index<selectObj.options.length;index++){
		oldOptions[index]=selectObj.options[index];
	}
	selectObj.options.length=0;
	selectObj.options[0]=option;
	for (var index=0;index<oldOptions.length;index++){
		selectObj.options[index+1]=oldOptions[index];
	}
}
//over
function compare(){
	
	var minObj = $id("jdbc_c3p0_min_pool_size");	
	var iniObj = $id("jdbc_c3p0_pool_size");	
	var maxObj = $id("jdbc_c3p0_max_pool_size");
	var result = true;
	var message = "";
	
	//to check min. number of connections
	if(parseFloat(minObj.value) > parseFloat(iniObj.value)){
		message = "<b:message key="gov_alert.cannotGreaterThan"/><b:message key="gov_alert.initConnectionNum"/>";
		result =  false;
	}
	if(parseFloat(minObj.value) > parseFloat(maxObj.value)){
		if (message == "") {
			message = "<b:message key="gov_alert.cannotGreaterThan"/><b:message key="gov_alert.maxConnectionNum"/>";
		} else {
			message += ",<b:message key="gov_alert.cannotGreaterThan"/><b:message key="gov_alert.maxConnectionNum"/>";
		}		
		result =  false;
	}
	if (result == false && message != "") {
		f_alert(minObj,"<b:message key="gov_alert.minConnectionNum"/><b:message key='gov_punctuation.comma'/>" + message + "<b:message key='gov_punctuation.excalmatory'/>");
		message = "";
	}
	
	//to check init. number of connections
	if(parseFloat(iniObj.value) < parseFloat(minObj.value)){
		message = "<b:message key="gov_alert.cannotLessThan"/><b:message key="gov_alert.minConnectionNum"/>";
		result =  false;
	}
	if(parseFloat(iniObj.value) > parseFloat(maxObj.value)){
		if (message == "") {
			message = "<b:message key="gov_alert.cannotGreaterThan"/><b:message key="gov_alert.maxConnectionNum"/>";
		} else {
			message += "<b:message key='gov_punctuation.comma'/><b:message key="gov_alert.cannotGreaterThan"/><b:message key="gov_alert.maxConnectionNum"/>";
		}		
		result =  false;
	}
	if (result == false && message != "") {
		f_alert(iniObj,"<b:message key="gov_alert.initConnectionNum"/><b:message key='gov_punctuation.comma'/>" + message + "<b:message key='gov_punctuation.excalmatory'/>");
		message = "";
	}
	
	//to check max. number of connections 
	if(parseFloat(maxObj.value) < parseFloat(minObj.value)){
		message = "<b:message key="gov_alert.cannotLessThan"/><b:message key="gov_alert.minConnectionNum"/>";
		result =  false;
	}
	if(parseFloat(maxObj.value) < parseFloat(iniObj.value)){
		if (message == "") {
			message = "<b:message key="gov_alert.cannotLessThan"/><b:message key="gov_alert.initConnectionNum"/>";
		} else {
			message += "<b:message key='gov_punctuation.comma'/><b:message key="gov_alert.cannotLessThan"/><b:message key="gov_alert.initConnectionNum"/>";
		}		
		result =  false;
	}
	if (result == false && message != "") {
		f_alert(maxObj,"<b:message key="gov_alert.maxConnectionNum"/><b:message key='gov_punctuation.comma'/>" + message + "<b:message key='gov_punctuation.excalmatory'/>");
		message = "";
	}
	return result;		
}

function chckFrm(flag){
	if(!checkDsName($id("groupName"))) return;
	
    if (f_check_LetterAhead_NumLettMidDown($id("groupName"))==false){
   		return false;
    }
    
    if ($id("groupName").value == "EOS-Unique") {
    	f_alert_show_message($id("groupName"),"<b:message key="addDatasource_jsp.dsNameNotEOSUnique"/>");
    	return false;
	}

   if (submitType=="jdbc"){
		if ($id("jdbc_databaseType").value.length==0){
			f_alert_show_message($id("jdbc_databaseType"),"<b:message key="gov_alert.pleaseSelectDBType"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		if (isNull($id("jdbc_c3p0_driver_class").value)==true){
			f_alert_show_message($id("jdbc_c3p0_driver_class")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		if (isNull($id("jdbc_c3p0_url").value)==true){
			f_alert_show_message($id("jdbc_c3p0_url")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		if ($id("jdbc_databaseType").value!="Other" && isNull($id("jdbc_c3p0_username").value)==true){
			f_alert_show_message($id("jdbc_c3p0_username")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		
		
 		if (checkInput($id("jdbc_c3p0_pool_size"))==false){
			return false;
		}
 		if (checkInput($id("jdbc_c3p0_max_pool_size"))==false){
			return false;
		}
 		if (checkInput($id("jdbc_c3p0_min_pool_size"))==false){
			return false;
		}
		if (f_check_naturalNumber($id("jdbc_c3p0_max_idle_time"))==false){
			return false;
		}
 		if (f_check_naturalNumber($id("jdbc_c3p0_idle_connection_test_period"))==false){
			return false;
		}
 		if (f_check_naturalNumber($id("jdbc_c3p0_max_statements"))==false){
			return false;
		}
 		if (f_check_naturalNumber($id("jdbc_c3p0_num_helper_threads"))==false){
			return false;
		}

		try{
			if(parseInt($id("jdbc_c3p0_pool_size").value)<1)
				return false;
		}catch(e){
			return false;
		}		
		try{
			if(parseInt($id("jdbc_c3p0_max_pool_size").value)<1)
				return false;
		}catch(e){
			return false;
		}		
		try{
			if(parseInt($id("jdbc_c3p0_min_pool_size").value)<1)
				return false;
		}catch(e){
			return false;
		}		
		try{
			if(parseInt($id("jdbc_c3p0_max_idle_time").value)<0)
				return false;
		}catch(e){
			return false;
		}
		try{
			if(parseInt($id("jdbc_c3p0_idle_connection_test_period").value)<0)
				return false;
		}catch(e){
			return false;
		}
		try{
			if(parseInt($id("jdbc_c3p0_max_statements").value)<0)
				return false;
		}catch(e){
			return false;
		}
		try{
			if(parseInt($id("jdbc_c3p0_num_helper_threads").value)<0)
				return false;
		}catch(e){
			return false;
		}
		
		if (isNull($id("jdbc_retryConnectCount").value)==true){
			f_alert_show_message($id("jdbc_retryConnectCount")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
 		if (f_check_integer($id("jdbc_retryConnectCount"))==false){
			return false;
		}
		if (isNull($id("jdbc_testConnectSql").value)==true){
			f_alert_show_message($id("jdbc_testConnectSql")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}		

		if(compare() == false){			
			return false;
		}		
		
		if(!f_check_integer($id("jdbc_retryConnectCount"))){
			return false;
		}
		if($id("jdbc_retryConnectCount").value<-1){
			f_alert_show_message($id("jdbc_retryConnectCount")," <b:message key="gov_alert.minInputValueCannotLessThan"/>-1<b:message key='gov_punctuation.period'/>");
			return false;
		}

	}
	else{
		if (isNull($id("jndialias_datasource").value)==true){
			f_alert_show_message($id("jndialias_datasource")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		if ($id("jndialias_datasource").value == uniqueJndiName) {
			f_alert_show_message($id("jndialias_datasource"),"<b:message key="addDatasource_jsp.pkDSCannotSameAsJNDIName"/>");
			return false;
		}
		if ($id("jndialias_transaction_isolation").value.length==0){
			f_alert_show_message($id("jndialias_transaction_isolation"),"<b:message key="gov_alert.pleaseSelectIsolationLevel"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
		if (isNull($id("jndialias_retryConnectCount").value)==true){
			f_alert_show_message($id("jndialias_retryConnectCount")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}
 		if (f_check_integer($id("jndialias_retryConnectCount"))==false){
			return false;
		}
		if (isNull($id("jndialias_testConnectSql").value)==true){
			f_alert_show_message($id("jndialias_testConnectSql")," <b:message key="gov_alert.isRequiredItem"/><b:message key='gov_punctuation.period'/>");
			return false;
		}

		if(!f_check_integer($id("jndialias_retryConnectCount"))){
			return false;
		}
		if($id("jndialias_retryConnectCount").value<-1){
			f_alert_show_message($id("jndialias_retryConnectCount")," <b:message key="gov_alert.minInputValueCannotLessThan"/>-1<b:message key='gov_punctuation.period'/>");
			return false;
		}
		
		
	}
		if (flag){
			var str = confirmDSConn();
			var code = str;
			if (str == "" || str=="100")
				str ="<b:message key="gov_alert.dbConnectionSuccess"/>";
			else
				str = str+" ";
				
            if(code == "" || code=="100"){
                 if(confirm(str+" <b:message key="gov_confirm.addDataSource"/>")) {
                        $id("mgrForm").submit();
                   }
             }else{
                  alert(str);
             }
          
          
		}
		else{
			var str = confirmDSConn();
			if (str == "" || str=="100")
				str ="<b:message key="gov_alert.dbConnectionSuccess"/>";
			alert(str);
		}
}	

function confirmDSConn(){

		if($id("check_radio").checked){		

		var ajax = new HideSubmit("com.primeton.governor.management.DatabaseManager.validateJndiConn.biz");	
		ajax.addParam("ip","<b:write property='ip' />");
		ajax.addParam("port",'<b:write property="port" />');
		ajax.addParam("appName",'<b:write property="appName" />');	
		ajax.addParam("jndiName",$id("jndialias_datasource").value);
		
		var ioslation=-1;
		var jndi_isolation=$id("jndialias_transaction_isolation").value;
		if (jndi_isolation == ""){
		}else if (jndi_isolation == "ISOLATION_DEFAULT"){
			isolation = -1;
		}else if (jndi_isolation == "ISOLATION_READ_COMMITTED"){
			isolation = 2;
		}else if (jndi_isolation == "ISOLATION_READ_UNCOMMITTED"){
			isolation = 1;
		}else if (jndi_isolation == "ISOLATION_REPEATABLE_READ"){
			isolation = 4;
		}else if (jndi_isolation == "ISOLATION_SERIALIZABLE"){
			isolation = 8;
		}
		ajax.addParam("isolation",isolation);
		ajax.addParam("testConnSql",$id("jndialias_testConnectSql").value);
		
		ajax.onFailure=function (){};
		ajax.submit();
		
		return ajax.getProperty("resultMessage");	
		
		
		}else{

		var ajax = new HideSubmit("com.primeton.governor.management.DatabaseManager.validateC3p0Conn.biz");		
		ajax.addParam("ip","<b:write property='ip' />");
		ajax.addParam("port",'<b:write property="port" />');
		ajax.addParam("appName",'<b:write property="appName" />');
		ajax.addParam("driver",$id("jdbc_c3p0_driver_class").value);
		ajax.addParam("url",$id("jdbc_c3p0_url").value);
		ajax.addParam("user",$id("jdbc_c3p0_username").value);
		ajax.addParam("password",$id("jdbc_c3p0_password").value);	
		
		var isolation = -1;
		var jdbc_isolation = $id("jdbc_transaction_isolation").value;
		
		if (jdbc_isolation == ""){
		}else if (jdbc_isolation == "ISOLATION_DEFAULT"){
			isolation = -1;
		}else if (jdbc_isolation == "ISOLATION_READ_COMMITTED"){
			isolation = 2;
		}else if (jdbc_isolation == "ISOLATION_READ_UNCOMMITTED"){
			isolation = 1;
		}else if (jdbc_isolation == "ISOLATION_REPEATABLE_READ"){
			isolation = 4;
		}else if (jdbc_isolation == "ISOLATION_SERIALIZABLE"){
			isolation = 8;
		}
		
		ajax.addParam("isolation",isolation);
		ajax.addParam("testConnSql",$id("jdbc_testConnectSql").value);
		
		ajax.onFailure=function (){};
		ajax.submit();
				
		return ajax.getProperty("resultMessage");		
		
		}
}


function validateDSConn(){
	if (chckFrm(false)) return ;
}
function addCancel(){
	$id("mgrForm").action="com.primeton.governor.dataSourceConfig.flow?_eosFlowAction=actStart";
	$id("mgrForm").submit();
}

function internalAllHiddenMessage(){
	//f_alert_verify_successful($("groupName"));
	f_alert_hidden_message($("groupName"));
	f_alert_hidden_message($("jndialias_datasource"));
	f_alert_hidden_message($("jdbc_testConnectSql"));	
	f_alert_hidden_message($("jndialias_retryConnectCount"));
	f_alert_hidden_message($("jdbc_c3p0_driver_class"));
	f_alert_hidden_message($("jdbc_c3p0_url"));
	f_alert_hidden_message($("jdbc_c3p0_pool_size"));
	f_alert_hidden_message($("jdbc_c3p0_max_pool_size"));
	f_alert_hidden_message($("jdbc_retryConnectCount"));
	f_alert_hidden_message($("jdbc_testConnectSql"));	
	f_alert_hidden_message($("jdbc_c3p0_username"));	
	f_alert_hidden_message($("jdbc_c3p0_password"));	
}

</script>


