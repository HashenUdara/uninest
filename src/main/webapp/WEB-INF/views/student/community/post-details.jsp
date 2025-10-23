<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ taglib prefix="dash" tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Edit Resource" activePage="resources">
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
             
              <div
                class="o-inline"
                style="
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                  gap: var(--space-4);
                "
              >
                <div>
                  <h1 class="c-page__title">Community</h1>
                  <p class="c-page__subtitle u-text-muted">
                    Stay updated with the latest discussions and resources from
                    your peers.
                  </p>
                </div>
                <a href="${pageContext.request.contextPath}/student/community/new-post" class="c-btn c-btn--secondary"
                  ><i data-lucide="plus"></i> New Post</a
                >
              </div>
              <nav class="c-tabs-line" aria-label="Filter">
                <a href="#" class="is-active">Most Upvoted</a>
                <a href="#">Most Recent</a>
                <a href="#">Unanswered</a>
                <a href="${pageContext.request.contextPath}/student/community/my-posts">My Posts</a>
              </nav>
              <!-- Filters -->
              <div
                class="c-filters u-stack-2"
                role="search"
                style="margin-top: var(--space-4)"
              >
                <div
                  class="o-inline"
                  style="display: flex; gap: var(--space-3); flex-wrap: wrap"
                >
                  <input
                    type="search"
                    class="c-input c-input--soft js-post-search"
                    placeholder="Search posts"
                    aria-label="Search posts"
                    style="min-width: 220px"
                  />
                </div>
              </div>
            </header>

        <article class="c-post-detail">
              <div class="c-post__head">
                <div class="c-avatar-sm">
                  <img
                    alt="Sophia Clark"
                    src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3ESC%3C/text%3E%3C/svg%3E"
                  />
                </div>
                <div>
                  <strong>Sophia Clark</strong>
                  <div class="c-post__meta">2d ago</div>
                </div>
              </div>
              <h1 class="c-post-detail__title" style="margin-top: 1rem">
                How to improve your public speaking skills
              </h1>
              <p class="u-text-muted">
                I'm looking for tips on how to become a more confident and
                engaging public speaker. Any advice or resources would be
                greatly appreciated!
              </p>

              <div class="c-post-detail__image">
                <img src="${pageContext.request.contextPath}/static/img/1.avif" alt="Post image" />
              </div>

              <div class="c-post__stats" aria-label="Post stats">
                <span class="c-stat"><i data-lucide="thumbs-up"></i>23</span>
                <span class="c-stat"
                  ><i data-lucide="message-square"></i>12</span
                >
              </div>

              <section class="c-comments u-stack-4">
                <h3 class="c-section-title" style="margin-top: 2rem">
                  Comments
                </h3>
                <ul class="c-comment-list" role="list">
                  <li class="c-comment">
                    <div class="c-avatar-sm">
                      <img
                        alt="Sophia Clark"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3ESC%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div class="c-comment__body">
                      <div class="c-comment__head">
                        <strong>Sophia Clark</strong>
                        <span class="c-post__meta">2d</span>
                      </div>
                      <p class="u-text-muted">
                        Practice, practice, practice! The more you speak in
                        front of others, the more comfortable you'll become.
                        Start with small groups and gradually work your way up
                        to larger audiences.
                      </p>
                      <ul class="c-comment__children" role="list">
                        <li class="c-comment">
                          <div class="c-avatar-sm">
                            <img
                              alt="Ethan Bennett"
                              src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E6F7EF'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%2325814b' text-anchor='middle' dominant-baseline='middle'%3EEB%3C/text%3E%3C/svg%3E"
                            />
                          </div>
                          <div class="c-comment__body">
                            <div class="c-comment__head">
                              <strong>Ethan Bennett</strong>
                              <span class="c-post__meta">2d</span>
                            </div>
                            <p class="u-text-muted">
                              +1 to Toastmasters. Also, rehearse with a simple
                              outline instead of a full script to keep delivery
                              natural.
                            </p>
                            <ul class="c-comment__children" role="list">
                              <li class="c-comment">
                                <div class="c-avatar-sm">
                                  <img
                                    alt="Olivia Carter"
                                    src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23EAF8E6'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%23287b2c' text-anchor='middle' dominant-baseline='middle'%3EOC%3C/text%3E%3C/svg%3E"
                                  />
                                </div>
                                <div class="c-comment__body">
                                  <div class="c-comment__head">
                                    <strong>Olivia Carter</strong>
                                    <span class="c-post__meta">1d</span>
                                  </div>
                                  <p class="u-text-muted">
                                    Great point. I also timebox practice
                                    sessions (e.g., 10 min) so it's easier to
                                    stay consistent daily.
                                  </p>
                                </div>
                              </li>
                            </ul>
                          </div>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li class="c-comment">
                    <div class="c-avatar-sm">
                      <img
                        alt="Ethan Bennett"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E6F7EF'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%2325814b' text-anchor='middle' dominant-baseline='middle'%3EEB%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div class="c-comment__body">
                      <div class="c-comment__head">
                        <strong>Ethan Bennett</strong>
                        <span class="c-post__meta">3d</span>
                      </div>
                      <p class="u-text-muted">
                        Join a Toastmasters club! It's a supportive environment
                        where you can practice speaking and receive constructive
                        feedback.
                      </p>
                    </div>
                  </li>
                  <li class="c-comment">
                    <div class="c-avatar-sm">
                      <img
                        alt="Olivia Carter"
                        src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23EAF8E6'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%23287b2c' text-anchor='middle' dominant-baseline='middle'%3EOC%3C/text%3E%3C/svg%3E"
                      />
                    </div>
                    <div class="c-comment__body">
                      <div class="c-comment__head">
                        <strong>Olivia Carter</strong>
                        <span class="c-post__meta">4d</span>
                      </div>
                      <p class="u-text-muted">
                        Record yourself speaking and watch it back. This can
                        help you identify areas for improvement, such as your
                        pace, tone, and body language.
                      </p>
                    </div>
                  </li>
                </ul>

                <div class="c-comment-compose">
                  <div class="c-avatar-sm">
                    <img
                      alt="You"
                      src="data:image/svg+xml;utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='36' height='36'%3E%3Crect width='100%25' height='100%25' rx='18' fill='%23E9D8FD'/%3E%3Ctext x='50%25' y='54%25' font-family='Inter, Arial' font-size='14' font-weight='600' fill='%234e35e6' text-anchor='middle' dominant-baseline='middle'%3EYO%3C/text%3E%3C/svg%3E"
                    />
                  </div>
                  <textarea
                    class="c-textarea"
                    rows="4"
                    placeholder="Add a comment"
                  ></textarea>
                  <div class="c-comment-compose__actions">
                    <button class="c-btn c-btn--secondary" type="button">
                      Comment
                    </button>
                  </div>
                </div>
              </section>
            </article>
          </div>

          <aside class="c-right-panel">
            <section class="c-right-section">
              <h3 class="c-section-title" style="margin-top: 0">Subjects</h3>
              <ul class="c-subjects" role="list">
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
