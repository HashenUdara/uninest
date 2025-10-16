<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:modern-dashboard title="Moderator Dashboard" pageTitle="Moderator Dashboard">
  <jsp:attribute name="name">
    <dash:nav-item href="${pageContext.request.contextPath}/moderator/dashboard" icon="home" label="Dashboard" active="${true}" />
    <dash:nav-item href="#" icon="shield" label="Content Review" active="${false}" />
    <dash:nav-item href="#" icon="flag" label="Reported Content" active="${false}" />
    <dash:nav-item href="#" icon="users" label="User Management" active="${false}" />
    <dash:nav-item href="#" icon="activity" label="Activity Logs" active="${false}" />
    <dash:nav-item href="#" icon="settings" label="Settings" active="${false}" />
  </jsp:attribute>
  <jsp:attribute name="content">
    <h2 class="c-section-title">Welcome, ${sessionScope.authUser.email}</h2>
    <p>As a moderator, you can review, edit, or remove inappropriate resources.</p>
    
    <h2 class="c-section-title">Moderation Overview</h2>
    <div class="o-grid o-grid--cards">
      <dash:card title="Pending Reviews" meta="15 items awaiting review" />
      <dash:card title="Reported Content" meta="3 new reports" />
      <dash:card title="Approved Today" meta="28 resources approved" />
      <dash:card title="Rejected Items" meta="5 items rejected" />
    </div>
  </jsp:attribute>
</layout:modern-dashboard>
