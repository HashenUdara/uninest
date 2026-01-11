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
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=reported"
                        class="${activeTab == 'reported' ? 'is-active' : ''}"
                        style="color: var(--color-warning);">Reported</a>
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=unanswered"
                        class="${activeTab == 'unanswered' ? 'is-active' : ''}">Unanswered</a>
                      <a href="${pageContext.request.contextPath}/moderator/community?tab=deleted"
                        class="${activeTab == 'deleted' ? 'is-active' : ''}" style="color: var(--color-danger);">Deleted
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
                    <div class="c-pinned-section ${empty pinnedPosts ? 'u-hidden' : ''}" id="pinned-section">
                      <header class="c-pinned-header"
                        style="display: flex; justify-content: space-between; align-items: center; cursor: pointer; padding-bottom: var(--space-2); border-bottom: 1px solid rgba(84, 44, 245, 0.1); margin-bottom: var(--space-4);"
                        onclick="togglePinnedSection()">
                        <div style="display: flex; align-items: center; gap: var(--space-2);">
                          <i data-lucide="pin" style="color: var(--color-brand); width: 20px; height: 20px;"></i>
                          <h3
                            style="font-size: var(--fs-lg); font-weight: var(--fw-bold); color: var(--color-brand); margin: 0; line-height: 1;">
                            Pinned Posts</h3>
                        </div>
                        <button class="c-pinned-toggle" aria-label="Toggle Pinned Posts"
                          style="background: none; border: none; color: var(--color-brand); padding: 4px; display: flex; align-items: center; justify-content: center;">
                          <i data-lucide="chevron-down" style="width: 20px; height: 20px;"></i>
                        </button>
                      </header>
                      <div class="c-pinned-content">
                        <c:forEach var="post" items="${pinnedPosts}">
                          <article class="c-post c-post--pinned">
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
                                  <span class="c-pin-badge"><i data-lucide="pin" style="width:10px; height:10px;"></i>
                                    Pinned</span>
                                </div>
                              </div>
                              <form action="${pageContext.request.contextPath}/moderator/community/post/pin"
                                method="POST" style="margin-left: auto;">
                                <input type="hidden" name="postId" value="${post.id}">
                                <input type="hidden" name="action" value="unpin">
                                <input type="hidden" name="tab" value="${activeTab}">
                                <button type="submit" class="c-btn c-btn--ghost c-btn--sm is-pinned" title="Unpin Post"
                                  style="padding: 4px; color: var(--color-brand) !important;">
                                  <i data-lucide="pin-off" style="width: 18px; height: 18px;"></i>
                                </button>
                              </form>
                            </div>
                            <div class="c-post__body">
                              <h4 class="c-post__title">
                                <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                                  style="color: inherit; text-decoration: none;">
                                  ${post.title}
                                </a>
                              </h4>
                              <p class="u-text-muted">${post.content}</p>
                            </div>
                            <div class="c-post__actions">
                              <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                                class="c-btn c-btn--ghost c-btn--sm" title="View Details">
                                <i data-lucide="eye"></i>
                              </a>

                              <button class="c-btn c-btn--ghost c-btn--sm c-btn--danger-ghost js-moderator-delete-post"
                                data-post-id="${post.id}" style="margin-left: 12px;" title="Delete Post">
                                <i data-lucide="trash-2"></i>
                              </button>
                            </div>
                          </article>
                        </c:forEach>
                      </div>
                    </div>
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
                                    <c:if test="${post.pinned}">
                                      <span class="c-pin-badge"><i data-lucide="pin"
                                          style="width:10px; height:10px;"></i> Pinned</span>
                                    </c:if>
                                  </div>
                                </div>

                                <c:if test="${!post.deleted}">
                                  <form action="${pageContext.request.contextPath}/moderator/community/post/pin"
                                    method="POST" style="margin-left: auto;">
                                    <input type="hidden" name="postId" value="${post.id}">
                                    <input type="hidden" name="action" value="${post.pinned ? 'unpin' : 'pin'}">
                                    <input type="hidden" name="tab" value="${activeTab}">
                                    <button type="submit"
                                      class="c-btn c-btn--ghost c-btn--sm ${post.pinned ? 'is-pinned' : ''}"
                                      style="padding: 4px; ${post.pinned ? 'color: var(--color-brand) !important;' : 'opacity: 0.6;'}"
                                      title="${post.pinned ? 'Unpin Post' : 'Pin Post'}">
                                      <i data-lucide="${post.pinned ? 'pin-off' : 'pin'}"
                                        style="width: 18px; height: 18px;"></i>
                                    </button>
                                  </form>
                                </c:if>
                              </div>

                              <div class="c-post__body">
                                <h4 class="c-post__title">
                                  <c:choose>
                                    <c:when test="${post.deleted}">
                                      <span style="color: inherit; opacity: 0.6;">${post.title} (Deleted)</span>
                                    </c:when>
                                    <c:otherwise>
                                      <a href="${pageContext.request.contextPath}/moderator/community/post?id=${post.id}"
                                        style="color: inherit; text-decoration: none; vertical-align: middle;">
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

                                  <c:when test="${activeTab == 'reported'}">
                                    <div class="o-stack-1" style="width: 100%;">
                                      <div
                                        style="display: flex; align-items: center; gap: var(--space-2); color: #f59e0b; font-size: 0.875rem; font-weight: 600; padding: var(--space-2); background: rgba(245, 158, 11, 0.1); border-radius: 6px;">
                                        <i data-lucide="flag" style="width: 16px; height: 16px;"></i>
                                        Reported by ${post.reportCount} user${post.reportCount > 1 ? 's' : ''}
                                      </div>
                                      <div style="display: flex; gap: var(--space-2); margin-top: 8px;">
                                        <button class="c-btn c-btn--danger c-btn--sm js-moderator-delete-post"
                                          data-post-id="${post.id}" title="Delete Post">
                                          Delete Post
                                        </button>
                                        <a href="#" class="c-btn c-btn--ghost c-btn--sm">View Reports</a>
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

                                    <button
                                      class="c-btn c-btn--ghost c-btn--sm c-btn--danger-ghost js-moderator-delete-post"
                                      data-post-id="${post.id}" style="margin-left: 12px;" title="Delete Post">
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
                function togglePinnedSection() {
                  const section = document.getElementById('pinned-section');
                  section.classList.toggle('is-collapsed');

                  // Save state to localStorage
                  const isCollapsed = section.classList.contains('is-collapsed');
                  localStorage.setItem('pinnedSectionCollapsed', isCollapsed);

                  // Update icon if needed (lucide handles this on refresh, but for live toggle:)
                  const icon = section.querySelector('.c-pinned-toggle i');
                  if (icon && window.lucide) {
                    // Lucide icons are SVGs, so we rotate the parent button via CSS instead
                  }
                }

                document.addEventListener("DOMContentLoaded", function () {
                  if (window.lucide) window.lucide.createIcons();

                  // Restore collapsed state
                  const section = document.getElementById('pinned-section');
                  if (section && localStorage.getItem('pinnedSectionCollapsed') === 'true') {
                    section.classList.add('is-collapsed');
                  }

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