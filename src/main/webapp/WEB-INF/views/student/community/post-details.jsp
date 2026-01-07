<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<%@ taglib prefix="comm" tagdir="/WEB-INF/tags/community" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<layout:student-dashboard pageTitle="Community" activePage="community">
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
        </style>
    <header class="c-page__header">
        <nav class="c-breadcrumbs" aria-label="Breadcrumb">
            <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
            <span class="c-breadcrumbs__sep">/</span>
            <a href="${pageContext.request.contextPath}/student/community">Community</a>
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
                        <li class="u-text-muted">No comments yet. Be the first to share your thoughts!</li>
                    </c:if>
                </ul>

                <!-- Main Comment Form -->
                <div class="c-comment-compose">
                  <div class="c-avatar-sm">
                    <img
                      alt="You"
                      src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3EY%3C/text%3E%3C/svg%3E"
                    />
                  </div>
                  <form action="${pageContext.request.contextPath}/student/community/comments/add" method="POST" style="flex: 1;">
                      <input type="hidden" name="postId" value="${post.id}">
                      <textarea
                        name="content"
                        class="c-textarea"
                        rows="3"
                        placeholder="Add a comment..."
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

          <!-- Sidebar (kept as is) -->
          <aside class="c-right-panel">
            <section class="c-right-section">
              <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
              <ul class="c-subjects" role="list">
                 <li>
                   <a href="${pageContext.request.contextPath}/student/community" class="c-subject">
                     <span class="c-subject__badge is-lavender">ALL</span>
                     <span class="c-subject__text">
                       <span class="c-subject__label">All Subjects</span>
                     </span>
                   </a>
                 </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=CS204"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-lavender">CS204</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">Data Structures</span>
                      <span class="c-subject__sub">CS204</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=CS301"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-mint">CS301</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">Algorithms</span>
                      <span class="c-subject__sub">CS301</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=CS123"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-lime">CS123</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label"
                        >Programming Fundamentals</span
                      >
                      <span class="c-subject__sub">CS123</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=CS205"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-lavender">CS205</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">Operating Systems</span>
                      <span class="c-subject__sub">CS205</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=MA201"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-mint">MA201</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">Calculus II</span>
                      <span class="c-subject__sub">MA201</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=ENG101"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-lime">ENG101</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">English Composition</span>
                      <span class="c-subject__sub">ENG101</span>
                    </span>
                  </a>
                </li>
                <li>
                  <a
                    href="${pageContext.request.contextPath}/student/community/subject?subject=PHY110"
                    class="c-subject"
                  >
                    <span class="c-subject__badge is-lavender">PHY110</span>
                    <span class="c-subject__text">
                      <span class="c-subject__label">Physics I</span>
                      <span class="c-subject__sub">PHY110</span>
                    </span>
                  </a>
                </li>
              </ul>
            </section>
          </aside>
        </div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (window.lucide) window.lucide.createIcons();
        
        // Reply & Edit toggle logic
        document.body.addEventListener('click', function(e) {
            // Reply Toggle
            if (e.target.closest('.js-reply-toggle')) {
                const btn = e.target.closest('.js-reply-toggle');
                const commentId = btn.getAttribute('data-comment-id');
                const form = document.getElementById('reply-form-' + commentId);
                // Hide edit form if open
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
                // Hide reply form if open
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
        });
    });
</script>
</layout:student-dashboard>
