<%@ tag description="Moderator dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<c:set var="finalPageTitle" value="${not empty pageTitle ? pageTitle : 'Moderator Dashboard'}" />
<layout:dashboard title="${finalPageTitle}" pageTitle="${finalPageTitle}" breadcrumb="${breadcrumb}">
  <jsp:attribute name="navigation">
    <dash:nav-item 
      href="${pageContext.request.contextPath}/moderator/dashboard" 
      icon="home" 
      label="Overview" 
      active="${activePage eq 'dashboard' or empty activePage}" />
    <dash:nav-group 
      icon="users" 
      label="Student Management" 
      groupId="student-mgmt"
      active="${activePage eq 'join-requests' or activePage eq 'students'}">
      <dash:nav-subitem 
        href="${pageContext.request.contextPath}/moderator/join-requests" 
        label="Join Requests" 
        active="${activePage eq 'join-requests'}" />
      <dash:nav-subitem 
        href="${pageContext.request.contextPath}/moderator/students" 
        label="Students" 
        active="${activePage eq 'students'}" />
    </dash:nav-group>
    <dash:nav-item 
      href="#" 
      icon="shield" 
      label="Content Review" 
      active="${activePage eq 'review'}" />
    <dash:nav-item 
      href="#" 
      icon="flag" 
      label="Reported Content" 
      active="${activePage eq 'reported'}" />
    <dash:nav-item 
      href="#" 
      icon="activity" 
      label="Activity Logs" 
      active="${activePage eq 'logs'}" />
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
