<%@ tag description="Coordinator dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<c:set var="finalPageTitle" value="${not empty pageTitle ? pageTitle : 'Coordinator Dashboard'}" />
<layout:dashboard title="${finalPageTitle}" pageTitle="${finalPageTitle}" breadcrumb="${breadcrumb}">
  <jsp:attribute name="navigation">
    <dash:nav-item 
      href="${pageContext.request.contextPath}/subject-coordinator/dashboard" 
      icon="home" 
      label="Dashboard" 
      active="${activePage eq 'dashboard' or empty activePage}" />
    <dash:nav-item 
      href="#" 
      icon="book-open" 
      label="My Subjects" 
      active="${activePage eq 'subjects'}" />
    <dash:nav-item 
      href="#" 
      icon="folder" 
      label="Topics" 
      active="${activePage eq 'topics'}" />
    <dash:nav-item 
      href="#" 
      icon="upload" 
      label="Upload Resources" 
      active="${activePage eq 'upload'}" />
    <dash:nav-item 
      href="#" 
      icon="bar-chart" 
      label="Analytics" 
      active="${activePage eq 'analytics'}" />
    <dash:nav-item 
      href="#" 
      icon="settings" 
      label="Settings" 
      active="${activePage eq 'settings'}" />
  </jsp:attribute>
  <jsp:attribute name="alerts">
    <c:if test="${not empty alerts}">
      <jsp:invoke fragment="alerts" />
    </c:if>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <c:if test="${not empty scripts}">
      <jsp:invoke fragment="scripts" />
    </c:if>
  </jsp:attribute>
  <jsp:body>
    <jsp:doBody />
  </jsp:body>
</layout:dashboard>
