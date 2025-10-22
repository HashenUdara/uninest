<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>
<layout:student-dashboard activePage="dashboard">
  <dash:section title="Welcome, ${sessionScope.authUser.name}">
    <p>Access your subjects, resources, and track your learning progress.</p>
  </dash:section>
  
  <%-- Pending Requests Section --%>
  <c:if test="${not empty pendingNewUploads or not empty pendingEdits}">
    <dash:section title="Pending Requests">
      <p class="u-text-muted">Resources awaiting approval from coordinators</p>
      
      <%-- Pending New Uploads --%>
      <c:if test="${not empty pendingNewUploads}">
        <div style="margin-top: var(--space-4);">
          <h3 style="font-size: var(--fs-md); font-weight: var(--fw-semibold); margin-bottom: var(--space-3);">
            New Uploads (${pendingNewUploads.size()})
          </h3>
          <div class="c-table-wrap">
            <table class="c-table" aria-label="Pending new uploads">
              <thead>
                <tr>
                  <th>Resource</th>
                  <th>Subject</th>
                  <th>Topic</th>
                  <th>Category</th>
                  <th>Upload Date</th>
                  <th class="u-text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach items="${pendingNewUploads}" var="res">
                  <tr>
                    <td>
                      <div class="c-comm-cell">
                        <span class="c-comm-cell__avatar" aria-hidden="true">
                          <i data-lucide="file-text"></i>
                        </span>
                        <div class="c-comm-cell__meta">
                          <span class="c-comm-cell__title">${res.title}</span>
                          <c:if test="${not empty res.description}">
                            <span class="c-comm-cell__sub u-text-muted">${res.description}</span>
                          </c:if>
                        </div>
                      </div>
                    </td>
                    <td>${res.subjectCode}</td>
                    <td>${res.topicName}</td>
                    <td>${res.categoryName}</td>
                    <td><fmt:formatDate value="${res.uploadDate}" pattern="MMM dd, yyyy" /></td>
                    <td class="u-text-right">
                      <a href="${pageContext.request.contextPath}/student/resources/${res.resourceId}" 
                         class="c-btn c-btn--sm c-btn--ghost">
                        <i data-lucide="eye"></i> View
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </c:if>
      
      <%-- Pending Edits --%>
      <c:if test="${not empty pendingEdits}">
        <div style="margin-top: var(--space-4);">
          <h3 style="font-size: var(--fs-md); font-weight: var(--fw-semibold); margin-bottom: var(--space-3);">
            Edit Approvals (${pendingEdits.size()})
          </h3>
          <div class="c-table-wrap">
            <table class="c-table" aria-label="Pending edit approvals">
              <thead>
                <tr>
                  <th>Resource</th>
                  <th>Subject</th>
                  <th>Topic</th>
                  <th>Category</th>
                  <th>Edit Date</th>
                  <th>Version</th>
                  <th class="u-text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach items="${pendingEdits}" var="res">
                  <tr>
                    <td>
                      <div class="c-comm-cell">
                        <span class="c-comm-cell__avatar" aria-hidden="true">
                          <i data-lucide="edit"></i>
                        </span>
                        <div class="c-comm-cell__meta">
                          <span class="c-comm-cell__title">${res.title}</span>
                          <c:if test="${not empty res.description}">
                            <span class="c-comm-cell__sub u-text-muted">${res.description}</span>
                          </c:if>
                        </div>
                      </div>
                    </td>
                    <td>${res.subjectCode}</td>
                    <td>${res.topicName}</td>
                    <td>${res.categoryName}</td>
                    <td><fmt:formatDate value="${res.uploadDate}" pattern="MMM dd, yyyy" /></td>
                    <td><span class="c-badge c-badge--info">v${res.version}</span></td>
                    <td class="u-text-right">
                      <a href="${pageContext.request.contextPath}/student/resources/${res.resourceId}" 
                         class="c-btn c-btn--sm c-btn--ghost">
                        <i data-lucide="eye"></i> View
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </c:if>
    </dash:section>
  </c:if>
  
  <dash:section title="My Subjects">
    <dash:grid>
      <dash:card title="Data Structures" meta="CS204 - Dr. Evelyn Reed" />
      <dash:card title="Algorithms" meta="CS205 - Prof. Michael Chen" />
      <dash:card title="Database Systems" meta="CS301 - Dr. Sarah Wilson" />
      <dash:card title="Web Development" meta="CS320 - Prof. James Anderson" />
    </dash:grid>
  </dash:section>
  
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Initialize lucide icons
      if (window.lucide) {
        lucide.createIcons();
      }
    });
  </script>
</layout:student-dashboard>
