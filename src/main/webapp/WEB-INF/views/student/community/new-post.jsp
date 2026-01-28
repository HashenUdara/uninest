<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="layout"
tagdir="/WEB-INF/tags/layouts" %> <%@ taglib prefix="dash"
tagdir="/WEB-INF/tags/dashboard" %>

<layout:student-dashboard pageTitle="Community" activePage="community">
  <link
    rel="stylesheet"
    href="${pageContext.request.contextPath}/static/community.css"
  />
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
      <a href="${pageContext.request.contextPath}/student/community"
        >Community</a
      >
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
              Stay updated with the latest discussions and resources from your
              peers.
            </p>
          </div>
        </div>
        <nav class="c-tabs-line" aria-label="Filter">
          <a href="#" class="is-active">Most Upvoted</a>
          <a href="#">Most Recent</a>
          <a href="#">Unanswered</a>
          <a
            href="${pageContext.request.contextPath}/student/community/my-posts"
            >My Posts</a
          >
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
      <section class="u-stack-4">
        <article aria-label="Create a post">
          <form
            action="${pageContext.request.contextPath}/student/community/posts/create"
            method="post"
            enctype="multipart/form-data"
          >
            <h2 class="c-section-title" style="margin-top: 0">Create a Post</h2>

            <div class="c-field">
              <label for="post-title" class="c-label">Post Title</label>
              <input
                id="post-title"
                name="title"
                class="c-input c-input--soft c-input--rect"
                type="text"
                placeholder="Enter post title"
                required
              />
            </div>

            <div class="c-field">
              <label for="post-topic" class="c-label">Topic/Subject (Optional)</label>
              <select 
                id="post-topic" 
                name="topic" 
                class="c-input c-input--soft c-input--rect">
                <option value="Common" selected>Common (General Discussion)</option>
                <c:forEach var="subject" items="${subjects}">
                  <option value="${subject.code} - ${subject.name}">
                    ${subject.code} - ${subject.name}
                  </option>
                </c:forEach>
              </select>
            </div>

            <div class="c-field">
              <label for="post-desc" class="c-label">Content</label>
              <textarea
                id="post-desc"
                name="content"
                class="c-textarea c-textarea--soft"
                rows="6"
                placeholder="Write your post content"
                required
              ></textarea>
            </div>
<!-- forum -->
            <div class="c-field">
              <div class="c-dropzone" id="dropzone">
                <input
                  id="upload-input"
                  name="image"
                  type="file"
                  accept=".jpg,.jpeg,.png,.gif"
                />
                <div class="c-dropzone__inner">
                  <strong>Upload an image</strong>
                  <span class="u-text-muted" style="font-size: var(--fs-sm)"
                    >Browse Files</span
                  >
                  <label
                    for="upload-input"
                    class="c-btn c-btn--secondary c-dropzone__btn"
                    >Upload</label
                  >
                </div>
              </div>
            </div>

            <div class="c-field" id="progress-wrap" style="display: none">
              <div class="u-text-muted" style="margin-bottom: var(--space-2)">
                Uploading...
              </div>
              <div
                class="c-progress"
                role="progressbar"
                aria-valuemin="0"
                aria-valuemax="100"
                aria-valuenow="50"
              >
                <div class="c-progress__bar" style="width: 50%"></div>
              </div>
              <div
                class="u-text-muted"
                style="font-size: var(--fs-xs); margin-top: var(--space-2)"
              >
                50%
              </div>
            </div>

            <div class="c-form-actions">
              <a
                href="${pageContext.request.contextPath}/student/community"
                class="c-btn c-btn--ghost"
                role="button"
                >Cancel</a
              >
              <button class="c-btn" type="submit">Submit Post</button>
            </div>
          </form>
        </article>
      </section>
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
                <span class="c-subject__label">Programming Fundamentals</span>
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
