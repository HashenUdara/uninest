<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:dashboard title="Organizations" pageTitle="Organizations">
  <jsp:attribute name="content">
    <dash:section title="Organizations">
      <table class="c-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Creator</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${organizations}" var="o">
            <tr>
              <td>${o.id}</td>
              <td>${o.title}</td>
              <td>${o.description}</td>
              <td>${o.createdByUserId}</td>
              <td>
                <c:choose>
                  <c:when test="${o.approved}">Approved</c:when>
                  <c:otherwise>Pending</c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${!o.approved}">
                  <form method="post" action="${pageContext.request.contextPath}/admin/organizations/approve" style="display:inline">
                    <input type="hidden" name="id" value="${o.id}" />
                    <button class="c-btn" type="submit">Approve</button>
                  </form>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </dash:section>
  </jsp:attribute><jsp:body>
    <dash:nav-item href="${pageContext.request.contextPath}/admin/dashboard" icon="home" label="Dashboard" />
    <dash:nav-item href="${pageContext.request.contextPath}/students" icon="users" label="Manage Students" />
    <dash:nav-item href="${pageContext.request.contextPath}/admin/organizations" icon="building" label="Organizations" active="${true}" />
    <dash:nav-item href="#" icon="settings" label="Settings" />
  </jsp:body>
</layout:dashboard>
