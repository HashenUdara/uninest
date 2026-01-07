<%@ tag description="Recursive comment item" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="comm" tagdir="/WEB-INF/tags/community" %>

<%@ attribute name="comment" type="com.uninest.model.PostComment" required="true" %>

<li class="c-comment" id="comment-${comment.id}">
    <div class="c-avatar-sm">
        <c:set var="initials" value="${fn:substring(comment.authorName, 0, 1)}" />
        <c:if test="${fn:contains(comment.authorName, ' ')}">
            <c:set var="initials" value="${initials}${fn:substring(comment.authorName, fn:indexOf(comment.authorName, ' ') + 1, fn:indexOf(comment.authorName, ' ') + 2)}" />
        </c:if>
        <img
            alt="${comment.authorName}"
            src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${initials}%3C/text%3E%3C/svg%3E"
        />
    </div>
    <div class="c-comment__body">
        <div class="c-comment__head">
            <strong><c:out value="${comment.authorName}" /></strong>
            <span class="c-post__meta">
                <fmt:formatDate value="${comment.createdAt}" pattern="MMM d, HH:mm" />
            </span>
        </div>
        <p class="u-text-muted">
            <c:out value="${comment.content}" />
        </p>

        <!-- Action Bar -->
        <div class="c-comment__actions" style="display: flex; gap: var(--space-3); align-items: center;">
            <button 
                class="c-btn c-btn--ghost c-btn--sm js-reply-toggle" 
                data-comment-id="${comment.id}"
                style="padding: 0 0.5rem;"
            >
                Reply
            </button>

            <!-- Edit/Delete for Author -->
            <c:if test="${sessionScope.authUser != null && sessionScope.authUser.id == comment.userId}">
                <button 
                    class="c-btn c-btn--ghost c-btn--sm js-edit-toggle" 
                    data-comment-id="${comment.id}"
                    style="padding: 0 0.5rem;"
                >
                    <i data-lucide="edit-2" style="width: 14px; height: 14px; margin-right: 4px;"></i> Edit
                </button>
                
                <form 
                    action="${pageContext.request.contextPath}/student/community/comments/delete" 
                    method="POST" 
                    style="display: inline;"
                    onsubmit="return confirm('Are you sure you want to delete this comment? All replies will also be deleted.');"
                >
                    <input type="hidden" name="id" value="${comment.id}">
                    <input type="hidden" name="postId" value="${comment.postId}">
                    <button 
                        type="submit" 
                        class="c-btn c-btn--ghost c-btn--sm"
                        style="padding: 0 0.5rem; color: var(--c-danger);"
                    >
                        <i data-lucide="trash-2" style="width: 14px; height: 14px; margin-right: 4px;"></i> Delete
                    </button>
                </form>
            </c:if>
        </div>

        <!-- Hidden Reply Form -->
        <div class="c-reply-form-container" id="reply-form-${comment.id}" hidden style="margin-top: var(--space-2);">
            <form action="${pageContext.request.contextPath}/student/community/comments/add" method="POST">
                <input type="hidden" name="postId" value="${comment.postId}">
                <input type="hidden" name="parentId" value="${comment.id}">
                <div class="o-grid" style="gap: var(--space-2);">
                    <textarea 
                        name="content" 
                        class="c-textarea c-textarea--sm" 
                        rows="2" 
                        placeholder="Write a reply..." 
                        required
                    ></textarea>
                    <div style="display: flex; gap: var(--space-2);">
                        <button type="submit" class="c-btn c-btn--secondary c-btn--sm">Post Reply</button>
                        <button type="button" class="c-btn c-btn--ghost c-btn--sm js-cancel-reply" data-comment-id="${comment.id}">Cancel</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Hidden Edit Form -->
        <div class="c-edit-form-container" id="edit-form-${comment.id}" hidden style="margin-top: var(--space-2);">
            <form action="${pageContext.request.contextPath}/student/community/comments/update" method="POST">
                <input type="hidden" name="id" value="${comment.id}">
                <input type="hidden" name="postId" value="${comment.postId}">
                <div class="o-grid" style="gap: var(--space-2);">
                    <textarea 
                        name="content" 
                        class="c-textarea c-textarea--sm" 
                        rows="2" 
                        required
                    ><c:out value="${comment.content}"/></textarea>
                    <div style="display: flex; gap: var(--space-2);">
                        <button type="submit" class="c-btn c-btn--primary c-btn--sm">Save Changes</button>
                        <button type="button" class="c-btn c-btn--ghost c-btn--sm js-cancel-edit" data-comment-id="${comment.id}">Cancel</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Nested Children -->
        <c:if test="${not empty comment.replies}">
            <ul class="c-comment__children" role="list">
                <c:forEach var="reply" items="${comment.replies}">
                    <comm:comment-item comment="${reply}" />
                </c:forEach>
            </ul>
        </c:if>
    </div>
</li>
