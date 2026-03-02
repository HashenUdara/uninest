<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<%@ taglib prefix="comm" tagdir="/WEB-INF/tags/community" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<layout:moderator-dashboard pageTitle="Post Details" activePage="community">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
        <style>
            .c-form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: var(--space-4);
            }
            .c-textarea--sm {
                min-height: 60px;
                font-size: 0.875rem;
                padding: var(--space-2);
            }
            /* Fix for modal transparency */
            .c-modal__content {
                background-color: #1A1D21; /* Solid dark background */
                border: 1px solid #2A2D35;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
                opacity: 1;
                z-index: 1000;
                border-radius: 12px;
                overflow: hidden;
            }
            .c-modal__overlay {
                background-color: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(2px);
            }
            
            /* Comment Action Buttons Hover */
            .c-comment__actions button {
                transition: all 0.2s ease;
                border-radius: 4px; /* Slight rounding for the buttons themselves */
            }
            .c-comment__actions button:hover {
                background-color: rgba(255, 255, 255, 0.05);
                color: var(--color-brand-light, #7961F2) !important; /* Highlight color */
            }
            /* Specific danger hover for delete */
            .c-comment__actions button.js-delete-comment:hover {
                background-color: rgba(220, 38, 38, 0.1);
                color: #ef4444 !important;
            }
        </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/moderator/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/moderator/community">Community Management</a>
            <span class="c-breadcrumbs__sep">/</span>
            <span aria-current="page">Post Details</span>
        </nav>
    </header>

    <c:if test="${not empty param.error}">
        <div class="c-alert c-alert--danger" role="alert">
            <p>
                <c:choose>
                    <c:when test="${param.error == 'empty_comment'}">Comment cannot be empty.</c:when>
                    <c:otherwise>An error occurred.</c:otherwise>
                </c:choose>
            </p>
        </div>
    </c:if>

 <div class="comm-layout">
          <div class="o-feed">
            
        <article class="c-post-detail">
              <div class="c-post__head">
                <div class="c-avatar-sm">
                  <img
                    alt="${post.authorName}"
                    src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${post.authorName.charAt(0)}%3C/text%3E%3C/svg%3E"
                  />
                </div>
                <div>
                  <strong><c:out value="${post.authorName}"/></strong>
                  <div class="c-post__meta">
                    <fmt:formatDate value="${post.createdAt}" pattern="MMM d, yyyy HH:mm"/>
                  </div>
                </div>
              </div>
              <h1 class="c-post-detail__title" style="margin-top: 1rem">
                <c:out value="${post.title}"/>
              </h1>
              <p class="u-text-muted">
                <c:out value="${post.content}"/>
              </p>

              <c:if test="${not empty post.imageUrl}">
                  <div class="c-post-detail__image">
                    <img src="${pageContext.request.contextPath}/uploads/${post.imageUrl}" alt="${post.title}" />
                  </div>
              </c:if>

              <div class="c-post__stats" aria-label="Post stats">
                <span class="c-stat"><i data-lucide="thumbs-up"></i>${post.likeCount}</span>
                <span class="c-stat"
                  ><i data-lucide="message-square"></i>${post.commentCount}</span
                >
              </div>

              <section class="c-comments u-stack-4" id="comments">
                <h3 class="c-section-title" style="margin-top: 2rem">
                  Comments (${post.commentCount})
                </h3>
                
                <ul class="c-comment-list" role="list">
                    <c:forEach var="comment" items="${comments}">
                        <comm:comment-item comment="${comment}" />
                    </c:forEach>
                    <c:if test="${empty comments}">
                        <li class="u-text-muted">No comments yet.</li>
                    </c:if>
                </ul>

                <!-- Main Comment Form (Maybe hide for moderator? For now keeping it if they want to reply officially) -->
                <!-- Ideally moderators should have a flair or distinction, but that's a future task -->
                <div class="c-comment-compose">
                  <div class="c-avatar-sm">
                    <img
                      alt="You"
                      src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3EM%3C/text%3E%3C/svg%3E"
                    />
                  </div>
                  <form action="${pageContext.request.contextPath}/student/community/comments/add" method="POST" style="flex: 1;">
                      <input type="hidden" name="postId" value="${post.id}">
                      <textarea
                        name="content"
                        class="c-textarea"
                        rows="3"
                        placeholder="Add a comment as moderator..."
                        required
                      ></textarea>
                      <div class="c-comment-compose__actions">
                        <button class="c-btn c-btn--secondary" type="submit">
                          Post Comment
                        </button>
                      </div>
                  </form>
                </div>
              </section>
            </article>
          </div>

          <!-- Sidebar (kept similar but could be moderator specific stats later) -->
          <aside class="c-right-panel">
            <section class="c-right-section">
               <h3 class="c-section-title" style="margin-top: 0">Moderation</h3>
               <div class="c-card" style="padding: var(--space-4);">
                    <button 
                        class="c-btn c-btn--danger c-btn--sm js-moderator-delete-post" 
                        data-post-id="${post.id}"
                        style="width: 100%; justify-content: center;"
                    >
                        <i data-lucide="trash-2"></i> Delete Post
                    </button>
                    <p class="u-text-muted u-stack-2" style="font-size: 0.8rem; margin-top: 1rem;">
                        Note: Deleting a post requires a reason and will be logged.
                    </p>
               </div>
            </section>
          </aside>
        </div>

        </div>

    <!-- Modals -->
    <!-- Delete Comment Modal (Existing) -->
    <div id="delete-modal" class="c-modal" hidden>
      <!-- ... existing delete-modal content ... -->
      <div class="c-modal__overlay" data-close></div>
      <div class="c-modal__content" role="dialog" aria-labelledby="delete-title" style="position: relative;">
        <header class="c-modal__header" style="display: flex; justify-content: space-between; align-items: center; padding: var(--space-4);">
          <h2 id="delete-title" style="margin: 0;">Delete Comment</h2>
          <button class="c-modal__close" data-close aria-label="Close" style="background: rgba(255,255,255,0.05); border: none; border-radius: 4px; padding: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
            <i data-lucide="x" style="width: 20px; height: 20px;"></i>
          </button>
        </header>
        <div class="c-modal__body">
          <p>
            Are you sure you want to delete this comment? 
            <br><small class="u-text-muted">This will also delete all replies to this comment.</small>
          </p>
        </div>
        <footer class="c-modal__footer">
          <button class="c-btn c-btn--ghost" data-close>Cancel</button>
          <button class="c-btn c-btn--danger js-confirm-delete">Delete</button>
        </footer>
      </div>
    </div>

    <!-- Moderator Delete Post Modal (New) -->
    <div id="mod-delete-modal" class="c-modal" hidden>
      <div class="c-modal__overlay" data-close></div>
      <div class="c-modal__content" role="dialog" aria-labelledby="mod-delete-title" style="border-radius: 12px; background-color: #1A1D21; border: 1px solid #2A2D35; position: relative;">
        <header class="c-modal__header" style="display: flex; justify-content: space-between; align-items: center; padding: var(--space-4);">
          <h2 id="mod-delete-title" style="margin: 0;">Delete Post</h2>
          <button class="c-modal__close" data-close aria-label="Close" style="background: rgba(255,255,255,0.05); border: none; border-radius: 4px; padding: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
            <i data-lucide="x" style="width: 20px; height: 20px;"></i>
          </button>
        </header>
        <form action="${pageContext.request.contextPath}/moderator/community/post/delete" method="POST">
            <input type="hidden" name="postId" id="mod-delete-post-id">
            <div class="c-modal__body">
              <p class="u-text-muted u-stack-2">Please provide a reason for deleting this post. This action will be logged for accountability.</p>
              <div class="c-field">
                <label for="del-reason" class="c-label">Deletion Reason</label>
                <textarea 
                    id="del-reason" 
                    name="reason" 
                    class="c-input" 
                    rows="3" 
                    placeholder="e.g., Inappropriate content, False information..." 
                    required
                ></textarea>
              </div>
            </div>
            <footer class="c-modal__footer">
              <button type="button" class="c-btn c-btn--ghost" data-close>Cancel</button>
              <button type="submit" class="c-btn c-btn--danger">Confirm Delete</button>
            </footer>
        </form>
      </div>
    </div>

    <!-- Hidden Global Delete Comment Form -->
    <form id="global-delete-form" action="${pageContext.request.contextPath}/student/community/comments/delete" method="POST">
        <input type="hidden" name="id" id="delete-comment-id">
        <input type="hidden" name="postId" value="${post.id}">
    </form>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (window.lucide) window.lucide.createIcons();
        
        const deleteCommentModal = document.getElementById("delete-modal");
        const deleteCommentForm = document.getElementById("global-delete-form");
        const deleteCommentInput = document.getElementById("delete-comment-id");
        
        const modDeletePostModal = document.getElementById("mod-delete-modal");
        const modDeletePostInput = document.getElementById("mod-delete-post-id");
        
        let pendingDeleteId = null;

        document.body.addEventListener('click', function(e) {
            // ... existing toggles ...
            // Reply Toggle
            if (e.target.closest('.js-reply-toggle')) {
                const btn = e.target.closest('.js-reply-toggle');
                const commentId = btn.getAttribute('data-comment-id');
                const form = document.getElementById('reply-form-' + commentId);
                const editForm = document.getElementById('edit-form-' + commentId);
                if (editForm) editForm.hidden = true;
                if (form) form.hidden = !form.hidden;
            }
            // Cancel Reply
            if (e.target.closest('.js-cancel-reply')) {
                const btn = e.target.closest('.js-cancel-reply');
                const commentId = btn.getAttribute('data-comment-id');
                const form = document.getElementById('reply-form-' + commentId);
                if (form) form.hidden = true;
            }
            // Edit Toggle
            if (e.target.closest('.js-edit-toggle')) {
                const btn = e.target.closest('.js-edit-toggle');
                const commentId = btn.getAttribute('data-comment-id');
                const form = document.getElementById('edit-form-' + commentId);
                const replyForm = document.getElementById('reply-form-' + commentId);
                if (replyForm) replyForm.hidden = true;
                if (form) form.hidden = !form.hidden;
            }
            // Cancel Edit
            if (e.target.closest('.js-cancel-edit')) {
                const btn = e.target.closest('.js-cancel-edit');
                const commentId = btn.getAttribute('data-comment-id');
                const form = document.getElementById('edit-form-' + commentId);
                if (form) form.hidden = true;
            }

            // Comment Delete (Show Modal)
            if (e.target.closest('.js-delete-comment')) {
                const btn = e.target.closest('.js-delete-comment');
                pendingDeleteId = btn.getAttribute('data-comment-id');
                if (deleteCommentModal) {
                    deleteCommentModal.hidden = false;
                }
            }

            // Moderator Post Delete (Show Modal)
            if (e.target.closest('.js-moderator-delete-post')) {
                const btn = e.target.closest('.js-moderator-delete-post');
                const postId = btn.getAttribute('data-post-id');
                if (modDeletePostModal && modDeletePostInput) {
                    modDeletePostInput.value = postId;
                    modDeletePostModal.hidden = false;
                }
            }
            
            // Modal Close (Generic)
            if (e.target.closest("[data-close]")) {
                if (deleteCommentModal) deleteCommentModal.hidden = true;
                if (modDeletePostModal) modDeletePostModal.hidden = true;
                pendingDeleteId = null;
            }
            
            // Confirm Comment Delete
            if (e.target.classList.contains('js-confirm-delete')) {
                if (pendingDeleteId && deleteCommentForm) {
                    deleteCommentInput.value = pendingDeleteId;
                    deleteCommentForm.submit();
                }
            }
        });

        // Close modals on Escape
        document.addEventListener("keydown", (e) => {
            if (e.key === "Escape") {
                if (deleteCommentModal) deleteCommentModal.hidden = true;
                if (modDeletePostModal) modDeletePostModal.hidden = true;
                pendingDeleteId = null;
            }
        });
    });
</script>
</layout:moderator-dashboard>
