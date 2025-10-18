<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:admin-dashboard pageTitle="Communities" activePage="communities">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Communities</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Communities</h1>
          <p class="c-page__subtitle u-text-muted">
            <c:choose>
              <c:when test="${currentStatus == 'pending'}">Review and manage community requests.</c:when>
              <c:when test="${currentStatus == 'approved'}">Approved communities.</c:when>
              <c:when test="${currentStatus == 'rejected'}">Rejected communities.</c:when>
            </c:choose>
          </p>
        </div>
        <a class="c-btn" href="${pageContext.request.contextPath}/admin/communities/create">
          <i data-lucide="plus"></i> Create Community
        </a>
      </div>
      <div class="c-tabs" role="tablist" aria-label="Community tabs">
        <a href="${pageContext.request.contextPath}/admin/communities?status=pending" 
           class="c-tabs__link ${currentStatus == 'pending' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'pending' ? 'true' : 'false'}">Pending</a>
        <a href="${pageContext.request.contextPath}/admin/communities?status=approved" 
           class="c-tabs__link ${currentStatus == 'approved' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'approved' ? 'true' : 'false'}">Accepted</a>
        <a href="${pageContext.request.contextPath}/admin/communities?status=rejected" 
           class="c-tabs__link ${currentStatus == 'rejected' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'rejected' ? 'true' : 'false'}">Rejected</a>
      </div>
    </header>

    <section>
      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <span class="u-text-muted">
            <span class="js-comm-count">${communities.size()}</span> communities
          </span>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table c-table--sticky" aria-label="${currentStatus} communities" data-comm-table>
          <thead>
            <tr>
              <th>Community</th>
              <th>Description</th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${communities}" var="o">
              <tr>
                <td>
                  <div class="c-comm-cell">
                    <span class="c-comm-cell__avatar" aria-hidden="true"></span>
                    <div class="c-comm-cell__meta">
                      <span class="c-comm-cell__title">${o.title}</span>
                      <span class="c-comm-cell__sub u-text-muted">ID: C-${o.id}</span>
                    </div>
                  </div>
                </td>
                <td>
                  <div class="u-clamp-2">${o.description}</div>
                </td>
                <td class="u-text-right">
                  <div class="c-table-actions">
                    <c:if test="${currentStatus == 'pending'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/communities/approve" style="display:inline" class="js-comm-approve">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                      <form method="post" action="${pageContext.request.contextPath}/admin/communities/reject" style="display:inline" class="js-comm-reject">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'approved'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/communities/reject" style="display:inline" class="js-comm-reject">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'rejected'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/communities/approve" style="display:inline" class="js-comm-approve">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                    </c:if>
                    <a class="c-icon-btn" aria-label="Edit" href="${pageContext.request.contextPath}/admin/communities/edit?id=${o.id}">
                      <i data-lucide="pencil"></i>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/communities/delete" style="display:inline" class="js-comm-delete">
                      <input type="hidden" name="id" value="${o.id}" />
                      <input type="hidden" name="status" value="${currentStatus}" />
                      <button class="c-icon-btn" type="submit" aria-label="Delete">
                        <i data-lucide="trash"></i>
                      </button>
                    </form>
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
</layout:admin-dashboard>
