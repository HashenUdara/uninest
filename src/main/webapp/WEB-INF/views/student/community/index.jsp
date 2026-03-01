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
                    <h3 class="c-section-title" style="margin-top: 0">Pinned Posts</h3>
                  </section>

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
                                  </div>
                                </div>
                              </div>

                              <h4 class="c-post__title">
                                <a href="${pageContext.request.contextPath}/student/community/post?id=${post.id}"
                                  style="color: inherit; text-decoration: none;">
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

                              <!-- Poll Display -->
                              <c:if test="${not empty post.poll}">
                                <div class="c-poll"
                                  style="margin-top: var(--space-4); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3);">
                                  <strong
                                    style="display: block; margin-bottom: var(--space-2);">${post.poll.question}</strong>

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
                                          style="margin-top: var(--space-2); font-size: var(--fs-xs); color: var(--color-text-muted); display: flex; justify-content: space-between; align-items: center;">
                                          <span>You have voted.</span>

                                          <%-- Show "Change Vote" button if within 30 minutes --%>
                                            <jsp:useBean id="now" class="java.util.Date" />
                                            <c:if test="${not empty post.poll.currentUserVoteTimestamp}">
                                              <c:set var="timeDiffMillis"
                                                value="${now.time - post.poll.currentUserVoteTimestamp.time}" />
                                              <c:set var="timeDiffMinutes" value="${timeDiffMillis / (1000 * 60)}" />
                                              <c:if test="${timeDiffMinutes < 30}">
                                                <form
                                                  action="${pageContext.request.contextPath}/student/community/polls/vote"
                                                  method="POST" style="margin: 0;">
                                                  <input type="hidden" name="pollId" value="${post.poll.id}">
                                                  <input type="hidden" name="action" value="undo">
                                                  <input type="hidden" name="returnUrl"
                                                    value="${pageContext.request.contextPath}/student/community">
                                                  <button type="submit" class="c-btn c-btn--ghost c-btn--xs"
                                                    style="font-size: 0.75rem;">
                                                    Change Vote
                                                  </button>
                                                </form>
                                              </c:if>
                                            </c:if>
                                        </div>
                                      </c:when>

                                      <%-- CASE 2: User has NOT voted -> Show Vote Form --%>
                                        <c:otherwise>
                                          <form action="${pageContext.request.contextPath}/student/community/polls/vote"
                                            method="POST">
                                            <input type="hidden" name="pollId" value="${post.poll.id}">
                                            <input type="hidden" name="returnUrl"
                                              value="${pageContext.request.contextPath}/student/community">

                                            <div class="u-stack-2">
                                              <c:forEach var="option" items="${post.poll.options}">
                                                <label
                                                  style="display: flex; align-items: center; padding: var(--space-2); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-sm); cursor: pointer; transition: background 0.2s;">
                                                  <input type="${post.poll.allowMultipleChoices ? 'checkbox' : 'radio'}"
                                                    name="optionId" value="${option.id}"
                                                    style="margin-right: var(--space-2);">
                                                  <span>${option.optionText}</span>
                                                </label>
                                              </c:forEach>
                                            </div>

                                            <div
                                              style="margin-top: var(--space-3); display: flex; justify-content: space-between; align-items: center;">
                                              <span style="font-size: var(--fs-xs); color: var(--color-text-muted);">
                                                ${post.poll.allowMultipleChoices ? 'Multiple choices allowed' : 'Single
                                                choice'}
                                              </span>
                                              <button type="submit" class="c-btn c-btn--sm c-btn--primary">Vote</button>
                                            </div>
                                          </form>
                                        </c:otherwise>
                                  </c:choose>
                                </div>
                              </c:if>

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
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </section>
                </div>

                <aside class="c-right-panel">
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