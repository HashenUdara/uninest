<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Resource Approvals" activePage="resource-approvals">
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Resource Approvals</span>
        </nav>
        <div class="c-page__titlebar">
            <div>
                <h1 class="c-page__title">Resource Approvals</h1>
                <p class="c-page__subtitle u-text-muted">
                    Review and approve student resource submissions
                </p>
            </div>
        </div>
        
        <div class="c-tabs" role="tablist" aria-label="Approval types">
            <a href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=requests" 
               class="c-tabs__link ${activeTab eq 'requests' or empty activeTab ? 'is-active' : ''}" 
               role="tab">
                <i data-lucide="clock"></i> Requests
            </a>
            <a href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=approved" 
               class="c-tabs__link ${activeTab eq 'approved' ? 'is-active' : ''}" 
               role="tab">
                <i data-lucide="check-circle"></i> Approved
            </a>
            <a href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=rejected" 
               class="c-tabs__link ${activeTab eq 'rejected' ? 'is-active' : ''}" 
               role="tab">
                <i data-lucide="x-circle"></i> Rejected
            </a>
            <a href="${pageContext.request.contextPath}/subject-coordinator/resource-approvals?tab=edits" 
               class="c-tabs__link ${activeTab eq 'edits' ? 'is-active' : ''}" 
               role="tab">
                <i data-lucide="edit"></i> Edit Approvals
            </a>
        </div>
    </header>

    <c:if test="${param.success == 'approved'}">
        <div class="c-alert c-alert--success" role="alert">
            <p>Resource approved successfully!</p>
        </div>
    </c:if>
    
    <c:if test="${param.success == 'rejected'}">
        <div class="c-alert c-alert--success" role="alert">
            <p>Resource rejected successfully!</p>
        </div>
    </c:if>
    
    <c:if test="${param.delete == 'success'}">
        <div class="c-alert c-alert--success" role="alert">
            <p>Resource deleted successfully!</p>
        </div>
    </c:if>
    
    <c:if test="${param.error == 'failed'}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>Failed to process resource. Please try again.</p>
        </div>
    </c:if>
    
    <c:if test="${param.error == 'unauthorized'}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>You are not authorized to perform this action.</p>
        </div>
    </c:if>
    
    <c:if test="${param.error == 'notfound'}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>Resource not found.</p>
        </div>
    </c:if>
    
    <c:if test="${param.error == 'invalid'}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>Invalid request.</p>
        </div>
    </c:if>

    <section>
        <div class="c-table-toolbar">
            <div class="c-table-toolbar__left">
                <span class="u-text-muted">
                    ${resources.size()} 
                    <c:choose>
                        <c:when test="${activeTab eq 'approved'}">approved</c:when>
                        <c:when test="${activeTab eq 'rejected'}">rejected</c:when>
                        <c:when test="${activeTab eq 'edits'}">pending edit</c:when>
                        <c:otherwise>pending</c:otherwise>
                    </c:choose>
                    resource(s)
                </span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty resources}">
                <div class="c-empty-state">
                    <div class="c-empty-state__icon" aria-hidden="true">
                        <i data-lucide="check-circle"></i>
                    </div>
                    <h3 class="c-empty-state__title">
                        <c:choose>
                            <c:when test="${activeTab eq 'approved'}">No approved resources</c:when>
                            <c:when test="${activeTab eq 'rejected'}">No rejected resources</c:when>
                            <c:when test="${activeTab eq 'edits'}">All caught up!</c:when>
                            <c:otherwise>All caught up!</c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="c-empty-state__message">
                        <c:choose>
                            <c:when test="${activeTab eq 'approved'}">No resources have been approved yet.</c:when>
                            <c:when test="${activeTab eq 'rejected'}">No resources have been rejected yet.</c:when>
                            <c:when test="${activeTab eq 'edits'}">No pending edits to review at the moment.</c:when>
                            <c:otherwise>No pending requests to review at the moment.</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="c-table-wrap">
                    <table class="c-table c-table--sticky" aria-label="Resources">
                        <thead>
                            <tr>
                                <th>Resource</th>
                                <th>Subject</th>
                                <th>Topic</th>
                                <th>Category</th>
                                <th>Uploaded By</th>
                                <c:choose>
                                    <c:when test="${activeTab eq 'approved' or activeTab eq 'rejected'}">
                                        <th>Approval Date</th>
                                        <th>Approved By</th>
                                    </c:when>
                                    <c:otherwise>
                                        <th>Upload Date</th>
                                        <c:if test="${activeTab eq 'edits'}">
                                            <th>Version</th>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                                <th class="u-text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${resources}" var="res">
                                <tr data-resource-id="${res.resourceId}">
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
                                    <td>
                                        <div>
                                            <div class="c-comm-cell__title">${res.subjectCode}</div>
                                            <div class="u-text-muted">${res.subjectName}</div>
                                        </div>
                                    </td>
                                    <td>${res.topicName}</td>
                                    <td>${res.categoryName}</td>
                                    <td>
                                        <div>
                                            <div class="c-comm-cell__title">${res.uploaderName}</div>
                                            <div class="u-text-muted">${res.uploaderEmail}</div>
                                        </div>
                                    </td>
                                    <c:choose>
                                        <c:when test="${activeTab eq 'approved' or activeTab eq 'rejected'}">
                                            <td><fmt:formatDate value="${res.approvalDate}" pattern="MMM dd, yyyy HH:mm" /></td>
                                            <td>${res.approverName}</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td><fmt:formatDate value="${res.uploadDate}" pattern="MMM dd, yyyy HH:mm" /></td>
                                            <c:if test="${activeTab eq 'edits'}">
                                                <td>
                                                    <span class="c-badge c-badge--info">v${res.version}</span>
                                                </td>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                    <td class="u-text-right">
                                        <div class="c-table-actions">
                                            <c:if test="${res.fileType != 'link'}">
                                                <a href="${pageContext.request.contextPath}/${res.fileUrl}" 
                                                   class="c-btn c-btn--sm c-btn--ghost" 
                                                   target="_blank" 
                                                   aria-label="Preview">
                                                    <i data-lucide="eye"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${res.fileType == 'link'}">
                                                <a href="${res.fileUrl}" 
                                                   class="c-btn c-btn--sm c-btn--ghost" 
                                                   target="_blank" 
                                                   aria-label="Open Link">
                                                    <i data-lucide="external-link"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${activeTab eq 'requests' or activeTab eq 'edits'}">
                                                <form method="post" 
                                                      action="${pageContext.request.contextPath}/subject-coordinator/resource-approvals/approve" 
                                                      style="display:inline">
                                                    <input type="hidden" name="resourceId" value="${res.resourceId}" />
                                                    <button class="c-btn c-btn--sm c-btn--success" type="submit" aria-label="Approve">
                                                        <i data-lucide="check"></i> Approve
                                                    </button>
                                                </form>
                                                <form method="post" 
                                                      action="${pageContext.request.contextPath}/subject-coordinator/resource-approvals/reject" 
                                                      style="display:inline">
                                                    <input type="hidden" name="resourceId" value="${res.resourceId}" />
                                                    <button class="c-btn c-btn--sm c-btn--danger" type="submit" aria-label="Reject">
                                                        <i data-lucide="x"></i> Reject
                                                    </button>
                                                </form>
                                            </c:if>
                                            <form method="post" 
                                                  action="${pageContext.request.contextPath}/subject-coordinator/resource-approvals/delete" 
                                                  style="display:inline"
                                                  onsubmit="return confirm('Are you sure you want to delete this resource? This action cannot be undone.');">
                                                <input type="hidden" name="resourceId" value="${res.resourceId}" />
                                                <button class="c-btn c-btn--sm c-btn--ghost" type="submit" aria-label="Delete">
                                                    <i data-lucide="trash-2"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
    
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize lucide icons
                if (window.lucide) {
                    lucide.createIcons();
                }
            });
        </script>
</layout:student-dashboard>
