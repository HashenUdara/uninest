<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:moderator-dashboard pageTitle="Join Requests" activePage="join-requests">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/moderator/dashboard">Moderator</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Join Requests</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Join Requests</h1>
          <p class="c-page__subtitle u-text-muted">
            <c:choose>
              <c:when test="${currentStatus == 'pending'}">Review and manage student join requests.</c:when>
              <c:when test="${currentStatus == 'approved'}">Approved join requests.</c:when>
              <c:when test="${currentStatus == 'rejected'}">Rejected join requests.</c:when>
            </c:choose>
          </p>
        </div>
      </div>
      <div class="c-tabs" role="tablist" aria-label="Join request tabs">
        <a href="${pageContext.request.contextPath}/moderator/join-requests?status=pending" 
           class="c-tabs__link ${currentStatus == 'pending' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'pending' ? 'true' : 'false'}">Pending</a>
        <a href="${pageContext.request.contextPath}/moderator/join-requests?status=approved" 
           class="c-tabs__link ${currentStatus == 'approved' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'approved' ? 'true' : 'false'}">Accepted</a>
        <a href="${pageContext.request.contextPath}/moderator/join-requests?status=rejected" 
           class="c-tabs__link ${currentStatus == 'rejected' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'rejected' ? 'true' : 'false'}">Rejected</a>
      </div>
    </header>

    <section>
      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <span class="u-text-muted">
            <span class="js-req-count">${requests.size()}</span> requests
          </span>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table c-table--sticky" aria-label="${currentStatus} join requests" data-req-table>
          <thead>
            <tr>
              <th>Student</th>
              <th>Email</th>
              <th>Academic Year</th>
              <th>University</th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${requests}" var="req">
              <tr>
                <td>
                  <div class="c-comm-cell">
                    <span class="c-comm-cell__avatar" aria-hidden="true"></span>
                    <div class="c-comm-cell__meta">
                      <span class="c-comm-cell__title">${req.userName}</span>
                      <span class="c-comm-cell__sub u-text-muted">ID: ${req.userId}</span>
                    </div>
                  </div>
                </td>
                <td>${req.userEmail}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty req.userAcademicYear}">Year ${req.userAcademicYear}</c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${not empty req.universityName}">${req.universityName}</c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>
                <td class="u-text-right">
                  <div class="c-table-actions">
                    <c:if test="${currentStatus == 'pending'}">
                      <form method="post" action="${pageContext.request.contextPath}/moderator/join-requests/approve" style="display:inline" class="js-req-approve">
                        <input type="hidden" name="id" value="${req.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                      <form method="post" action="${pageContext.request.contextPath}/moderator/join-requests/reject" style="display:inline" class="js-req-reject">
                        <input type="hidden" name="id" value="${req.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'approved'}">
                      <form method="post" action="${pageContext.request.contextPath}/moderator/join-requests/reject" style="display:inline" class="js-req-reject">
                        <input type="hidden" name="id" value="${req.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'rejected'}">
                      <form method="post" action="${pageContext.request.contextPath}/moderator/join-requests/approve" style="display:inline" class="js-req-approve">
                        <input type="hidden" name="id" value="${req.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Confirm Modal -->
    <div class="c-modal" id="confirm-modal" role="dialog" aria-modal="true" aria-labelledby="confirm-title" hidden>
      <div class="c-modal__backdrop" data-close></div>
      <div class="c-modal__dialog">
        <div class="c-modal__header">
          <h3 id="confirm-title">Confirm</h3>
        </div>
        <div class="c-modal__body">
          <p>Are you sure?</p>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" data-close>Cancel</button>
          <button class="c-btn c-btn--danger js-confirm-action">Confirm</button>
        </div>
      </div>
    </div>

    <div class="c-toasts" aria-live="polite" aria-atomic="true"></div>
</layout:moderator-dashboard>
