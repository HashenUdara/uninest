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

                /* Fix for modal transparency */
                .c-modal__content {
                  background-color: #1A1D21;
                  /* Solid dark background */
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
                  border-radius: 4px;
                  /* Slight rounding for the buttons themselves */
                }

                .c-comment__actions button:hover {
                  background-color: rgba(255, 255, 255, 0.05);
                  color: var(--color-brand-light, #7961F2) !important;
                  /* Highlight color */
                }

                /* Specific danger hover for delete */
                .c-comment__actions button.js-delete-comment:hover {
                  background-color: rgba(220, 38, 38, 0.1);
                  color: #ef4444 !important;
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
                        <img alt="${post.authorName}"
                          src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${post.authorName.charAt(0)}%3C/text%3E%3C/svg%3E" />
                      </div>
                      <div>
                        <strong>
                          <c:out value="${post.authorName}" />
                        </strong>
                        <div class="c-post__meta">
                          <fmt:formatDate value="${post.createdAt}" pattern="MMM d, yyyy HH:mm" />
                        </div>
                      </div>
                    </div>
                    <h1 class="c-post-detail__title" style="margin-top: 1rem">
                      <c:out value="${post.title}" />
                    </h1>
                    <p class="u-text-muted">
                      <c:out value="${post.content}" />
                    </p>

                    <c:if test="${not empty post.imageUrl}">
                      <div class="c-post-detail__image">
                        <img src="${pageContext.request.contextPath}/uploads/${post.imageUrl}" alt="${post.title}" />
                      </div>
                    </c:if>

                    <!-- Poll Display -->
                    <c:if test="${not empty post.poll}">
                      <div class="c-poll"
                        style="margin-top: var(--space-4); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3);">
                        <strong style="display: block; margin-bottom: var(--space-2);">${post.poll.question}</strong>

                        <c:choose>
                          <%-- CASE 1: User has voted -> Show Results --%>
                            <c:when test="${post.poll.currentUserVoted}">
                              <div class="u-stack-2">
                                <c:forEach var="option" items="${post.poll.options}">
                                  <div style="position: relative; margin-bottom: 8px;">
                                    <!-- Option Text & Stats -->
                                    <div
                                      style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 4px;">
                                      <span>
                                        ${option.optionText}
                                        <c:if test="${post.poll.currentUserSelectedOptionIds.contains(option.id)}">
                                          <i data-lucide="check-circle"
                                            style="width: 14px; height: 14px; color: var(--color-brand); vertical-align: middle;"></i>
                                        </c:if>
                                      </span>
                                      <span class="u-text-muted">${option.votePercentage}%</span>
                                    </div>
                                    <!-- Progress Bar Background -->
                                    <div
                                      style="background: var(--color-surface); border-radius: 4px; height: 8px; overflow: hidden; width: 100%;">
                                      <!-- Filled Bar -->
                                      <div
                                        style="background: var(--color-brand); width: ${option.votePercentage}%; height: 100%;">
                                      </div>
                                    </div>
                                    <div
                                      style="font-size: 0.75rem; color: var(--color-text-muted); text-align: right; margin-top: 2px;">
                                      ${option.voteCount} votes
                                    </div>
                                  </div>
                                </c:forEach>
                              </div>
                              <div
                                style="margin-top: var(--space-2); font-size: var(--fs-xs); color: var(--color-text-muted);">
                                You have voted.
                              </div>
                            </c:when>

                            <%-- CASE 2: User has NOT voted -> Show Vote Form --%>
                              <c:otherwise>
                                <form action="${pageContext.request.contextPath}/student/community/polls/vote"
                                  method="POST">
                                  <input type="hidden" name="pollId" value="${post.poll.id}">
                                  <input type="hidden" name="returnUrl"
                                    value="${pageContext.request.contextPath}/student/community/post?id=${post.id}">

                                  <div class="u-stack-2">
                                    <c:forEach var="option" items="${post.poll.options}">
                                      <label
                                        style="display: flex; align-items: center; padding: var(--space-2); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-sm); cursor: pointer; transition: background 0.2s;">
                                        <input type="${post.poll.allowMultipleChoices ? 'checkbox' : 'radio'}"
                                          name="optionId" value="${option.id}" style="margin-right: var(--space-2);">
                                        <span>${option.optionText}</span>
                                      </label>
                                    </c:forEach>
                                  </div>

                                  <div
                                    style="margin-top: var(--space-3); display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-size: var(--fs-xs); color: var(--color-text-muted);">
                                      ${post.poll.allowMultipleChoices ? 'Multiple choices allowed' : 'Single choice'}
                                    </span>
                                    <button type="submit" class="c-btn c-btn--sm c-btn--primary">Vote</button>
                                  </div>
                                </form>
                              </c:otherwise>
                        </c:choose>
                      </div>
                    </c:if>

                    <div class="c-post__stats" aria-label="Post stats">
                      <span class="c-stat"><i data-lucide="thumbs-up"></i>${post.likeCount}</span>
                      <span class="c-stat"><i data-lucide="message-square"></i>${post.commentCount}</span>
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
                          <img alt="You"
                            src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3EY%3C/text%3E%3C/svg%3E" />
                        </div>
                        <form action="${pageContext.request.contextPath}/student/community/comments/add" method="POST"
                          style="flex: 1;">
                          <input type="hidden" name="postId" value="${post.id}">
                          <textarea name="content" class="c-textarea" rows="3" placeholder="Add a comment..."
                            required></textarea>
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
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=CS204"
                          class="c-subject">
                          <span class="c-subject__badge is-lavender">CS204</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">Data Structures</span>
                            <span class="c-subject__sub">CS204</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=CS301"
                          class="c-subject">
                          <span class="c-subject__badge is-mint">CS301</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">Algorithms</span>
                            <span class="c-subject__sub">CS301</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=CS123"
                          class="c-subject">
                          <span class="c-subject__badge is-lime">CS123</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">Programming Fundamentals</span>
                            <span class="c-subject__sub">CS123</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=CS205"
                          class="c-subject">
                          <span class="c-subject__badge is-lavender">CS205</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">Operating Systems</span>
                            <span class="c-subject__sub">CS205</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=MA201"
                          class="c-subject">
                          <span class="c-subject__badge is-mint">MA201</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">Calculus II</span>
                            <span class="c-subject__sub">MA201</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=ENG101"
                          class="c-subject">
                          <span class="c-subject__badge is-lime">ENG101</span>
                          <span class="c-subject__text">
                            <span class="c-subject__label">English Composition</span>
                            <span class="c-subject__sub">ENG101</span>
                          </span>
                        </a>
                      </li>
                      <li>
                        <a href="${pageContext.request.contextPath}/student/community/subject?subject=PHY110"
                          class="c-subject">
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

              </div>

              <!-- Delete Confirmation Modal (Same style as my-posts) -->
              <div id="delete-modal" class="c-modal" hidden>
                <div class="c-modal__overlay" data-close></div>
                <div class="c-modal__content" role="dialog" aria-labelledby="delete-title">
                  <header class="c-modal__header">
                    <h2 id="delete-title">Delete Comment</h2>
                    <button class="c-modal__close" data-close aria-label="Close">
                      <i data-lucide="x"></i>
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

              <!-- Hidden Global Delete Form -->
              <form id="global-delete-form"
                action="${pageContext.request.contextPath}/student/community/comments/delete" method="POST">
                <input type="hidden" name="id" id="delete-comment-id">
                <input type="hidden" name="postId" value="${post.id}">
              </form>

              <script>
                document.addEventListener("DOMContentLoaded", function () {
                  if (window.lucide) window.lucide.createIcons();

                  const modal = document.getElementById("delete-modal");
                  const deleteForm = document.getElementById("global-delete-form");
                  const deleteInput = document.getElementById("delete-comment-id");
                  let pendingDeleteId = null;

                  document.body.addEventListener('click', function (e) {
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

                    // Delete Click (Show Modal)
                    if (e.target.closest('.js-delete-comment')) {
                      const btn = e.target.closest('.js-delete-comment');
                      pendingDeleteId = btn.getAttribute('data-comment-id');
                      if (modal) {
                        modal.hidden = false;
                        modal.querySelector(".js-confirm-delete")?.focus();
                      }
                    }

                    // Modal Close
                    if (modal && e.target.closest("[data-close]")) {
                      modal.hidden = true;
                      pendingDeleteId = null;
                    }

                    // Confirm Delete
                    if (modal && e.target.classList.contains('js-confirm-delete')) {
                      if (pendingDeleteId) {
                        deleteInput.value = pendingDeleteId;
                        deleteForm.submit();
                      }
                    }
                  });

                  // Close modal on Escape
                  document.addEventListener("keydown", (e) => {
                    if (modal && !modal.hidden && e.key === "Escape") {
                      modal.hidden = true;
                      pendingDeleteId = null;
                    }
                  });
                });
              </script>
            </layout:student-dashboard>