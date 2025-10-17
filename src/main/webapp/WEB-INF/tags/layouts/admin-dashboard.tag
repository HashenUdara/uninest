<%@ tag description="Admin dashboard layout with reusable sidebar" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="breadcrumb" required="false" %>
<%@ attribute name="alerts" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%@ attribute name="content" fragment="true" required="false" %>
<%@ attribute name="active" required="false" %>

<c:set var="activeKey" value="${empty active ? '' : active}" />

<layout:dashboard title="${title}" pageTitle="${pageTitle}" breadcrumb="${breadcrumb}">
  <jsp:attribute name="content">
    <jsp:invoke fragment="content" />
  </jsp:attribute>
  <jsp:body>
    <dash:nav-item href="${pageContext.request.contextPath}/admin/dashboard" icon="home" label="Dashboard" active="${activeKey == 'dashboard'}" />
    <dash:nav-item href="${pageContext.request.contextPath}/students" icon="users" label="Manage Students" active="${activeKey == 'students'}" />
    <dash:nav-item href="${pageContext.request.contextPath}/admin/organizations" icon="building" label="Organizations" active="${activeKey == 'organizations'}" />
    <dash:nav-item href="#" icon="settings" label="Settings" active="${activeKey == 'settings'}" />
  </jsp:body>
</layout:dashboard>
