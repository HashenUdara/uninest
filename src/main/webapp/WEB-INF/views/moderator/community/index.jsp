<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
          <%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

            <layout:moderator-dashboard pageTitle="Community Management" activePage="community">
              <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
              <style>
                .c-form-grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                  gap: var(--space-4);
                }
              </style>
              <header class="c-page__header">
                <nav class="c-breadcrumbs" aria-label="Breadcrumb">
                  <a href="${pageContext.request.contextPath}/moderator/dashboard">Home</a>
                  <span class="c-breadcrumbs__sep">/</span>
                  <a href="${pageContext.request.contextPath}/moderator/community">Community Management</a>
                </nav>
              </header>

              <c:if test="${not empty error}">
                <div class="c-alert c-alert--danger" role="alert">
                  <p>${error}</p>
                </div>
              </c:if>

              <div class="comm-layout">
                <div class="o-feed">
                  <header class="c-page__header">
                    <div class="o-inline" style="
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: var(--space-4);
          ">
                      <div>
                        <h1 class="c-page__title">Community Feed</h1>
                        <p class="c-page__subtitle u-text-muted">
                          Overview of all student discussions.
                        </p>
                      </div>
                      <!-- New Post button hidden for moderator view -->
                    </div>
                    <nav class="c-tabs-line" aria-label="Filter">
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=upvoted"
                        class="${activeTab == 'upvoted' ? 'is-active' : ''}">Most Upvoted</a>
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=recent"
                        class="${activeTab == 'recent' ? 'is-active' : ''}">Most Recent</a>
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=unanswered"
                        class="${activeTab == 'unanswered' ? 'is-active' : ''}">Unanswered</a>
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=deleted"
                        class="${activeTab == 'deleted' ? 'is-active' : ''}" style="color: var(--c-danger);">Deleted
                        Posts</a>
                    </nav>
                    <!-- Filters -->
                    <div class="c-filters u-stack-2" role="search" style="margin-top: var(--space-4)">
                      <div class="o-inline" style="display: flex; gap: var(--space-3); flex-wrap: wrap">
                        <input type="search" class="c-input c-input--soft js-post-search" placeholder="Search posts"
                          aria-label="Search posts" style="min-width: 220px" />
                      </div>
                    </div>
                  </header>

                  <section class="u-stack-4">
                    <h3 class="c-section-title" style="margin-top: 0">Pinned Posts</h3>
                  </section>

                  <!-- Latest posts -->
                  <section class="u-stack-4">
                    <h3 class="c-section-title">Latest Posts</h3>
                    <div class="c-posts">
                      <c:choose>
                        <c:when test="${empty posts}">
                          <p class="u-text-muted">
                            No posts found.
                          </p>
                        </c:when>
                        <c:otherwise>
                          <c:forEach var="post" items="${posts}">
                            <article class="c-post ${not empty post.imageUrl ? 'c-post--image' : 'c-post--text'}">
                              <div class="c-post__head">
                                <div class="c-avatar-sm">
                                  <c:set var="initials"
                                    value="${fn:substring(post.authorName, 0, 1)}${fn:substring(fn:substringAfter(post.authorName, ' '), 0, 1)}" />
                                  <img alt="${post.authorName}"
                                    src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3E${fn:toUpperCase(initials)}%3C/text%3E%3C/svg%3E" />
                                </div>
                                <div>
                                  <strong>${post.authorName}</strong>
                                  <div class="c-post__meta">
                                    <fmt:formatDate value="${post.createdAt}" pattern="MMM d, yyyy" />
                                  </div>
                                </div>
                              </div>

                              <div class="c-post__body">
                                <h4 class="c-post__title">
                                  <c:choose>
                                    <c:when test="${post.deleted}">
                                      <span style="color: inherit; opacity: 0.6;">${post.title} (Deleted)</span>
                                    </c:when>
                                    <c:otherwise>
                                      <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                                        style="color: inherit; text-decoration: none;">
                                        ${post.title}
                                      </a>
                                    </c:otherwise>
                                  </c:choose>
                                </h4>
                                <p class="u-text-muted"
                                  style="${post.deleted ? 'text-decoration: line-through; opacity: 0.5;' : ''}">
                                  ${post.content}</p>
                                <c:if test="${not empty post.imageUrl}">
                                  <div class="c-post__image">
                                    <img src="${pageContext.request.contextPath}/uploads/${post.imageUrl}"
                                      alt="Post image" />
                                  </div>
                                </c:if>

                                <!-- Poll Display (Moderator View - Always Show Results) -->
                                <c:if test="${not empty post.poll}">
                                  <div class="c-poll"
                                    style="margin-top: var(--space-4); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3);">
                                    <strong
                                      style="display: block; margin-bottom: var(--space-2);">${post.poll.question}</strong>

                                    <div class="u-stack-2">
                                      <c:forEach var="option" items="${post.poll.options}">
                                        <div style="position: relative; margin-bottom: 8px;">
                                          <!-- Option Text & Stats -->
                                          <div
                                            style="display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 4px;">
                                            <span>
                                              ${option.optionText}
                                              <c:if
                                                test="${post.poll.currentUserSelectedOptionIds.contains(option.id)}">
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
                                      <c:choose>
                                        <c:when test="${post.poll.currentUserVoted}">
                                          You have voted.
                                        </c:when>
                                        <c:otherwise>
                                          Moderator view - Results visible without voting
                                        </c:otherwise>
                                      </c:choose>
                                    </div>
                                  </div>
                                </c:if>
                              </div>

                              <div class="c-post__actions">
                                <c:choose>
                                  <c:when test="${post.deleted}">
                                    <div class="o-stack-1" style="width: 100%;">
                                      <div
                                        style="display: flex; align-items: center; gap: var(--space-2); color: #ef4444; font-size: 0.875rem; font-weight: 600; padding: var(--space-2); background: rgba(239, 68, 68, 0.05); border-radius: 6px;">
                                        <i data-lucide="info" style="width: 16px; height: 16px;"></i>
                                        Reason:
                                        <c:out
                                          value="${post.deletionReason != null ? post.deletionReason : 'No reason provided'}" />
                                      </div>
                                      <div class="u-text-muted" style="font-size: 0.75rem; margin-top: 4px;">
                                        Deleted on
                                        <fmt:formatDate value="${post.deletedAt}" pattern="MMM d, yyyy HH:mm" />
                                      </div>
                                    </div>
                                  </c:when>
                                  <c:otherwise>
                                    <div class="c-btn c-btn--ghost c-btn--sm" style="cursor: default;">
                                      <i data-lucide="thumbs-up"></i>
                                      <span>${post.likeCount}</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                                      class="c-btn c-btn--ghost c-btn--sm" aria-label="Comments">
                                      <i data-lucide="message-square"></i>${post.commentCount}
                                    </a>

                                    <button class="c-btn c-btn--ghost c-btn--sm js-moderator-delete-post"
                                      data-post-id="${post.id}" style="color: var(--c-danger); margin-left: auto;"
                                      title="Delete Post">
                                      <i data-lucide="trash-2"></i>
                                    </button>
                                  </c:otherwise>
                                </c:choose>
                              </div>
                            </article>
                          </c:forEach>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </section>
                </div>

                <!-- Modals -->
                <div id="mod-delete-modal" class="c-modal" hidden>
                  <div class="c-modal__overlay" data-close></div>
                  <div class="c-modal__content" role="dialog" aria-labelledby="mod-delete-title"
                    style="border-radius: 12px; background-color: #1A1D21; border: 1px solid #2A2D35; position: relative;">
                    <header class="c-modal__header"
                      style="display: flex; justify-content: space-between; align-items: center; padding: var(--space-4);">
                      <h2 id="mod-delete-title" style="margin: 0;">Delete Post</h2>
                      <button class="c-modal__close" data-close aria-label="Close"
                        style="background: rgba(255,255,255,0.05); border: none; border-radius: 4px; padding: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                        <i data-lucide="x" style="width: 20px; height: 20px;"></i>
                      </button>
                    </header>
                    <form action="${pageContext.request.contextPath}/moderator/community/post/delete" method="POST">
                      <input type="hidden" name="postId" id="mod-delete-post-id">
                      <div class="c-modal__body">
                        <p class="u-text-muted u-stack-2">Please provide a reason for deleting this post. This action
                          will be logged for accountability.</p>
                        <div class="c-field">
                          <label for="del-reason" class="c-label">Deletion Reason</label>
                          <textarea id="del-reason" name="reason" class="c-input" rows="3"
                            placeholder="e.g., Inappropriate content, False information..." required></textarea>
                        </div>
                      </div>
                      <footer class="c-modal__footer">
                        <button type="button" class="c-btn c-btn--ghost" data-close>Cancel</button>
                        <button type="submit" class="c-btn c-btn--danger">Confirm Delete</button>
                      </footer>
                    </form>
                  </div>
                </div>

                <aside class="c-right-panel">
                  <!-- Right panel content -->
                </aside>
              </div>

              <script>
                document.addEventListener("DOMContentLoaded", function () {
                  if (window.lucide) window.lucide.createIcons();

                  const modal = document.getElementById("mod-delete-modal");
                  const postIdInput = document.getElementById("mod-delete-post-id");

                  document.body.addEventListener('click', function (e) {
                    if (e.target.closest('.js-moderator-delete-post')) {
                      const btn = e.target.closest('.js-moderator-delete-post');
                      const postId = btn.getAttribute('data-post-id');
                      if (modal && postIdInput) {
                        postIdInput.value = postId;
                        modal.hidden = false;
                      }
                    }

                    if (modal && e.target.closest('[data-close]')) {
                      modal.hidden = true;
                    }
                  });
                });
              </script>
            </layout:moderator-dashboard>