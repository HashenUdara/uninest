<%@ tag description="Student dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<c:set var="finalPageTitle" value="${not empty pageTitle ? pageTitle : 'Student Dashboard'}" />
<layout:dashboard title="${finalPageTitle}" pageTitle="${finalPageTitle}" breadcrumb="${breadcrumb}">
  <jsp:attribute name="navigation">
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/dashboard" 
      icon="home" 
      label="Dashboard" 
      active="${activePage eq 'dashboard' or empty activePage}" />
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/subjects" 
      icon="book" 
      label="My Subjects" 
      active="${activePage eq 'subjects'}" />
    <dash:nav-item 
      href="#" 
      icon="graduation-cap" 
      label="Kuppi Sessions" 
      active="${activePage eq 'kuppi'}" />
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/resources" 
      icon="file-text" 
      label="My Resources" 
      active="${activePage eq 'resources'}" />
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/progress-analysis" 
      icon="bar-chart-3" 
      label="Progress Analysis" 
      active="${activePage eq 'progress'}" />
    <dash:nav-item 
      href="${pageContext.request.contextPath}/student/community"
      icon="message-square" 
      label="Community" 
      active="${activePage eq 'community'}" />
    <dash:nav-item 
      href="#" 
      icon="user" 
      label="Profile Settings" 
      active="${activePage eq 'profile'}" />
    
    <%-- Subject Coordinator section - only show if user is a coordinator --%>
    <c:if test="${sessionScope.isCoordinator}">
      <div class="c-nav__divider"></div>
      <div class="c-nav__label">Subject Coordinator</div>
      <dash:nav-group 
        icon="check-square" 
        label="Resource Approvals" 
        groupId="resource-approvals"
        active="${activePage eq 'resource-approvals'}">
        <dash:nav-subitem 
          href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=new" 
          label="New Uploads" 
          active="${activePage eq 'resource-approvals' and (param.tab eq 'new' or empty param.tab)}" />
        <dash:nav-subitem 
          href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=edits" 
          label="Edit Approvals" 
          active="${activePage eq 'resource-approvals' and param.tab eq 'edits'}" />
      </dash:nav-group>
    </c:if>
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
