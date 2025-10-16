<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:page title="Manage Organizations" active="admin">
  <jsp:body>
    <h1>Manage Organizations</h1>
    <p>Welcome, <strong>${sessionScope.authUser.email}</strong> (role: ${sessionScope.authUser.role})</p>
    
    <div style="margin-top: 2rem;">
      <h2>Pending Approvals</h2>
      <c:choose>
        <c:when test="${empty organizations}">
          <p>No organizations found.</p>
        </c:when>
        <c:otherwise>
          <table style="width: 100%; border-collapse: collapse; margin-top: 1rem;">
            <thead>
              <tr style="background-color: #f5f5f5; text-align: left;">
                <th style="padding: 0.75rem; border: 1px solid #ddd;">ID</th>
                <th style="padding: 0.75rem; border: 1px solid #ddd;">Title</th>
                <th style="padding: 0.75rem; border: 1px solid #ddd;">Description</th>
                <th style="padding: 0.75rem; border: 1px solid #ddd;">Status</th>
                <th style="padding: 0.75rem; border: 1px solid #ddd;">Created</th>
                <th style="padding: 0.75rem; border: 1px solid #ddd;">Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="org" items="${organizations}">
                <tr>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;">${org.id}</td>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;"><strong>${org.title}</strong></td>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;">${org.description}</td>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;">
                    <c:choose>
                      <c:when test="${org.status == 'pending'}">
                        <span style="color: orange; font-weight: bold;">⏳ Pending</span>
                      </c:when>
                      <c:when test="${org.status == 'approved'}">
                        <span style="color: green; font-weight: bold;">✓ Approved</span>
                      </c:when>
                      <c:when test="${org.status == 'rejected'}">
                        <span style="color: red; font-weight: bold;">✗ Rejected</span>
                      </c:when>
                    </c:choose>
                  </td>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;">${org.createdAt}</td>
                  <td style="padding: 0.75rem; border: 1px solid #ddd;">
                    <c:if test="${org.status == 'pending'}">
                      <form method="post" style="display: inline;">
                        <input type="hidden" name="orgId" value="${org.id}"/>
                        <input type="hidden" name="action" value="approve"/>
                        <button type="submit" class="btn" style="background-color: #28a745; color: white; padding: 0.5rem 1rem; border: none; border-radius: 4px; cursor: pointer; margin-right: 0.5rem;">Approve</button>
                      </form>
                      <form method="post" style="display: inline;">
                        <input type="hidden" name="orgId" value="${org.id}"/>
                        <input type="hidden" name="action" value="reject"/>
                        <button type="submit" class="btn" style="background-color: #dc3545; color: white; padding: 0.5rem 1rem; border: none; border-radius: 4px; cursor: pointer;">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${org.status != 'pending'}">
                      <span style="color: #666;">-</span>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
    
    <div style="margin-top: 2rem;">
      <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard" style="display: inline-block; padding: 0.75rem 1.5rem; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px;">Back to Dashboard</a>
    </div>
  </jsp:body>
</layout:page>
