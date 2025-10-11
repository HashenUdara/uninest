<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Error" active="">
	<jsp:body>
		<h2>Error</h2>
		<p>${message}</p>
		<p><a class="btn" href="${pageContext.request.contextPath}/students">Back to list</a></p>
	</jsp:body>
</layout:page>
