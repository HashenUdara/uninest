<%@ page contentType="text/html;charset=UTF-8" %>
<c:set var="pageTitle" value="Error" />
<jsp:include page="fragments/header.jspf" />
<h2>Error</h2>
<p>${message}</p>
<a href="${pageContext.request.contextPath}/students">Back to list</a>
<jsp:include page="fragments/footer.jspf" />
