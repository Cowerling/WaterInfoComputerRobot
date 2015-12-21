<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>水情信息</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
	-->
	<style type="text/css">
		body {
			text-align:center
		}
	
		table.gridtable {
			font-family: verdana,arial,sans-serif;
			font-size:11px;
			color:#333333;
			border-width: 1px;
			border-color: #666666;
			border-collapse: collapse;
			margin:0 auto;
		}
		
		table.gridtable caption {
			font-weight: bold;
			font-size:20px;
			padding: 3px;
		}
		
		table.gridtable th.river {
			border-width: 1px;
			padding: 8px;
			border-style: solid;
			border-color: #666666;
			background-color: #87ceeb;
		}
		
		table.gridtable th.reservoir {
			border-width: 1px;
			padding: 8px;
			border-style: solid;
			border-color: #666666;
			background-color: #bdfcc9;
		}
		
		table.gridtable td {
			border-width: 1px;
			padding: 8px;
			border-style: solid;
			border-color: #666666;
			background-color: #ffffff;
		}
	</style>
	
	<%@ page language="java" import="java.util.*" %>
	<%@ page language="java" import="java.util.regex.*" %>
	<%@ page language="java" import="org.apache.http.impl.client.*" %>
	<%@ page language="java" import="org.apache.http.*" %>
	<%@ page language="java" import="org.apache.http.client.config.*" %>
	<%@ page language="java" import="org.apache.http.client.methods.*" %>
	<%@ page language="java" import="org.apache.http.client.entity.*" %>
	<%@ page language="java" import="org.apache.http.util.*" %>
	<%@ page language="java" import="org.apache.http.message.*" %>
	<%@ page language="java" import="water.*" %>
	
	
	<%!
	public String getWebContext(String address, String charsetName) {
  		try{
  			CloseableHttpClient httpClient = HttpClientBuilder.create().build();
  			RequestConfig requestConfig = RequestConfig.custom().setConnectionRequestTimeout(5000).setConnectTimeout(5000).setSocketTimeout(5000).build();
  			
  			HttpGet httpGet = new HttpGet(address);
  			httpGet.setConfig(requestConfig);
            HttpResponse httpResponse = httpClient.execute(httpGet);
            
            String html = charsetName == null ? EntityUtils.toString(httpResponse.getEntity()) : EntityUtils.toString(httpResponse.getEntity(), charsetName);
            
            return html;
        }
        catch(Exception e){
            return null;
        }
  	}
  	
  	public List<String> regexStrings(String targetString, String patternString) {
  		List<String> results = new ArrayList<String>();
  		
  		Pattern pattern = Pattern.compile(patternString);
		Matcher matcher = pattern.matcher(targetString);
		boolean isFind = matcher.find();
		while (isFind) {
			results.add(matcher.group(1));
			isFind = matcher.find();
		}
  		
  		return results;
  	}
  	
  	public String regexString(String targetString, String patternString) {
  		
  		Pattern pattern = Pattern.compile(patternString);
		Matcher matcher = pattern.matcher(targetString);
		
		if(matcher.find()) {
			return matcher.group(1);
		} else {
			return null;
		}
  	}
	 %>

  </head>
  
  <body> 
  	<div id="container">
  		<table id="table" class="gridtable">
			<caption>河 道 水 情</caption>
			<tr>
				<th class="river">河名</th>
				<th class="river">站址</th>
				<th class="river">水位</th>
				<th class="river">警戒水位</th>
				<th class="river">保证水位</th>
				<th class="river">超警水位</th>
				<th class="river">超保水位</th>
				<th class="river">水势</th>
			</tr>
			
			<%
			String riverUrl = "http://www.scsqzx.com/newApp/pub/scw/Query/GetHDriver.srdbselect";
		    String riverWebContext = getWebContext(riverUrl, "utf-8");
		    String riverFilter = "雅砻江";
		    if(riverWebContext != null) {
		    	String dataPatternString = "<Data>(.+?)<";
		    	String data = regexString(riverWebContext, dataPatternString);
		    	
		    	if(data != null) {
		    		List<SCRiverInfo> riverInfos = new ArrayList<SCRiverInfo>();
		    	
		    		String[] subDatas = data.split(",");
		    		for(String subData : subDatas) {
		    			String[] attributes = subData.split("\\|");
		    			if(attributes.length != 11)
		    				continue;
		    			
		    			riverInfos.add(new SCRiverInfo(attributes[0], 
		    											attributes[1], 
		    											attributes[2], 
		    											attributes[3], 
		    											attributes[4], 
		    											attributes[5], 
		    											attributes[6], 
		    											attributes[7], 
		    											attributes[8], 
		    											attributes[9],
		    											attributes[10]));
		    		}
		    		
		    		for(SCRiverInfo riverInfo : riverInfos)
		    			if(riverInfo.HNNM.contains(riverFilter))
		    				out.println("<tr>" +
										"<td>" + riverInfo.RVNM + "</td>" + 
										"<td>" + riverInfo.STLC + "</td>" + 
										"<td>" + riverInfo.Z + "</td>" + 
										"<td>" + riverInfo.WRZ + "</td>" + 
										"<td>" + riverInfo.GRZ + "</td>" + 
										"<td>" + riverInfo.CWRZ + "</td>" + 
										"<td>" + riverInfo.CGRZ + "</td>" + 
										"<td>" + riverInfo.WPTN + "</td>" + 
									"</tr>");
		    	}
		    }
			 %>
		</table>
		
		<table id="table" class="gridtable">
			<caption>水 库 水 情</caption>
			<tr>
				<th class="reservoir">河名</th>
				<th class="reservoir">站址</th>
				<th class="reservoir">库水位</th>
				<th class="reservoir">入库流量</th>
				<th class="reservoir">出库流量</th>
				<th class="reservoir">蓄水量</th>
				<th class="reservoir">超汛限</th>
				<th class="reservoir">超校核</th>
				<th class="reservoir">水势</th>
			</tr>
			
			<%
			String reservoirUrl = "http://www.scsqzx.com/newApp/pub/scw/Query/GetDZXsq.srdbselect";
		    String reservoirWebContext = getWebContext(reservoirUrl, "utf-8");
		    String reservoirFilter = "雅砻江";
		    if(reservoirWebContext != null) {
		    	String dataPatternString = "<Data>(.+?)<";
		    	String data = regexString(reservoirWebContext, dataPatternString);
		    	
		    	if(data != null) {
		    		List<SCReservoirInfo> reservoirInfos = new ArrayList<SCReservoirInfo>();
		    	
		    		String[] subDatas = data.split(",");
		    		for(String subData : subDatas) {
		    			String[] attributes = subData.split("\\|");
		    			if(attributes.length != 12)
		    				continue;
		    			
		    			reservoirInfos.add(new SCReservoirInfo(attributes[0], 
			    										   attributes[1], 
			    									 	   attributes[2], 
			    										   attributes[3], 
			    										   attributes[4], 
			    										   attributes[5], 
			    										   attributes[6], 
			    										   attributes[7], 
			    										   attributes[8], 
			    										   attributes[9],
			    										   attributes[10],
			    										   attributes[11]));
		    		}
		    		
		    		for(SCReservoirInfo reservoirInfo : reservoirInfos)
		    			if(reservoirInfo.HNNM.contains(reservoirFilter))
		    				out.println("<tr>" +
										"<td>" + reservoirInfo.RVNM + "</td>" + 
										"<td>" + reservoirInfo.STLC + "</td>" + 
										"<td>" + reservoirInfo.RZ + "</td>" + 
										"<td>" + reservoirInfo.INQ + "</td>" + 
										"<td>" + reservoirInfo.OTQ + "</td>" + 
										"<td>" + reservoirInfo.W + "</td>" + 
										"<td>" + reservoirInfo.CFSLTDZ + "</td>" + 
										"<td>" + reservoirInfo.CCKFLZ + "</td>" + 
										"<td>" + reservoirInfo.RWPTNNM + "</td>" + 
									"</tr>");
		    	}
		    }
			 %>
		</table>
  	</div>
  	
  	<script type="text/javascript" src="./EventUtil.js"></script>
  	<script type="text/javascript">
  		function loadImage(url) {
  			var image = new Image();
  			image.src = url;
  			
  			var originImageWidth;
  			EventUtil.addHandler(window, "resize", function(event) {
  				image.width = originImageWidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : originImageWidth;
  			});
  			
  			var container = document.getElementById("container");
  			
  			if(image.complete) {
  				originImageWidth = image.width;
  				container.appendChild(image);
  			} else {
  				EventUtil.addHandler(image, "load", function(event) {
  					originImageWidth = image.width;
  					container.appendChild(image);
  				});
  			}
  		}
  		
  		var date = new Date();
  		var url = "http://www.scsqzx.com/newApp/pub/scw/images/" + date.getFullYear() + (date.getMonth() + 1) + (date.getDate() < 10 ? "0" + date.getDate() : date.getDate()) + ".jpg";
  		loadImage(url);
  	</script>
  </body>
</html>
