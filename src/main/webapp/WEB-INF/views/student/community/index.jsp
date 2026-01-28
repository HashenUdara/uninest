<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
          <%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

            <layout:student-dashboard pageTitle="Community" activePage="community">
              <link rel="stylesheet" href="${pageContext.request.contextPath}/static/community.css" />
              <style>
                .c-form-grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                  gap: var(--space-4);
                }
                .c-topic-badge {
                  display: inline-flex;
                  align-items: center;
                  padding: 4px 12px;
                  border-radius: var(--radius-pill);
                  font-size: var(--fs-xs);
                  font-weight: var(--fw-semibold);
                  background: linear-gradient(135deg, rgba(84, 44, 245, 0.1) 0%, rgba(84, 44, 245, 0.05) 100%);
                  color: var(--color-brand);
                  border: 1px solid rgba(84, 44, 245, 0.2);
                  margin-left: auto;
                  white-space: nowrap; /* Prevent text wrapping */
                  flex-shrink: 0; /* Prevent badge from shrinking */
                }
              </style>
              <header class="c-page__header">
                <nav class="c-breadcrumbs" aria-label="Breadcrumb">
                  <a href="${pageContext.request.contextPath}/student/dashboard">Home</a>
                  <span class="c-breadcrumbs__sep">/</span>
                  <a href="${pageContext.request.contextPath}/student/community">Community</a>
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
                        <h1 class="c-page__title">Community</h1>
                        <p class="c-page__subtitle u-text-muted">
                          Stay updated with the latest discussions and resources from your
                          peers.
                        </p>
                      </div>
                      <a href="${pageContext.request.contextPath}/student/community/posts/create"
                        class="c-btn c-btn--secondary"><i data-lucide="plus"></i> New Post</a>
                    </div>
                    <nav class="c-tabs-line" aria-label="Filter">
                      <a href="#" class="is-active">Most Upvoted</a>
                      <a href="#">Most Recent</a>
                      <a href="#">Unanswered</a>
                      <a href="${pageContext.request.contextPath}/student/community/my-posts">My Posts</a>
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
                              <c:if test="${not empty post.topic && post.topic != 'Common'}">
                                <span class="c-topic-badge">${post.topic}</span>
                              </c:if>
                            </div>
                            <div class="c-post__body">
                              <h4 class="c-post__title">
                                <c:if test="${post.pinned}">
                                  <i data-lucide="pin"
                                    style="width: 14px; height: 14px; color: var(--color-brand); margin-right: 4px; display: inline-block; vertical-align: middle;"></i>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
                                  style="color: inherit; text-decoration: none; vertical-align: middle;">
                                  ${post.title}
                                </a>
                              </h4>
                              <p class="u-text-muted">${post.content}</p>
                            </div>
                            <div class="c-post__actions">
                              <button class="c-btn c-btn--ghost c-btn--sm js-upvote" aria-label="Upvote">
                                <i data-lucide="thumbs-up"></i><span class="js-score">${post.likeCount}</span>
                              </button>
                              <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
                                class="c-btn c-btn--ghost c-btn--sm" aria-label="Comments">
                                <i data-lucide="message-square"></i>${post.commentCount}
                              </a>
                              <button class="c-btn c-btn--ghost c-btn--sm js-downvote" aria-label="Downvote">
                                <i data-lucide="thumbs-down"></i>
                              </button>
                            </div>
                          </article>
                        </c:forEach>
                      </div>
                    </div>
                  </section>

                  <script>
                    function togglePinnedSection() {
                      const section = document.getElementById('pinned-section');
                      if (!section) return;
                      section.classList.toggle('is-collapsed');

                      const isCollapsed = section.classList.contains('is-collapsed');
                      localStorage.setItem('pinnedSectionCollapsed', isCollapsed);
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                      if (window.lucide) window.lucide.createIcons();
                      const section = document.getElementById('pinned-section');
                      if (section && localStorage.getItem('pinnedSectionCollapsed') === 'true') {
                        section.classList.add('is-collapsed');
                      }
                    });
                  </script>

                  <!-- Latest posts -->
                  <section class="u-stack-4">
                    <h3 class="c-section-title">Latest Posts</h3>
                    <div class="c-posts">
                      <c:choose>
                        <c:when test="${empty posts}">
                          <p class="u-text-muted">
                            No posts yet. Be the first to share something!
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
                                <c:if test="${not empty post.topic && post.topic != 'Common'}">
                                  <span class="c-topic-badge">${post.topic}</span>
                                </c:if>
                              </div>

                              <div class="c-post__body">
                                <h4 class="c-post__title">
                                  <c:if test="${post.pinned}">
                                    <i data-lucide="pin"
                                      style="width: 14px; height: 14px; color: var(--color-brand); margin-right: 4px; display: inline-block; vertical-align: middle;"></i>
                                  </c:if>
                                  <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
                                    style="color: inherit; text-decoration: none; vertical-align: middle;">
                                    ${post.title}
                                  </a>
                                </h4>
                                <p class="u-text-muted">${post.content}</p>
                                <c:if test="${not empty post.imageUrl}">
                                  <div class="c-post__image">
                                    <img src="${pageContext.request.contextPath}/uploads/${post.imageUrl}"
                                      alt="Post image" />
                                  </div>
                                </c:if>
                              </div>
                              <div class="c-post__actions">
                                <button class="c-btn c-btn--ghost c-btn--sm js-upvote" aria-label="Upvote">
                                  <i data-lucide="thumbs-up"></i><span class="js-score">${post.likeCount}</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
                                  class="c-btn c-btn--ghost c-btn--sm" aria-label="Comments">
                                  <i data-lucide="message-square"></i>${post.commentCount}
                                </a>
                                <button class="c-btn c-btn--ghost c-btn--sm js-downvote" aria-label="Downvote">
                                  <i data-lucide="thumbs-down"></i>
                                </button>
                                <!-- Report Button -->
                                <c:choose>
                                  <c:when test="${post.currentUserReported}">
                                    <button class="c-btn c-btn--ghost c-btn--sm" aria-label="Reported" disabled
                                      style="margin-left: auto; color: #f59e0b; cursor: not-allowed; opacity: 1;">
                                      <i data-lucide="flag" style="fill: #f59e0b;"></i>
                                    </button>
                                  </c:when>
                                  <c:otherwise>
                                    <button class="c-btn c-btn--ghost c-btn--sm js-report-post" aria-label="Report"
                                      onclick="openReportModal(${post.id})"
                                      style="margin-left: auto; color: var(--color-danger);">
                                      <i data-lucide="flag"></i>
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

                <aside class="c-right-panel">
                  <!-- ... (Right panel content remains same) ... -->
                  <section class="c-right-section">
                    <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
                    <ul class="c-subjects" role="list">
                      <!-- ... -->
                    </ul>
                  </section>
                  <!-- ... -->
                </aside>
              </div>

              <!-- Report Modal -->
              <div id="report-modal" class="c-modal-overlay"
                style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 1000; align-items: center; justify-content: center;">
                <div class="c-modal"
                  style="background: var(--panel-bg, #1A1D21); border: 1px solid var(--color-border, #2A2D35); padding: var(--space-6); border-radius: var(--radius-xl); width: 90%; max-width: 420px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); position: relative;">
                  <button type="button" onclick="closeReportModal()" aria-label="Close"
                    style="position: absolute; top: 16px; right: 16px; background: rgba(255,255,255,0.05); border: none; border-radius: 6px; padding: 6px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--color-text-muted);">
                    <i data-lucide="x" style="width: 18px; height: 18px;"></i>
                  </button>
                  <h3 style="margin-top: 0; margin-bottom: var(--space-4); color: var(--color-text); font-size: var(--fs-lg); font-weight: var(--fw-semibold);">Report Post</h3>
                  <form action="${pageContext.request.contextPath}/student/community/posts/report" method="post">
                    <input type="hidden" name="postId" id="report-post-id">
                    <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/student/community">

                    <div class="c-field" style="margin-top: 0;">
                      <label class="c-label" style="color: var(--color-text-muted); margin-bottom: var(--space-2);">Reason for reporting</label>
                      <textarea name="reason" class="c-textarea" rows="4" required
                        placeholder="Why is this inappropriate?"
                        style="background: var(--color-surface, #252830); border: 1px solid var(--color-border, #2A2D35); color: var(--color-text); border-radius: var(--radius-md); padding: var(--space-3); width: 100%; resize: vertical;"></textarea>
                    </div>

                    <div
                      style="display: flex; justify-content: flex-end; gap: var(--space-3); margin-top: var(--space-5);">
                      <button type="button" class="c-btn c-btn--ghost" onclick="closeReportModal()"
                        style="padding: var(--space-2) var(--space-4); border-radius: var(--radius-pill);">Cancel</button>
                      <button type="submit" class="c-btn c-btn--danger"
                        style="padding: var(--space-2) var(--space-4); border-radius: var(--radius-pill);">Submit Report</button>
                    </div>
                  </form>
                </div>
              </div>

              <script>
                function openReportModal(postId) {
                  document.getElementById('report-post-id').value = postId;
                  document.getElementById('report-modal').style.display = 'flex';
                }

                function closeReportModal() {
                  document.getElementById('report-modal').style.display = 'none';
                }

                // Close modal if clicked outside
                document.getElementById('report-modal').addEventListener('click', function (e) {
                  if (e.target === this) {
                    closeReportModal();
                  }
                });
              </script>
              <section class="c-right-section">
                <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
                <ul class="c-subjects" role="list">
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
              <section class="c-right-section">
                <h3 class="c-section-title">Trending</h3>
                <div class="c-tags">
                  <a href="#" class="c-tag">Recursion</a>
                  <a href="#" class="c-tag">Linked Lists</a>
                  <a href="#" class="c-tag">Derivatives</a>
                  <a href="#" class="c-tag">Big-O</a>
                </div>
              </section>
              </aside>
              </div>
            </layout:student-dashboard>