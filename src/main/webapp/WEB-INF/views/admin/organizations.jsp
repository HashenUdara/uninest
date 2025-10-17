<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:dashboard title="Organizations">
  <jsp:attribute name="content">
    <header class="c-page__header">
      <nav class="c-breadcrumbs" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
        <span class="c-breadcrumbs__sep">/</span>
        <span aria-current="page">Organizations</span>
      </nav>
      <div class="c-page__titlebar">
        <div>
          <h1 class="c-page__title">Organizations</h1>
          <p class="c-page__subtitle u-text-muted">
            <c:choose>
              <c:when test="${currentStatus == 'pending'}">Review and manage organization requests.</c:when>
              <c:when test="${currentStatus == 'approved'}">Approved organizations.</c:when>
              <c:when test="${currentStatus == 'rejected'}">Rejected organizations.</c:when>
            </c:choose>
          </p>
        </div>
        <a class="c-btn" href="${pageContext.request.contextPath}/admin/organizations/create">
          <i data-lucide="plus"></i> Create Organization
        </a>
      </div>
      <div class="c-tabs" role="tablist" aria-label="Organization tabs">
        <a href="${pageContext.request.contextPath}/admin/organizations?status=pending" 
           class="c-tabs__link ${currentStatus == 'pending' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'pending' ? 'true' : 'false'}">Pending</a>
        <a href="${pageContext.request.contextPath}/admin/organizations?status=approved" 
           class="c-tabs__link ${currentStatus == 'approved' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'approved' ? 'true' : 'false'}">Accepted</a>
        <a href="${pageContext.request.contextPath}/admin/organizations?status=rejected" 
           class="c-tabs__link ${currentStatus == 'rejected' ? 'is-active' : ''}" 
           role="tab" 
           aria-selected="${currentStatus == 'rejected' ? 'true' : 'false'}">Rejected</a>
      </div>
    </header>

    <section>
      <div class="c-table-toolbar">
        <div class="c-table-toolbar__left">
          <span class="u-text-muted">
            <span class="js-org-count">${organizations.size()}</span> organizations
          </span>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table c-table--sticky" aria-label="${currentStatus} organizations" data-org-table>
          <thead>
            <tr>
              <th>Organization</th>
              <th>Description</th>
              <th class="u-text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${organizations}" var="o">
              <tr>
                <td>
                  <div class="c-org-cell">
                    <span class="c-org-cell__avatar" aria-hidden="true"></span>
                    <div class="c-org-cell__meta">
                      <span class="c-org-cell__title">${o.title}</span>
                      <span class="c-org-cell__sub u-text-muted">ID: O-${o.id}</span>
                    </div>
                  </div>
                </td>
                <td>
                  <div class="u-clamp-2">${o.description}</div>
                </td>
                <td class="u-text-right">
                  <div class="c-table-actions">
                    <c:if test="${currentStatus == 'pending'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/organizations/approve" style="display:inline" class="js-org-approve">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                      <form method="post" action="${pageContext.request.contextPath}/admin/organizations/reject" style="display:inline" class="js-org-reject">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'approved'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/organizations/reject" style="display:inline" class="js-org-reject">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Reject">Reject</button>
                      </form>
                    </c:if>
                    <c:if test="${currentStatus == 'rejected'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/organizations/approve" style="display:inline" class="js-org-approve">
                        <input type="hidden" name="id" value="${o.id}" />
                        <button class="c-btn c-btn--sm" type="submit" aria-label="Approve">Approve</button>
                      </form>
                    </c:if>
                    <a class="c-icon-btn" aria-label="Edit" href="${pageContext.request.contextPath}/admin/organizations/edit?id=${o.id}">
                      <i data-lucide="pencil"></i>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/organizations/delete" style="display:inline" class="js-org-delete">
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
  </jsp:attribute>
  <jsp:body>
    <dash:nav-item href="${pageContext.request.contextPath}/admin/dashboard" icon="home" label="Dashboard" />
    <dash:nav-item href="${pageContext.request.contextPath}/students" icon="users" label="Manage Students" />
    <dash:nav-item href="${pageContext.request.contextPath}/admin/organizations" icon="building" label="Organizations" active="${true}" />
    <dash:nav-item href="#" icon="settings" label="Settings" />
  </jsp:body>
</layout:dashboard>
