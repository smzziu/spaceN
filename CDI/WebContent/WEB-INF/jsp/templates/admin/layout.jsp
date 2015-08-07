<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title><tiles:getAsString name="title"/></title>
<tiles:insertAttribute name="include" />
</head> 
<body> 
<div id="wrap"> 
	<div id="top">
		<tiles:insertAttribute name="header" />
	</div>
	<div id="left">
		<tiles:insertAttribute name="sidemenu" />
	</div>
	<tiles:insertAttribute name="content" />
</div>
</body> 
</html>